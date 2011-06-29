REBOL [
	Title:  "REBOL/View: Focus Ring Indication"
	Author: "Henrik Mikael Kristensen"
	Rights: "Copyright 2000 REBOL Technologies. All rights reserved."
	Note:   {Improvements to this code are welcome, but all changes preserve the above copyright.}
	Purpose: {
		Management and display of the focus ring
	}
	; You are free to use, modify, and distribute this software with any
	; REBOL Technologies products as long as the above header, copyright,
	; and this comment remain intact. This software is provided "as is"
	; and without warranties of any kind. In no event shall the owners or
	; contributors be liable for any damages of any kind, even if advised
	; of the possibility of such damage. See license for more information.

	; Please help us to improve this software by contributing changes and
	; fixes via http://www.rebol.com/feedback.html - Thanks!

	; Changes in this file are contributed by Henrik Mikael Kristensen.
	; Changes and fixes to this file can be contributed to Github at:
	; https://github.com/henrikmk/VID-Extension-Kit
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