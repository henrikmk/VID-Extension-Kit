REBOL [
	Title: "VID Toggle"
	Short: "VID Toggle"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2008 - HMK Design"
	Filename: %toggle.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 24-Dec-2008
	Date: 24-Dec-2008
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Variants of TOGGLE.
	}
	History: []
	Keywords: []
]

stylize/master [
	; Standard TOGGLE
	TOGGLE: BUTTON with [
		text: "Toggle"
		feel: svvf/toggle
		surface: 'toggle
		keep: true
		access: ctx-access/toggle
	]

	; TOGGLE that uses images
	;IMAGE-TOGGLE: TOGGLE with [
	;	images: make block! []
	;	feel: make feel [
	;		redraw: func [face act pos /local state][
	;			state: either not face/state [face/blinker] [true]
	;			face/image: get pick face/images not state
	;		]
	;	]
	;	; color is none here
	;]

	; TOGGLE with multiple states instead of two.
	; this clashes with STATE-BUTTON
	STATE: TOGGLE with [
		text: "State"
		click: false
		; [ ] - move this feel into vid-feel.r
		feel: make feel [
			redraw: func [face act pos /local appearance state][
				state: index? face/states
				if all [face/texts face/texts/2 face/texts/3] [
					face/text: pick face/texts state
				]
				appearance: pick face/appearances state
				foreach word next first appearance [
					set in face word get in appearance word
				]
				if face/edge [face/edge: bind get pick [normal-edge frame-edge] face/click face]
			]
			engage: func [face action event][
				if find [down alt-down] action [
					if face/related [
						foreach item face/parent-face/pane [
							if all [
								flag-face? item toggle
								item/related
								item/related = face/related
								item <> face
							] [
								item/states: head item/states
								item/data: item/state: first item/states
								show item
							]
						]
					]
					; real state machine here later
					face/states: next face/states
					if tail? face/states [face/states: head face/states]
					face/data: face/state: first face/states
					face/click: not face/click
					either action = 'down [do-face face face/data] [do-face-alt face face/data]
					show face
				]
				if find [up alt-up] action [
					face/click: not face/click
					show face
				]
			]
		]
		states: appearances: none
		append init [
			unless states [
				states: reduce [none true false] ; sequence is important
			]
			appearances: reduce any [
				appearances
				[
					; none
					make object! [
						effect: reduce ['gradient 0x1 color color - 50]
					]
					; true
					make object! [
						effect: reduce ['gradient 0x1 color + 50 color]
					]
					; false
					make object! [
						effect: reduce ['gradient 0x1 color - 50 color - 100]
					]
				]
			]
		]
	]

	TAB-BUTTON: TOGGLE with [
		text: "Tab"
		images: load-stock-block [tab tab-on]
		edge: none
		; needs to be flexible width, so may be done in DRAW instead
		; extend does not work in DRAW, so we have to use a manual DRAW block somehow
;		effect: [extend 8x8 76x0 key black]
; to do this could be done with a generic draw function that specifies a draw block
; and then through resize, the resize code automatically changes the necessary sizes to fit the new size
; this could be a generic way to change the skin of the VID Extension Kit
; right now we have SET-IMAGE. We could have a SET-DRAW as well, which applies a new size.
; need to find out what the size is for SET-IMAGE when resizing a style
; that is normally done through it's size and position
; the position changes via a binding with the DRAW block
; so the DRAW block should not need to change
; but in this case, the DRAW block changes and then is entirely redrawn using SHOW in the feel
; this could be done more efficiently by creating a context for the DRAW block
; and then have a DRAW facet in the face that then is used to layout the face
; we have done this before and we can do this again
; so it means that you specify a fixed DRAW block once and bind it to a context
; then the DRAW information changes automatically as the DRAW items change
; DRAW would be a context with DRAW coordinate information
; we need to allow both to be present for any face, otherwise this will be a long time to do
; as this would be something that requires something entirely new for each face
; the proposal would be a DRAW context, which creates one or more DRAW blocks
; then there are specific coordinates that are updated on each resize
; the update would have to happen through FEEL, but we don't sit and update images
; the thing updates largely on its own and then sets states to manage the content
; so we need a CTX-DRAW

		access: make access ctx-access/selector-nav
		; [x] - move deselected tab slightly downwards
		; [ ] - effect initialization in init instead of fixed
		; [ ] - tab selection shows inverted tab bevel
	]

	; TOGGLE with a flat layout, no edge and mouse over background color. Used in large button layouts like calendar
	; [ ] - to be deprecated
	TOGGLE-BOX: TOGGLE with [
		edge: none
		colors: reduce [
			120.120.120	; off color
			orange		; on color
			140.140.140	; over off color
			orange + 20	; over on color
			100.100.100	; click down off color
			orange - 20	; click down on color
		]
		feel: make feel [
			redraw: func [face act pos /local state][
				; complicated
				state: either not face/state [face/blinker] [true]
				face/color: pick face/colors not state
			]
			over: func [face action event][
				face/color: pick face/colors pick [3 4] not action
				show face
			]
		]
		effect: copy []
	]

	; method here to disable the toggle by holding it down for a while
	;MENU-BUTTON: TOGGLE with [
	;	text: "Menu"
	;	keep: false ; keep selected
	;	; toggle
	;	;feel: make feel [
	;	;	; different appearance on button down
	;	;	redraw: func [face act pos] [
	;	;		state: either not face/state [face/blinker] [true]
	;	;		face/color: pick face/colors not state
	;	;	]
	;	;]
	;	; [ ] - toggle must disable also, if the same one is selected again
	;	para: make para [wrap?: false]
	;	init: [
	;		either text [
	;			use [tmp] [
	;				; this is just broken for now. we'll have to fix this later
	;				; when it's clear what size-text really does
	;				tmp: size-text self
	;				size/x: either tmp [font/offset/x * 2 + tmp/x] [50]
	;			]
	;		] [
	;			size/x: 50
	;		]
	;	]
	;]

]