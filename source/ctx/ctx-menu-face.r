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

; returns the menu face
set 'get-menu-face does [
	menu-face
]

; returns the opener-face face, if any exist in the window
set 'get-opener-face does [
	opener-face
]

; [ ] - stack multiple opener faces for submenus

; creates and shows the menu face as a new window. this function is run from the style that needs it (the opener).
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

; hides and removes the menu face content. this function is run from the style that needs it (the opener).
set 'hide-menu-face does [
	either menu-face [opener-face: menu-face/opener-face][exit]
	hide-popup
	focus opener-face
	opener-face: menu-face: none
]

]