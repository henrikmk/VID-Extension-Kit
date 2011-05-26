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
	TOGGLE: BUTTON ctx-colors/colors/action-color with [
		text: "Toggle"
		feel: svvf/toggle
		surface: 'toggle
		states: [off on]
		access: ctx-access/data-state
	]

	; Tab selector button
	TAB-BUTTON: TOGGLE with [
		text: "Tab"
		feel: svvf/mutex
		virgin: true
		surface: 'tab
		access: make access ctx-access/selector-nav
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