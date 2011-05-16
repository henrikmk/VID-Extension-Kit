REBOL [
	Title: "Scroller Management for VID"
	Short: "Scroller Management for VID"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %ctx-scroll.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 28-Jul-2009
	Date: 28-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Context to manage scrollers for a face in VID.
		NOTE: It does not let scrollers manage the face.
	}
	History: []
	Keywords: []
]

ctx-scroll: context [

v-scroller-face:	; vertical scroller [object! none!]
h-scroller-face:	; horizontal scroller [object! none!]
v-scroll-val-func:	; vertical scroll value function, returns 0 to 1 [function! none!]
h-scroll-val-func:	; horizontal scroll value function, returns 0 to 1 [function! none!]
v-scroll-face-func:	; vertical face scrolling function [function! none!]
h-scroll-face-func:	; horizontal face scrolling function [function! none!]
v-redrag-val-func:	; vertical redrag value function [function! none!]
h-redrag-val-func:	; horizontal redrag value function [function! none!]
step-unit:			; unit step size
tmp:				; temporary face
	none

; ---------- Public Scrolling Functions

; assigns scrollers to face given that they exist 1 and 2 faces in front of this face
assign-scrollers: func [face] [
	tmp: none
	all [
		none? v-scroller-face
		tmp: next-face face
		in tmp 'style
		tmp/style = 'scroller
		v-scroller-face: tmp
	]
	all [
		none? h-scroller-face
		tmp
		tmp: next-face tmp
		in tmp 'style
		tmp/style = 'scroller
		h-scroller-face: tmp
	]
]

; sets the scrollers according to the current x/y position of the face
set-scrollers: func [face] [
	if object? v-scroller-face [set-face v-scroller-face v-scroll-val-func face]
	if object? h-scroller-face [set-face h-scroller-face h-scroll-val-func face]
]

; sets the value to which the scrollers must be redragged
set-redrag: func [face] [
	if object? v-scroller-face [v-scroller-face/redrag v-redrag-val-func face]
	if object? h-scroller-face [h-scroller-face/redrag h-redrag-val-func face]
]

; sets the face scrolling value
set-face-scroll: func [face x y] [
	if x [h-scroll-face-func face x]
	if y [v-scroll-face-func face y]
	set-scrollers face
]

; ---------- Standard Scrolling Functions

; standard horizontal scroll value function
h-scroll-val-func: func [face] [
	either iterated-face? face [
		face/sub-face/offset/x / face/sub-face/size/x - face/size/x
	][
		face/pane/offset/x / face/pane/size/x - face/size/x
	]
]

; standard vertical scroll value function
v-scroll-val-func: func [face] [
	either iterated-face? face [
		face/sub-face/offset/y / face/sub-face/size/y - face/size/y
	][
		face/pane/offset/y / face/pane/size/y - face/size/y
	]
]

; standard horizontal scrolling function
h-scroll-face-func: func [face x /local edge fp] [
	edge: 2 * any [attempt [face/edge/size] 0]
	fp: either iterated-face? face [face/sub-face][face/pane]
	if all [x fp/size/x > face/size/x] [
		fp/offset/x: face/size/x - edge/x - fp/size/x * x
	]
]

; standard vertical scrolling function
v-scroll-face-func: func [face y /local edge] [
	edge: 2 * any [attempt [face/edge/size] 0]
	if all [y face/pane/size/y > face/size/y] [
		face/pane/offset/y: face/size/y - edge/y - face/pane/size/y * y
	]
]

; standard horizontal redrag value function
h-redrag-val-func: func [face] [
	either iterated-face? face [
		face/size/x / face/sub-face/size/x
	][
		face/size/x / face/pane/size/x
	]
]

; standard vertical redrag value function
v-redrag-val-func: func [face] [
	either iterated-face? face [
		face/size/y / face/sub-face/size/y
	][
		face/size/y / face/pane/size/y
	]
]

]