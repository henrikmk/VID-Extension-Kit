REBOL [
	Title: "VID Menu Face"
	Short: "VID Menu Face"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %menu-face.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 27-May-2010
	Date: 27-May-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Handling and display of menu faces.
	}
	History: []
	Keywords: []
]

ctx-menu: context [

content:		; face content generated for menu face, function, block or object
menu-face:		; the menu face in the window
opener-face:	; the face that opens the menu face
	none

; creates a menu face, which is a compound face, holding other faces
; no longer in use
;set 'make-menu-face does [
;	make get-style 'face [
;		size: 0x0
;		style: 'menu
;		flags: [panel action scrollable]
;		show?: false
;		opener-face: none
;		feel: none?
;		access: make object! [
;			key-face*: func [face event] [
;				key-face face/pane/1 event
;			]
;			above: func [face] [face/offset/y < 0]
;			below: func [face] [(face/offset/y + face/size/y) > face/parent-face/size/y]
;			; this may be too specific to the scrolling list for CHOICE, so perhaps it should be located inside the list face instead of here
;			;-- scrolls the menu-face into view if it's beyond the top or bottom border of the parent face
;			scroll-face*: func [face x y /local dir step-size move line-height] [
;				dir: pick [-1 1] positive? y
;				line-height: opener-face/size/y - (2 * opener-face/draw-body/margin/y)
;				move: does [face/offset/y: line-height * dir + face/offset/y]
;				any [
;					all [above face below face move]
;					case [
;						above face [
;							if positive? dir [move]
;						]
;						below face [
;							if negative? dir [move]
;						]
;					]
;				]
;				;-- restrain to opener-face
;				face/offset/y: max face/offset/y (opener-face/win-offset/y + line-height - face/size/y + (2 * second edge-size face))
;				face/offset/y: min face/offset/y opener-face/win-offset/y
;			]
;		]
;		init: [
;			insert-actor-func self 'on-deactivate func [face] [hide-menu-face]
;			insert-actor-func self 'on-escape func [face] [hide-menu-face]
;		]
;	]
;]

; returns the menu face
set 'get-menu-face does [
	menu-face
]

; returns the opener-face face, if any exist in the window
set 'get-opener-face does [
	opener-face
]

; [ ] - tab order should mean that the next face after opener-face is menu-face
; [ ] - tab order could also temporarily be constrained to inside the menu face here, as it does this in OSX
; [ ] - need a tab base constraint, as this will also work for subwindows
; [ ] - stack multiple opener faces for submenus

set 'show-menu-face func [fc content /offset os /hinge face1 face2] [
	;-- Create the menu face
	opener-face: fc
	menu-face: make-window content
	menu-face/opener-face: fc
	insert-actor-func menu-face 'on-deactivate :hide-menu-face
	insert-actor-func menu-face 'on-escape :hide-menu-face
	;-- Offset menu face
	either hinge [
		; Hinge to specified corner
		system/words/hinge fc face1 menu-face face2
	][
		; Hinge to bottom left corner
		system/words/hinge fc [bottom left] menu-face [top left]
	]
	menu-face/offset: menu-face/offset + any [os 0x0]
	;-- Open menu face
	inform/options/offset menu-face [no-title no-border] menu-face/offset
]

; hides and removes the menu face content. this function is run from the style that needs it.
set 'hide-menu-face does [
	either menu-face [opener-face: menu-face/opener-face][exit]
	hide-popup
	focus opener-face
	opener-face: menu-face: none
]

]