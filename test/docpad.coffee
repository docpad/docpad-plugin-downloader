module.exports =
	plugins:
		downloader:
			downloads: [
				{
					name: 'Zip Bundle'
					path: 'src/documents/zip'
					url: 'https://gist.github.com/balupton/5432249/archive/dd29c677a72fd7ca53c5aadf5437a4167b389a21.zip',
					decompress: {strip: 1}
				},
				{
					name: 'Tar Bundle'
					path: 'src/documents/tar'
					url: 'https://gist.github.com/balupton/5432249/archive/dd29c677a72fd7ca53c5aadf5437a4167b389a21.tar.gz',
					decompress: {strip: 1}
				}
				{
					name: 'Gist File'
					path: 'src/documents/a.html.md'
					url: 'https://gist.github.com/balupton/5432249/raw/1e1cd6d374d0565aaab30566ec9055219d857aec/a.html.md'
				}
			]
