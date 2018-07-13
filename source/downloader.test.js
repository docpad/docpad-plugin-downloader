// Test our plugin using DocPad's Testers
'use strict'

module.exports = require('docpad').require('testers').test({
	testerClass: 'RendererTester',
	pluginPath: require('path').join(__dirname, '..')
}, {
	logLevel: 6
})
