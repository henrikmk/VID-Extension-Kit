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

content: none		; face content generated for menu face, function, block or object
menu-face: none		; the menu face in the window

; creates a menu face
set 'make-menu-face does [
	make get-style 'face [
		size: 0x0
		color: svvc/window-background-color
		font: make font [color: black shadow: none size: 12]
		edge: make face/edge [color: svvc/window-background-color size: 2x2 effect: 'bevel]
		style: 'menu
		flags: [scrollable]
		show?: false
		pop-face: none ; the opening face
		feel: none
		access: make object! [
			key-face*: func [face event] [
				key-face face/pane/1 event
			]
			above: func [face] [face/offset/y < 0]
			below: func [face] [(face/offset/y + face/size/y) > face/parent-face/size/y]
			;-- scrolls the menu-face into view if it's beyond the top or bottom border of the parent face
			scroll-face*: func [face x y /local dir step-size move y-size] [
				dir: pick [-1 1] positive? y
				y-size: pop-face/size/y - (2 * second edge-size pop-face)
				move: does [face/offset/y: y-size * dir + face/offset/y]
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
				;-- restrain to pop-face
				face/offset/y: max face/offset/y (pop-face/win-offset/y + y-size - face/size/y + (2 * second edge-size face))
				face/offset/y: min face/offset/y pop-face/win-offset/y
			]
		]
	]
]

; returns the menu face, if any exist in the window
get-menu-face: func [face] [
	get in root-face face 'menu-face
]

; for some cases, the menu face needs to be a separate window
; this would be instated on a case-by-case basis

; creates and displays the menu face. this function is run from the style that needs it. FC is parent-face
set 'set-menu-face func [fc content size offset] [
	;-- Locate appropriate menu face
	any [menu-face: get-menu-face fc exit]
	any [block? content object? content make error! "Menu face is not of the correct type."]
	;-- Determine content of menu face
	menu-face/pane:
		either block? content [
			layout/tight content
		][
			content ; face
		]
	ctx-resize/do-align menu-face none
	menu-face/pop-face: fc
	; this code could be better designed if the alignment process was entirely clear
	menu-face/size: any [size menu-face/pane/size] ; either from style or internally
	menu-face/win-offset: menu-face/offset: offset
	menu-face/pane: menu-face/pane/pane
	ctx-resize/align-contents menu-face
	; [ ] - tab order should mean that the next face after pop-face is menu-face
	; [ ] - tab order could also temporarily be constrained to inside the menu face here, as it does this in OSX
	; [ ] - need a tab base constraint, as this will also work for subwindows
;	menu-face/flags
	focus menu-face
	show menu-face
]

; hides and removes the menu face content. this function is run from the style that needs it.
set 'unset-menu-face func [pop-face] [
	any [menu-face: get-menu-face pop-face exit]
	hide menu-face
	focus pop-face
	menu-face/pane: none
	menu-face/size: menu-face/offset: 0x0
]

]