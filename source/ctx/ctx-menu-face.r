REBOL [
	Title:  "REBOL/View: Menu Face"
	Author: "Henrik Mikael Kristensen"
	Rights: "Copyright 2000 REBOL Technologies. All rights reserved."
	Note:   {Improvements to this code are welcome, but all changes preserve the above copyright.}
	Purpose: {
		Handling and display of menu faces.
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