// @ts-nocheck
/* eslint class-methods-use-this:0 */
'use strict'

// Export Plugin
module.exports = function (BasePlugin) {
	// Import
	const request = require('http-basic')
	const fsUtil = require('fs')
	const pathUtil = require('path')
	const decompress = require('decompress')
	const tmpdir = require('os').tmpdir()
	const crypto = require('crypto')
	const mkdirp = require('mkdirp')

	function exists(path) {
		return new Promise(function (resolve) {
			fsUtil.exists(path, resolve)
		})
	}

	function extract(download, options, docpad) {
		return decompress(download.tmp, download.path, options)
			.then(function () {
				docpad.log('debug', 'downloader: extracted', download)
			})
			.catch(function (err) {
				docpad.log(
					'warn',
					'downloaded: failed to extract',
					download,
					err,
					options
				)
				return Promise.reject(err)
			})
	}

	function fetch(download, httpBasicOptions, docpad) {
		return new Promise(function (resolve, reject) {
			request(
				download.method || 'GET',
				download.url,
				httpBasicOptions,
				function (err, res) {
					if (err) {
						docpad.log('warn', 'downloader: failed on', download, err)
						return reject(err)
					}

					if (download.decompress) {
						download.hash = crypto
							.createHash('md5')
							.update(download.url)
							.digest('hex')
						download.tmp = pathUtil.join(tmpdir, download.hash)
					}

					res.body.on('end', resolve)
					res.body.on('error', reject)

					res.body.pipe(fsUtil.createWriteStream(download.tmp || download.path))
				}
			)
		})
			.then(function () {
				docpad.log('debug', 'downloader: downloaded', download)
				if (!download.decompress) return Promise.resolve()
				docpad.log('debug', 'downloader: extracting', download)
				const options = download.decompress === true ? {} : download.decompress
				return extract(download, options, docpad)
			})
			.catch(function (err) {
				docpad.log('warn', 'downloaded: failed to download', download)
				return Promise.reject(err)
			})
	}

	// Define Plugin
	return class DownloaderPlugin extends BasePlugin {
		// Plugin Name
		get name() {
			return 'downloader'
		}

		// Plugin Config
		get initialConfig() {
			return {
				downloads: null,
				cleanOnReset: false,
				httpBasicOptions: {
					followRedirects: true,
					gzip: true,
				},
			}
		}

		// Clone/Update our DocPad Documentation Repository
		docpadReady(opts, next) {
			// Prepare
			const docpad = this.docpad
			const config = this.getConfig()
			const downloads = config.downloads || []
			const cleanOnReset = config.cleanOnReset

			// Skip if
			// - we have no downloads
			// - we only want to download on reset, and we are not a reset
			if (downloads.length === 0 || (cleanOnReset && opts.reset === false)) {
				docpad.log('info', 'downloader: nothing to download')
				return next()
			}

			// Expand download paths
			downloads.forEach(function (download) {
				download.path = download.path
					.replace(/^src\/documents/, docpad.getPath('document'))
					.replace(/^src\/files/, docpad.getPath('file'))
					.replace(/^src/, docpad.getPath('source'))
					.replace(/^out/, docpad.getPath('out'))
				download.directory = pathUtil.dirname(download.path)
			})

			docpad.log('debug', 'downloader: downloading', downloads)

			// Downlod
			Promise.all(
				downloads.map(function (download) {
					return exists(download.path).then(function (exists) {
						if (exists) {
							docpad.log(
								'info',
								'downloader: already downloaded',
								download.name
							)
							return Promise.resolve()
						}
						return mkdirp(download.directory).then(function () {
							docpad.log('debug', 'downloader: fetching', download)
							return fetch(download, config.httpBasicOptions, docpad).then(() =>
								docpad.log('info', 'downloader: downloaded', download.name)
							)
						})
					})
				})
			)
				.then(() => next())
				.catch(next)
		}
	}
}
