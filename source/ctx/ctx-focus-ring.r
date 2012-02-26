REBOL [
	Title: "Focus Ring Management Context"
	Short: "Focus Ring Management Context"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %ctx-focus-ring.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 16-Jul-2009
	Date: 16-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Management and display of the focus ring.
	}
	History: []
	Keywords: []
]

ctx-focus-ring: context [

focus-edge: func [side] [
	make get-style 'face [
		size: 2x2
		color: ctx-colors/colors/focus-ring-color
		edge: none
		style: 'highlight
		var: side
		flags: []
		show?: false
		feel: none
	]
]

set 'make-focus-ring does [
	reduce [
		focus-edge 'top
		focus-edge 'left
		focus-edge 'right
		focus-edge 'bottom
	]
]

; sets the position and offset for the four focus ring faces
set 'set-focus-ring func [face /tab-face tf /root rf /no-show /local edge offset top left right bottom fp sides] [
	any [face return face]
	tab-face: any [tf get-tab-face face]
	any [tab-face return face]
	top: left: right: bottom: none
	sides: [top left right bottom]
	set sides get in any [rf root-face face] 'focus-ring-faces
	if any [not in top 'style 'highlight <> get in top 'style] [return face] ; for LAYOUT
	if tab-face/style = 'window [hide :sides return face] ; perhaps only temporary
	bottom/size/x: top/size/x: tab-face/size/x + 4
	top/offset: tab-face/offset - 2
	left/offset: tab-face/offset - 2x0
	right/size/y: left/size/y: tab-face/size/y
	right/offset: tab-face/size * 1x0 + tab-face/offset
	bottom/offset: tab-face/size * 0x1 - 2x0 + tab-face/offset
	fp: tab-face/parent-face
	while [all [fp fp/style <> 'window]] [
		edge: any [all [in fp 'edge fp/edge fp/edge/size] 0x0]
		offset: edge + fp/offset
		top/offset: top/offset + offset
		left/offset: left/offset + offset
		right/offset: right/offset + offset
		bottom/offset: bottom/offset + offset
		fp: fp/parent-face
	]
	unless no-show [
		foreach side sides [set in get side 'show? true] ; necessary if the window has not been shown before
		show :sides
	]
	face
]

; hides the highlight faces
set 'unset-focus-ring func [face /local f fc] [
	f: root-face face
	foreach fc get in f 'focus-ring-faces [hide fc]
]

]