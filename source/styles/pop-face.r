REBOL [
	Title: "VID Pop Face"
	Short: "VID Pop Face"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %pop-face.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Jan-2009
	Date: 02-Jan-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Styles to produce various types of popup faces.
	}
	History: []
	Keywords: []
]

; pop-face needs to be rethought to something straightforward and simple

; the purpose of pop-face is to display either a window or a layout and that's it
; the window will be a full-scale window
; the layout can either be internally for the window or a border-less window and we must allow all types to exist
; this simplicity will cover all necessary parts, I think
; also a pop for any type of REBOL requesters will be needed and store the returned value in the face that makes up the basic pop-face
; POP-FACE
; - POP-LAYOUT
;   - POP-LIST
; - POP-WINDOW
; - POP-REQUEST

; we also need to consider the use of pop-face for an URL like bar
; which means POP-FIELD

; basically this means that pop-face must support an initial style for decoration that then can be altered with the "..." button

;pop-face 'field
;pop-face 'info

; I think we want two different distinctions:

; layouts:

; - layout-color
; - layout-date
; - layout-pass
; - layout-list
; - layout-dir
; - layout-download
; - layout-text

; they should be styles instead, as they are too dynamic to keep fixed like this

; layouts are used inside pops

; pop-layout <parent-face> <offset> <layout>
; - pop-list <parent-face> <list>
; - pop-sheet <parent-face> <layout>

; layouts are used inside requests:

; request <layout>
; - request-color <color>
; - request-date <date>
; - request-dir <dir>
; - request-pass
; - request-text <text>
; - request-download <urls>
; - request-list <list>
; - alert <string>

; tool <layout>

; tool windows are windows without ok-cancel buttons, but with items that allow change of output content in real-time

; possible model for returning data from a window like this should be simplified to a get-face on the essential elements
; of the window, so we throw any old model out, even though I know one is there
; the problem is that the window returns a value into its own face, which may not be useful in case of the window
; the same goes for pop-sheets and generally for pop-layouts, so we may have to resort to storing this in the
; ok-cancel groups, which we already do to a lesser extent.
; that means you click one of the buttons and an action is run, but you can't define that action outside the window without
; a mess of things to do


; and the field must have specific behavior that can alter the field. perhaps pop-face needs to be lighter than that
; pop-face would be a panel instead of a plain face, containing a dynamic setup
; not a style, but an entire layout can be set here, due to the need of this for complex fields
; if not a layout, then a single object

stylize/master [
	; this face produces an INFO and a BUTTON which when clicked reveals a layout or window
	POP-FACE: FACE 200x24 spring [horizontal] with [
		color: none
		btn-action: [do-face face/parent-face none]
		pane: make block! []
		;multi: make multi [
		;	block: func [face blk][
		;	        if pick blk 1 [
		;	            face/action: func [face value] pick blk 1
		;	            if pick blk 2 [face/alt-action: func [face value] pick blk 2]
		;	        ]
		;	    ]
		;]
		; this will be a fixed setup
		access: make access [
			set-face*: func [face value] [
				face/data: value
				set-face/no-show face/pane/1 value
			]
			get-face*: func [face] [face/data]
		]
		flags: [input]
		init: [
			pane: reverse make-pane [
				across space 0
				button 24x24 "..." spring [left bottom] align [right] btn-action
				info fill 1x0 align [left]
			]
			set-face self data
		]
	]
	; need to add blk to action for the pop-face
	; now we need a method to set the pop-face with an index and let it display a specific value
	; which probably means something with set-face
	; this going to change, since we are creating a new set with the new window function
	POP-WINDOW: POP-FACE with [
		content: none
		result: none
		window: none
		btn-action: [
			if face/content [
				inform face/window: make-window compose/deep face/content
			]
			if face/window/data [
				set-face face face/window/data
				do-face face face/window/data
			]
		]
	]
	POP-WINDOW-LIST: POP-WINDOW with [
		title: none
		list-specs: none
		content: [
			origin 4 space 2
			h3 (title)
			bar
			list-view spring [horizontal vertical] with [(list-specs)]
			bar spring [top horizontal]
			ok-group
		]
	]
	; pops a file requester and stores the selected file. Does nothing on cancel.
	POP-FILE: POP-FACE with [
		access: make access [
			set-face*: func [face value] [
				face/data: all [value to-file value]
				set-face/no-show face/pane/1 value
			]
		]
		btn-action: [
			use [file] [
				file: request-file/file/only attempt [all [get-face face/parent-face to-file get-face face/parent-face]]
				if file [
					set-face face/parent-face file
					do-face face/parent-face none
				]
			]
		]
	]
	POP-LIST: POP-FACE with [
		; method to display a list in a window (specific content)
		; the action determines what happens when we return from that list, i.e. on the setting of face/inform-result
		; that's when the action is run
	]
]