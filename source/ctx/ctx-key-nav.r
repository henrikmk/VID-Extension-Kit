REBOL [
	Title: "VID Keyboard Navigation"
	Short: "VID Keyboard Navigation"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-key-nav.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 14-May-2009
	Date: 14-May-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Keyboard Navigation Functions and Face Definitions
	}
	History: []
	Keywords: []
]

ctx-key-nav: context [

; ---------- Tab Face

; returns the tab face for the face which exists in a certain window
set 'get-tab-face func [[catch] face [object!]] [
	get in root-face face 'tab-face
]

; unsets the tab face for a certain window
set 'unset-tab-face func [face [none! object!] /local rf] [
	any [face exit]
	rf: root-face face
	if in rf 'tab-face [
		rf/tab-face/tab-face?: none
		rf/tab-face: none
		unset-focus-ring face
	]
	face
]

; sets the current tab face for the face which exists in a certain window
set 'set-tab-face func [face [object!] /local rf] [
	any [flag-face? face tabbed return face]
	rf: root-face face
	if all [
		in rf 'tab-face
		object? rf/tab-face
		in rf/tab-face 'tab-face?
	] [
		rf/tab-face/tab-face?: none
		face/tab-face?: true
		rf/tab-face: face
		set-focus-ring face
	]
	face
]

; ---------- Default Face

set 'get-default-face func [face] [
	find-relative-face face [all [in face 'default face/default]]
]

; ---------- Keyboard Navigation

nav-event: none

set 'key-face func [
	"Performs a keyboard action on a face. Returns result to filter to parent window."
	face
	event
	/no-show "Do not show change yet"
	/local access value
] [
	value: event
	if all [
		access: get in face 'access
		in access 'key-face*
	] [
		value: access/key-face* face event
	]
	; [ ] - possibility for throttling performance here on show
	;       [ ] - fps per face
	any [no-show show face]
	face ; big change
	value
]

; need a good standard map for how faces must behave under key-navigate, so all that is
; standardized here instead of inside vid-ctx-text or inside the styles themselves

; Standard function for keyboard operations in a window
;key-navigate: func [event /local tab-face] [
;	nav-event: none                      ; to avoid passing the event again to KEY-NAVIGATE
;	if event/type <> 'key [return event] ; pass through if not a key
;	any [event/face return event]        ; pass through if no face
;	tab-face: get-tab-face event/face    ; get tab face for the window in which event/face exists
;	; here we are receiving key events
;	; and the map of key events is handled in a way that we filter them through a switch for certain cases
;	; while we filter them through a key-face
;	; possibly by using a simple keymap
;	; consider an elegant and flexible way to do this
;
;	; we provide a filter block: if the key is in the filter, the switch and key-face is not performed
;	; if the key is not in the filter, the switch and key-face is performed
;	if key-filter [
;		switch
;		key-face
;	]
;	event
;]

; Standard function for keyboard operations in a window
key-navigate: func [event /local default-face f hidden? tab-face] [
	nav-event: none ; to avoid passing the event again to KEY-NAVIGATE
	if event/type <> 'key [return event]
	unless event/face [return event]
	; generally need a better way to handle when we want full-text-editing to do something interesting
	if all [
		; this is too specifically oriented toward full-text-editing
		system/view/focal-face
		flag-face? system/view/focal-face full-text-edit
		event/face = root-face system/view/focal-face ; too costly
	] [
		return event
	]
	tab-face: get-tab-face event/face
	switch/default event/key [
		#"^-" [	; Tab
			;-- complete work with old tab face
			if flag-face? tab-face input [
				validate-face tab-face
			]
			;-- set new tab face
			until [
				;-- Find a tab-face
				tab-face:
					any [
						either event/shift [
							;-- tab to the previous tabbed face
							find-flag/reverse tab-face tabbed
						][
							;-- tab to the next tabbed face
							find-flag tab-face tabbed
						]
						tab-face
					]
				;-- Make sure it's not hidden
				hidden?: false
				ascend-face tab-face [hidden?: any [hidden? face/size/x = 0 face/size/y = 0]]
				not hidden?
			]
			;-- set focus and focus ring for new tab face
			either flag-face? tab-face input [
				focus tab-face
			][
				unfocus
				set-tab-face tab-face
			]
			;either all [
			;	tab-face
			;	flag-face? tab-face input
			;] [
			;	; [ ] - when unfocusing with the mouse, the action is done twice, but it only happens on the first unfocus
			;	focus tab-face
			;][
			;	unfocus
			;]
			; perform validation here, as we are leaving the field
			;set-tab-face event/face
		]
		#" " [	; Space
			; have to be able to pass this through to key-face
			if system/view/focal-face [return event]
			either in tab-face/access 'key-face* [
				key-face tab-face event
			][
				either event/shift [
					click-face/alt tab-face
				][
					click-face tab-face ; loops here
				]
			]
		]
		#"^M" [	; Enter
			; enter needs to work on the current tab face
			;case [
			;	;-- Usually advanced faces with no text editing
			;	in event/face/access 'key-face* [
			;		key-face tab-face event
			;	]
			;	;-- Usually faces with text editing
			;	event/control [
			;		; perform action to store and unfocus face
			;		unfocus face
			;	]
			;]
			; unless flag-face? tab-face return [return event]
			; Enter only performs the action for the default face
			; testing for the wrong face it seems, as it passes through properly
			if in tab-face/access 'key-face* [ ; big change here as it was event/face before
				key-face tab-face event
			]
			; we should not do this at all, as we want this to be handled explicitly by key-formatter
			;[
			;	if default-face: get-default-face tab-face [
			;		either event/shift [
			;			;remind <shift enter action>
			;			do-face default-face none
			;		][
			;			do-face default-face none
			;		]
			;	]
			;]
		]
	] [
		all [
			event? key-face tab-face event
			key-face find-window tab-face event
		]
	]
	event ; really?
]

]

