REBOL [
	Title: "Right Align Test"
	Short: "Right Align Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %right-align.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-Jun-2010
	Date: 26-Jun-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test of aligning right inside a fill 1x0 panel.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

view make-window [
	bar 600 ; for allowing fill 1x0 to work
;	panel yellow 500x24 fill 0x0 [
		; [ ] - this is not right aligned, but takes up the entire width, unless spring [left] is used
		;       not sure why this happens
		; [ ] - spring [left right] does not update to proper position until after resize
		;       possibly because resize never occurs for the inner panel as it has no fill
		;       this is not the case. the cause is different.
		;       it doesn't have anything to do with the outer fill
		panel fill 0x0 align [right] spring [left right] red [
			across
			label
			button 150
		]
;	]
]

