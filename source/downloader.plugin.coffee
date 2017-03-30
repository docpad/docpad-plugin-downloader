# Export Plugin
module.exports = (BasePlugin) ->
	# Import
	{TaskGroup} = require('taskgroup')
	hyperquest = require('hyperquest')
	tar = require('tar')
	rimraf = require('rimraf')
	ProgressBar = require('progress')
	zlib = require('zlib')
	fsUtil = require('fs')
	pathUtil = require('path')
	stream = require('stream')
	domain = require('domain')

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
			downloads = config.downloads or []
			cleanOnReset = config.cleanOnReset

			# Skip if
			# - we have no downloads
			# - we only want to download on reset, and we are not a reset
			return next()  if downloads.length is 0 or (cleanOnReset and opts.reset is false)

			# Expand download paths
			docpadConfig = docpad.getConfig()
			downloads.forEach (download) ->
				# Normalize path
				download.path = download.path
					.replace(/^src\/documents/, docpadConfig.documentsPaths[0])
					.replace(/^src\/files/, docpadConfig.filesPaths[0])
					.replace(/^src/, docpadConfig.srcPath)
					.replace(/^out/, docpadConfig.outPath)

			# Tasks
			tasks = new TaskGroup().setConfig(concurrency:0).once 'complete', (err) ->
				# No need to cleanup as everything worked
				return next()  unless err

				# Cleanup as something failed
				docpad.warn(err)
				cleanTasks = new TaskGroup().setConfig(concurrency:0).once('complete',next)
				downloads.forEach (download) -> cleanTasks.addTask (complete) ->
					rimraf(download.path, complete)
				cleanTasks.run()

			# Cycle through the downloads
			downloads.forEach (download) -> tasks.addTask (complete) ->
				# Skip the download if our path already exists
				return complete()  if fsUtil.existsSync(download.path) is true

				# Errors
				d = domain.create()
				d.on('error', complete)
				d.run ->
					# Request
					req = hyperquest(download.url,{
						headers:
							'accept-encoding': 'gzip,deflate'
					})
					out = req

					# Handle
					req.on 'response', (res) ->
						# Progress
						len = res.headers['content-length'] or 0
						if len
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
						else
							docpad.log('info', "Downloading #{download.name}")

						# Prepare
						download.deflate ?= res.headers['content-encoding'] is 'deflate'
						download.gzip ?= res.headers['content-encoding'] is 'gzip' or (res.headers['content-type'] or '').indexOf('gzip') isnt -1
						download.tarExtract ?= (res.headers['content-disposition'] or '').indexOf('.tar') isnt -1
						download.tarExtractClean ?= false

						# Deflate
						if download.deflate
							out = out.pipe(zlib.createInflate())

						# Gzip
						if download.gzip
							out = out.pipe(zlib.createGunzip())

						# Tar
						if download.tarExtract
							out = tar = out.pipe(tar.Extract(download.path))
							if download.tarExtractClean
								cleanDirs = []
								tar.on 'entry', (entry) ->
									entryPathParts = entry.path.split(/[\\\/]/)
									cleanDirs.push(entryPathParts[0])  unless entryPathParts[0] in cleanDirs
									entry.path = entryPathParts.slice(1).join(pathUtil.sep)
								tar.on 'close', ->
									cleanDirs.forEach (cleanDir) -> tasks.addTask (complete) ->
										rimraf(pathUtil.join(download.path, cleanDir), complete)
						# File
						else
							out = out.pipe(fsUtil.createWriteStream(download.path))

						# Complete
						out.on('close',complete)

			# Fire
			tasks.run()
			return
