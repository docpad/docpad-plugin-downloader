# Export Plugin
module.exports = (BasePlugin) ->
	# Import
	{TaskGroup} = require('taskgroup')
	hyperquest = require('hyperquest')
	tar = require('tar')
	rimraf = require('rimraf')
	zlib = require('zlib')
	fsUtil = require('fs')
	pathUtil = require('path')
	ProgressBar = require('progress')

	# Define Plugin
	class DownloaderPlugin extends BasePlugin
		# Plugin Name
		name: 'downloader'

		# Plugin Config
		config:
			downloads: null
			cleanOnReset: false

		# Clone/Update our DocPad Documentation Repository
		generateBefore: (opts,next) ->
			# Prepare
			docpad = @docpad
			config = @getConfig()
			docpadConfig = docpad.getConfig()
			tasks = new TaskGroup().setConfig(concurrency:0).once('complete',next)
			downloads = config.downloads or []
			cleanOnReset = config.cleanOnReset

			# Cycle through the downloads
			downloads.forEach (download) -> tasks.addTask (complete) ->
				# Normalize path
				download.path = download.path
					.replace(/^src\/documents/, docpadConfig.documentsPaths[0])
					.replace(/^src\/files/, docpadConfig.filesPaths[0])
					.replace(/^src/, docpadConfig.srcPath)
					.replace(/^out/, docpadConfig.outPath)

				# Skip the download if
				# - we care about resets and this is not a rest
				# - our path already exists
				return complete()  if (cleanOnReset and opts.reset is false) or fsUtil.existsSync(download.path) is true

				# Prepare
				download.extract ?= true
				download.gzip ?= false
				download.tar ?= false
				download.tarclean ?= false
				errord = false
				cleanDirs = []
				errorHandler = (err) ->
					if err
						docpad.warn(err)
						errord = true
				successHandler = (err) ->
					errorHandler(err)  if err
					unless errord
						docpad.log('info', "Downloaded #{download.name}")  unless errord

				# Request
				req = hyperquest(download.url)

				# Progress
				req.on 'response', (res) ->
					len = res.headers['content-length'] or 0
					unless len
						docpad.log('info', "Downloading #{download.name}")
						return

					len = parseInt(len,10)
					bar = new ProgressBar("Downloading #{download.name} [:bar] :percent :etas", {
						complete: '='
						incomplete: ' '
						width: 20
						total: len
					})

					res.on 'data', (chunk) ->
						bar.tick(chunk.length)

					res.on 'end', ->
						console.log('\n')

				# Gzip
				if download.deflate
					req = req.pipe(zlib.createDeflate())

				# Gzip
				if download.gzip
					req = req.pipe(zlib.createGunzip())

				# Tar
				if download.tar
					req = req.pipe(tar.Extract(download.path))
					if download.tarclean
						req.on 'entry', (entry) ->
							entryPathParts = entry.path.split(/[\\\/]/)
							cleanDirs.push(entryPathParts[0])  unless entryPathParts[0] in cleanDirs
							entry.path = entryPathParts.slice(1).join(pathUtil.sep)
				else
					req = req.pipe(fsUtil.createWriteStream(download.path))

				# Finish
				req.on 'error', (err) ->
					errorHandler(err)
					cleanDirs.forEach (cleanDir) -> tasks.addTask (complete) ->
						rimraf(pathUtil.join(download.path, cleanDir), complete)
				req.on 'close', ->
					cleanDirs.forEach (cleanDir) -> tasks.addTask (complete) ->
						rimraf(pathUtil.join(download.path, cleanDir), complete)
					successHandler()
					complete()

			# Fire
			tasks.run()
			return
