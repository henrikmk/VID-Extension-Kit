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
set 'make-menu-face does [
	make get-style 'face [
		size: 0x0
		style: 'menu
		flags: [scrollable compound]
		show?: false
		opener-face: none
		feel: none?
		access: make object! [
			key-face*: func [face event] [
				key-face face/pane/1 event
			]
			above: func [face] [face/offset/y < 0]
			below: func [face] [(face/offset/y + face/size/y) > face/parent-face/size/y]
			; this may be too specific to the scrolling list for CHOICE, so perhaps it should be located inside the list face instead of here
			;-- scrolls the menu-face into view if it's beyond the top or bottom border of the parent face
			scroll-face*: func [face x y /local dir step-size move line-height] [
				dir: pick [-1 1] positive? y
				line-height: opener-face/size/y - (2 * opener-face/draw-body/margin/y)
				move: does [face/offset/y: line-height * dir + face/offset/y]
				any [
					all [above face below face move]
					case [
						above face [
							if positive? dir [move]
						]
						below face [
							if negative? dir [move]
						]
					]
				]
				;-- restrain to opener-face
				face/offset/y: max face/offset/y (opener-face/win-offset/y + line-height - face/size/y + (2 * second edge-size face))
				face/offset/y: min face/offset/y opener-face/win-offset/y
			]
		]
	]
]

; returns the menu face, if any exist in the window
set 'get-menu-face func [face] [
	get in root-face face 'menu-face
]

; returns the opener-face face, if any exist in the window
set 'get-opener-face func [face] [
	all [fc: get-menu-face face fc/opener-face]
]

; [ ] - tab order should mean that the next face after opener-face is menu-face
; [ ] - tab order could also temporarily be constrained to inside the menu face here, as it does this in OSX
; [ ] - need a tab base constraint, as this will also work for subwindows

; creates and displays the menu face. this function is run from the style that needs it. FC is parent-face
set 'show-menu-face func [fc content /size sz /offset os /hinge face1 face2] [
	;-- Locate appropriate menu face
	any [menu-face: get-menu-face fc exit]
	any [block? content object? content make error! "Menu face is not of the correct type."]
	;-- Determine content of menu face
	menu-face/pane:
		either block? content [
			layout/tight content
		][
			content
		]
	ctx-resize/do-align menu-face none
	menu-face/opener-face: opener-face: fc
	; this code could be better designed if the alignment process was entirely clear
	menu-face/size: any [sz menu-face/pane/size + (2 * edge-size menu-face)] ; either from style or internally
	menu-face/win-offset: menu-face/offset: any [os fc/offset + as-pair 0 fc/size/y]
	menu-face/pane: menu-face/pane/pane
	if hinge [system/words/hinge fc face1 menu-face face2]
	ctx-resize/align-contents menu-face
	focus menu-face
	show menu-face
]

; hides and removes the menu face content. this function is run from the style that needs it.
set 'hide-menu-face func [face] [
	menu-face: get-menu-face face
	if menu-face [opener-face: menu-face/opener-face]
	all [not menu-face not opener-face exit]
	hide menu-face
	focus opener-face
	menu-face/opener-face: none
	menu-face/pane: none
	menu-face/size: menu-face/offset: 0x0
]

]