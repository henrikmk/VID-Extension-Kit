REBOL [
	Title: "VID Tool Tip Face"
	Short: "VID Tool Tip Face"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %vid-tool-tip.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-May-2010
	Date: 26-May-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Management and display of tool-tips
	}
	History: []
	Keywords: []
]

ctx-tool-tip: context [

; creates a tool-tip face
set 'make-tool-tip does [
	make get-style 'face [
		size: 0x0
		color: white
		font: make font [color: black shadow: none size: 12]
		edge: make face/edge [color: black size: 1x1]
		style: 'tool-tip
		flags: []
		show?: false
		feel: none
	]
]

tip-content: none		; the content of the tool tip can be either a string, block, object or function
tool-tip-face: none		; the tool tip face in the window
test-tip-face:			; tool tip face for determining face text size for pure string tool tips
	make make-tool-tip [show?: true size: 1000x40]

; returns the tool-tip face for a particular window
set 'get-tool-tip func [face] [
	any [face: root-face face return none]
	foreach fc any [get in face 'pane []] [
		if fc/style = 'tool-tip [return fc]
	]
]

; sets the tool tip to particular content
set 'set-tool-tip func [fc offset /local sz] [
	;-- Locate appropriate tool tip
	any [tool-tip-face: get-tool-tip fc exit]
	any [get in fc 'tool-tip ascend-face fc [all [get in face 'tool-tip fc: face break]]]
	any [tip-content: get in fc 'tool-tip exit]
	all [any-function? :tip-content tip-content: tip-content fc]
	any [block? tip-content object? tip-content tip-content: form tip-content]
	;-- Determine content of tool tip
	either string? tip-content [
		tool-tip-face/pane: none
		tool-tip-face/text: copy test-tip-face/text: copy tip-content
		tool-tip-face/real-size: none
		tool-tip-face/size: 6 + size-text test-tip-face
	][
		tool-tip-face/pane:
			either block? tip-content [
				layout/tight tip-content
			][
				tip-content ; face
			]
		tool-tip-face/size: tool-tip-face/pane/size
	]
	root: root-face fc
	;-- Display of tool tip
	; the tool-tip offset is 0x0 in OSX due to a bug in face/feel/detect on event/offset during a timer event
	tool-tip-face/offset: max 0x0 offset + 0x25 ; so we don't obscure the pointer
	sz: tool-tip-face/offset + tool-tip-face/size
	if sz/x > root/size/x [tool-tip-face/offset/x: root/size/x - tool-tip-face/size/x]
	if sz/y > root/size/y [tool-tip-face/offset/y: tool-tip-face/offset/y - 50]
	show tool-tip-face
]

; unsets the content of the tool tip and hide it
set 'unset-tool-tip func [face] [
	any [tool-tip-face: get-tool-tip face exit]
	hide tool-tip-face
	tool-tip-face/pane: none
]

]