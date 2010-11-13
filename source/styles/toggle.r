REBOL [
	Title: "VID Toggle"
	Short: "VID Toggle"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2008 - HMK Design"
	Filename: %vid-toggle.r
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
		effect: [extend 8x8 76x0 key black]
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