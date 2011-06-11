REBOL [
	Title: "Left Right Align Test"
	Short: "Left Right Align Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %left-right-align.r
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
		Test of aligning left and right inside a window. Should produce a centered item panel.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

insert insert insert clear ctx-vid-debug/debug 'face 'align 'resize

view make-window [
	b1: button "B1" 600 spring [bottom]
	; [ ] - spring [left right] does not update to proper position until after resize
	;       possibly because resize never occurs for the inner panel as it has no fill
	;       this is not the case. the cause is different.
	;       it doesn't have anything to do with the outer fill
	;       it aligns but does not resize, so I'm still guessing that resize is skipped
	;       resize does not occur at all
	p1: panel 500x100 red spring [left right] align [left right] [ ;  this is rendered correctly
		; this presents a bug: the spring acts first, and then fill, which moves it to the right
		origin 0 space 0
		b2: button "B2" 500 ; claimed offset of 0x0
		b3: button "B3" align [left right]
		b4: button "B4" 120 align [left right]
		b5: button "B5" 150 align [left right]
		b6: button "B6"
		b7: button "B7" 120
		b8: button "B8" 150
		b9: button "B9" align [right]
		b10: button "B10" 120 align [right]
		b11: button "B11" 150 align [right]
	]
]

