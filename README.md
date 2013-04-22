# Downloader Plugin for [DocPad](http://docpad.org)

[![Build Status](https://secure.travis-ci.org/docpad/docpad-plugin-downloader.png?branch=master)](http://travis-ci.org/docpad/docpad-plugin-downloader)
[![NPM version](https://badge.fury.io/js/docpad-plugin-downloader.png)](https://npmjs.org/package/bal-util)
[![Flattr this project](https://raw.github.com/balupton/flattr-buttons/master/badge-89x18.gif)](http://flattr.com/thing/344188/balupton-on-Flattr)

Download (and optionally extract) files into your project before your project starts generating


## Install

```
npm install --save docpad-plugin-downloader
```



## Usage

Define the following inside your [docpad configuration file](http://docpad.org/docs/config), changing the `repo` values to what you desire:

``` coffee
module.exports =
	plugins:
		downloader:
			downloads: [
				{
					name: 'Gist Bundle'
					path: 'src/documents/gist'
					url: 'https://gist.github.com/balupton/5432249/download'
					gzip: true
					tar: true
					tarclean: true
				}
				{
					name: 'Gist File'
					path: 'src/documents/a.html.md'
					url: 'https://gist.github.com/balupton/5432249/raw/1e1cd6d374d0565aaab30566ec9055219d857aec/a.html.md'
				}
			]
```



## History
You can discover the history inside the [History.md](https://github.com/docpad/docpad-plugin-downloader/blob/master/History.md#files) file



## License
Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT License](http://creativecommons.org/licenses/MIT/)
<br/>Copyright &copy; 2013+ [Bevry Pty Ltd](http://bevry.me)