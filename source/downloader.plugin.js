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

	function exists (path) {
		return new Promise(function (resolve) {
			fsUtil.exists(path, resolve)
		})
	}

	function mkdirp (path) {
		return new Promise(function (resolve, reject) {
			require('mkdirp')(path, function (err) {
				if (err) reject(err)
				resolve()
			})
		})
	}

	function extract (download, options, docpad) {
		return decompress(download.tmp, download.path, options).then(function () {
			docpad.log('info', `Extracted: ${download.name}`)
		})
	}

	function fetch (download, httpBasicOptions, docpad) {
		return new Promise(function (resolve, reject) {
			docpad.log('info', `Downloading: ${download.name}`)
			request(download.method || 'GET', download.url, httpBasicOptions, function (err, res) {
				if (err) reject(err)

				res.body.on('end', resolve)
				res.body.on('error', reject)

				if (download.decompress) {
					download.hash = crypto.createHash('md5').update(download.url).digest('hex')
					download.tmp = pathUtil.join(tmpdir, download.hash)
				}

				res.body.pipe(fsUtil.createWriteStream(download.tmp || download.path))
			})
		}).then(function () {
			docpad.log('info', `Downloaded: ${download.name}`)
			if (!download.decompress) return Promise.resolve()
			docpad.log('info', `Extracting: ${download.name}`)
			const options = download.decompress === true ? {} : download.decompress
			return extract(download, options, docpad).catch(() => extract(download, options, docpad)).catch(function (err) {
				docpad.log('warn', `Failed to extract: ${download.name}`, download, options)
				return Promise.reject(err)
			})
		}).catch(function (err) {
			docpad.log('warn', `Failed to download: ${download.name}`)
			return Promise.reject(err)
		})
	}


	// Define Plugin
	return class DownloaderPlugin extends BasePlugin {
		// Plugin Name
		get name () { return 'downloader' }

		// Plugin Config
		get initialConfig () {
			return {
				downloads: null,
				cleanOnReset: false,
				httpBasicOptions: {
					followRedirects: true,
					gzip: true
				}
			}
		}

		// Clone/Update our DocPad Documentation Repository
		docpadReady (opts, next) {
			// Prepare
			const docpad = this.docpad
			const docpadConfig = docpad.getConfig()
			const config = this.getConfig()
			const downloads = config.downloads || []
			const cleanOnReset = config.cleanOnReset

			// Skip if
			// - we have no downloads
			// - we only want to download on reset, and we are not a reset
			if (downloads.length === 0 || (cleanOnReset && opts.reset === false)) {
				return next()
			}

			// Expand download paths
			downloads.forEach(function (download) {
				download.path = download.path
					.replace(/^src\/documents/, docpadConfig.documentsPaths[0])
					.replace(/^src\/files/, docpadConfig.filesPaths[0])
					.replace(/^src/, docpadConfig.srcPath)
					.replace(/^out/, docpadConfig.outPath)
				download.directory = pathUtil.dirname(download.path)
			})

			// Downlod
			Promise.all(
				downloads.map(function (download) {
					return exists(download.path).then(function (exists) {
						if (exists) {
							docpad.log('info', `Already downloaded: ${download.name}`)
							return Promise.resolve()
						}
						return mkdirp(download.directory).then(function () {
							return fetch(download, config.httpBasicOptions, docpad)
						})
					})
				})
			).then(() => next()).catch(next)
		}
	}
}
