REBOL [
	Title: "Sub-Panel Test"
	Short: "Sub-Panel Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %sub-panel.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 29-May-2011
	Date: 29-May-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test custom cell rendering in DATA-LIST using RENDER.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

panels: [
	a [button]
	b [field]
	c [data-list fill 1x1]
]

panel-words: extract panels 2

view make-window [
	h3 "Sub-Panels"
	bar
	across
	d: data-list fill 0x1 spring [right] data panel-words setup [input [panels]]
		on-click [set-face p value/1]
	balancer
	p: frame 300x300 setup panels
	do [select-face d 1]
]