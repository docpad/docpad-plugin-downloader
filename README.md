# Downloader Plugin for [DocPad](http://docpad.org)

[![Build Status](https://secure.travis-ci.org/docpad/docpad-plugin-downloader.png?branch=master)](http://travis-ci.org/docpad/docpad-plugin-downloader "Check this project's build status on TravisCI")
[![NPM version](https://badge.fury.io/js/docpad-plugin-downloader.png)](https://npmjs.org/package/docpad-plugin-downloader "View this project on NPM")
[![Gittip donate button](http://badgr.co/gittip/docpad.png)](https://www.gittip.com/docpad/ "Donate weekly to this project using Gittip")
[![Flattr donate button](https://raw.github.com/balupton/flattr-buttons/master/badge-89x18.gif)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](https://www.paypalobjects.com/en_AU/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")


Download (and optionally extract) files into your project before your project starts generating


## Install

```
docpad install downloader
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
					tarExtractClean: true
				}
				{
					name: 'Gist File'
					path: 'src/documents/a.html.md'
					url: 'https://gist.github.com/balupton/5432249/raw/1e1cd6d374d0565aaab30566ec9055219d857aec/a.html.md'
				}
			]
```

Available download options:

- `name` string, name of the download, for logging purposes only
- `path` string, path that the completed download is placed
- `url` string, url the download is retrieved from
- `deflate` boolean, whether or not we should deflate the response when fetching the download (auto-detected if not set)
- `gzip` boolean, whether or not we should unzip the response when fetching the download (auto-detected if not set)
- `tarExtract` boolean, whether or not we should extract tar downloads (auto-detected if not set)
- `tarExtractClean` boolean, whether or not when performing a tar extraction if we should remove the root directory of the extracted files



## History
[You can discover the history inside the `History.md` file](https://github.com/bevry/docpad-plugin-downloader/blob/master/History.md#files)


## Contributing
[You can discover the contributing instructions inside the `Contributing.md` file](https://github.com/bevry/docpad-plugin-downloader/blob/master/Contributing.md#files)


## License
Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT License](http://creativecommons.org/licenses/MIT/)
<br/>Copyright &copy; 2012+ [Bevry Pty Ltd](http://bevry.me) <us@bevry.me>
