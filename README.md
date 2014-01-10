# Downloader Plugin for [DocPad](http://docpad.org)

<!-- BADGES/ -->

[![Build Status](http://img.shields.io/travis-ci/docpad/docpad-plugin-downloader.png?branch=master)](http://travis-ci.org/docpad/docpad-plugin-downloader "Check this project's build status on TravisCI")
[![NPM version](http://badge.fury.io/js/docpad-plugin-downloader.png)](https://npmjs.org/package/docpad-plugin-downloader "View this project on NPM")
[![Dependency Status](https://david-dm.org/docpad/docpad-plugin-downloader.png?theme=shields.io)](https://david-dm.org/docpad/docpad-plugin-downloader)
[![Development Dependency Status](https://david-dm.org/docpad/docpad-plugin-downloader/dev-status.png?theme=shields.io)](https://david-dm.org/docpad/docpad-plugin-downloader#info=devDependencies)<br/>
[![Gittip donate button](http://img.shields.io/gittip/docpad.png)](https://www.gittip.com/docpad/ "Donate weekly to this project using Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a "Donate once-off to this project using BitCoin")

<!-- /BADGES -->


Download (and optionally extract) files into your project before your project starts generating


## Install

``` bash
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


<!-- HISTORY/ -->

## History
[Discover the change history by heading on over to the `HISTORY.md` file.](https://github.com/docpad/docpad-plugin-downloader/blob/master/HISTORY.md#files)

<!-- /HISTORY -->


<!-- CONTRIBUTE/ -->

## Contribute

[Discover how you can contribute by heading on over to the `CONTRIBUTING.md` file.](https://github.com/docpad/docpad-plugin-downloader/blob/master/CONTRIBUTING.md#files)

<!-- /CONTRIBUTE -->


<!-- BACKERS/ -->

## Backers

### Maintainers

These amazing people are maintaining this project:

- Benjamin Lupton <b@lupton.cc> (https://github.com/balupton)

### Sponsors

No sponsors yet! Will you be the first?

[![Gittip donate button](http://img.shields.io/gittip/docpad.png)](https://www.gittip.com/docpad/ "Donate weekly to this project using Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a "Donate once-off to this project using BitCoin")

### Contributors

These amazing people have contributed code to this project:

- [Benjamin Lupton](https://github.com/balupton) <b@lupton.cc> — [view contributions](https://github.com/docpad/docpad-plugin-downloader/commits?author=balupton)

[Become a contributor!](https://github.com/docpad/docpad-plugin-downloader/blob/master/CONTRIBUTING.md#files)

<!-- /BACKERS -->


<!-- LICENSE/ -->

## License

Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT license](http://creativecommons.org/licenses/MIT/)

Copyright &copy; 2012+ Bevry Pty Ltd <us@bevry.me> (http://bevry.me)

<!-- /LICENSE -->


