REBOL [
	Title: "Panel Test"
	Short: "Panel Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %panel.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 06-Jun-2011
	Date: 06-Jun-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test basic PANEL and derivatives with short-cuts for typical spring setups.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

view make-window [
	h3 "Panel"
	bar
	panel [
		top-panel [button button button]
		left-panel [button button button]
		right-panel [button button button]
		bottom-panel [button button button]
	]
]