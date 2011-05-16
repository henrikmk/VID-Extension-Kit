REBOL [
	Title: "VID Buttons"
	Short: "VID Buttons"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %button.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 30-Mar-2009
	Date: 30-Mar-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Common Types of Buttons
	}
	History: []
	Keywords: []
]

stylize/master [
	BUTTON: FACE 100x24 "Button" spring [bottom right] with [
		value: false
		color: image: none
		font: [align: 'center valign: 'middle shadow: 0x0 style: 'bold]
		feel: svvf/button
		effects: none
		depth: 128
		colors: svvc/action-colors
		disabled-colors: none
		access: ctx-access/button
		doc: [
			info: "Rectangular, rendered buttons"
			string: ["button label" "button down label"]
			integer: "width of button"
			pair: "width and height of button"
			tuple: ["button color" "button down color"]
			block: ["execute when clicked" "execute when alt-clicked"]
			image: ["button background" "background when button down"]
		]
		init: [
			edge: make edge []
			if font [
				font/color: first font/colors
				;-- Adjust size/x, if size/x = -1
				size: face-size-from-text self 'x
			]
			if color [colors: reduce [color color]]
			;-- Average colors for disabled colors
			disabled-colors: reduce [
				to-tuple array/initial 3 round ((colors/1/1 + colors/1/2 + colors/1/3) / 3)
				to-tuple array/initial 3 round ((colors/2/1 + colors/2/2 + colors/2/3) / 3)
			]
		]
	]
	; Multi-state button
	STATE-BUTTON: BUTTON with [
		virgin: false
		states: [state1 state2 state3]
		feel: svvf/state
	]
	; Action button
	ACT-BUTTON: BUTTON with [
		on-click: none
		text: "Action"
		multi: make multi [
			block: func [face blk /local act] [
				act: make block! []
				if face/on-click [append act face/on-click]
				if pick blk 1 [append act pick blk 1]
				face/action: func [face value] act
				if pick blk 2 [face/alt-action: func [face value] pick blk 2]
			]
		]
	]
	; True button for performing a window-wide TRUE action
	; this is no longer used. it's very complex, but may require some rework
	TRUE-BUTTON: ACT-BUTTON "True" with [
		default: true
		;rate: 10 ; not working, very flakey and keeps events, so we keep it turned off
		on-click: [
			context [
				fp: face/parent-face
				fpa: get in fp 'action
				win: root-face face									; the window in which this face resides
				error-face: none									; the face in which a validation error can occur
				result: true										; we assume it validates for now
				validate-face/act win [
					result: result and (found? find [valid not-required] face/valid/result)	; as soon as there is a failure, keep it
					error-face: any [
						error-face									; makes sure the first error face is focused, not the last
						not found? find [invalid required] face/valid/result
						(set-tab-face focus face)
					]
				]
				all [
					win/result: face/value: result					; validation result is stored in win/result
					clean-face win									; clean the window face for next use
					either popup? win [hide-popup][unview/only win]	; close the window/inform if result is true
				]
			]
		]
		;glow: func [face] [
		;	face/color: face/original-color * ((sine ((to-decimal now/time/precise) // 1 * 360)) * 0.05 + 1)
		;	face/effects/1/3: face/color + 32
		;	face/effects/1/4: face/color - 32
		;]
		feel: make feel [
			engage: func [face action event] bind [
				switch action [
					time [face/glow face] ; not working, very flakey.
					down [face/state: on]
					alt-down [face/state: on]
					up [if face/state [do-face face face/text] face/state: off]
					alt-up [if face/state [do-face-alt face face/text] face/state: off]
					over [face/state: on]
					away [face/state: off]
				]
				cue face action
				show face
			] system/view/vid/vid-feel/button
		]
		original-color: none
	]
	; Save button, used for a window wide SAVE action
	SAVE-BUTTON: TRUE-BUTTON "Save" with [
		; additional graphics to indicate whether the face it's tied to is dirty
		; find similar ways that this works elsewhere
		; [ ] - how do we tie it there?
		; [ ] - how do we update it?
	]
	FALSE-BUTTON: ACT-BUTTON "False" with [
		on-click: [
			context [
				win: root-face face
				win/result: face/value: false
				either popup? win [hide-popup][unview/only win]
			]
		]
	]
	; Close button, used for a window wide CLOSE action
	CLOSE-BUTTON: FALSE-BUTTON "Close" align [left right] spring [left right]

	; Pop button, pops an INFORM window with specific content
	POP-BUTTON: ACT-BUTTON "..." with [
		content: none ; this could be a block or a face. if it's a face, we can assign a window title directly.
		on-click: [
			if face/content [
				; where to set the window word?
				; !!! - change this to a view/new or display-window
				inform make-window face/content
			]
		]
	] ; open a window here and specify the content in the content part and the action in the action part
	
	CHECK: SENSOR with [
		set [font edge para] none
		feel: svvf/check-radio
		access: ctx-access/data
		images: load-stock-block [check-off-up check-on-up check-off-down check-on-down check-off-over check-on-over]
		size: images/1/size
		hover: off
		append init [if none? data [data: false] text: none state: off]
	]

	CHECK-MARK: CHECK

	CHECK-LINE: BASE-TEXT middle with [
		; size of check line is not tall enough
		images: load-stock-block [check-off-up check-on-up check-off-down check-on-down check-off-over check-on-over]
		size: as-pair -1 images/1/size/y
		feel: svvf/check-radio
		access: ctx-access/data
		edge-size: none
		hover: false
		text: "Value"
		pad: 5 ; space between text and image
		access: make access [
			disable-face*: func [face] [
				; [ ] - font color does not work properly on init due to redraw and common font object
				face/font/color: 80.80.80
				face/pane/effect: [brightness 1 contrast -1]
			]
			enable-face*: func [face] [
				face/pane/effect: none
			]
		]
		access: make access ctx-access/selector-nav
		insert init [
			pane: make-face/spec 'check compose [
				size: (images/1/size)
				offset: 0x0
				feel: edge: color: none
				flags: copy []
			]
			para: make para []
			either font/align = 'right [
				para/margin/x: pane/size/x + pad
			][
				para/origin/x: pane/size/x + pad
			] 
		]
		append init [
			state: off
			edge-size: edge-size? self
			pane/offset/y: size/y - edge-size/y + 1 - pane/size/y / 2
			all [font/align = 'right pane/offset/x: size/x - edge-size/x - 2 - pane/size/x]
			if none? data [data: false]
		]
	]

	; the radio could be the tri-state radio button, but we won't deal with that right now
	RADIO: CHECK with [
		images: load-stock-block [radio-off-up radio-on-up radio-off-down radio-on-down radio-off-over radio-on-over]
		size: images/1/size
		related: 'default ; radios are related, unless OF is used
		saved-area: true
	]

	; Radio button with text label
	RADIO-LINE: CHECK-LINE with [
		images: load-stock-block [radio-off-up radio-on-up radio-off-down radio-on-down radio-off-over radio-on-over]
		; wrong size is used here
		size: as-pair -1 images/1/size/y
		related: 'default ; radios are related, unless OF is used
		append init [
			pane/saved-area: true
		]
	]

	; BUTTON with a flat layout, no edge and mouse over background color. To be used in large button layouts like calendar
	; [ ] - to be deprecated
	BUTTON-BOX: BUTTON with [
		edge: none
		colors: reduce [
			120.120.120	; off color
			140.140.140	; over color
			100.100.100	; click down color
		]
		feel: make feel [
			redraw: func [face act pos /local state] [
				state: either not face/state [face/blinker] [true]
				face/color: pick face/colors pick [1 3] not state
			]
			over: func [face action event] [
				face/color: pick face/colors pick [1 2] not action
				show face ; face/color does not show
			]
		]
		effect: copy []
	]

	ARROW: BUTTON 20x20 with [
		font: none ; must stand alone
		text: none
		init: [
			unless effect [
;				state: either all [colors state: pick colors 2] [state][black]
				effect: compose [fit arrow (svvc/glyph-color) .7 rotate (
					select [up 0 right 90 down 180 left 270] data)]
				state: off
;					if all [colors image] [insert next effect reduce ['colorize first colors]]
			]
		]
		words: [up right down left [new/data: first args args]]
	]

	; button without and edge and optimized for images. see vid-styles.r for appearance.
	ICON-BUTTON: BUTTON 20x20

	COLOR-BUTTON: BUTTON 30x30 with [
		font: none
		text: none
		spring: [bottom right]
		append init [
			access/set-face* self any [color black]
			color: svvc/action-color
		]
		access: make access [
			set-face*: func [face value] [
				any [tuple? value exit]
				face/data: value
				face/effect: compose/deep [
					draw [
						pen black
						box 4x4 (subtract face-size face 5)
						fill-pen checker-board.png
						box 4x4 (subtract face-size face 5)
						fill-pen (value)
						box 4x4 (subtract face-size face 5)
					]
				]
			]
			get-face*: func [face] [face/data]
		]
	] [
		tool-color get-face face func [value] [
			set-face face value
			act-face face event 'on-change ; why not ON-SET instead?
		]
	]

	; Button that folds/unfolds the panel after it (visually below it) and pushes and pulls the remaining faces after it
	FOLD-BUTTON: BUTTON right fill 1x0 spring [bottom] with [
		fold: func [face /local fc axis tab-face] [
			any [fc: next-face face return false]
			;-- Axis
			axis: pick [x y] face/size/y >= face/size/x
			if fc/size/:axis > 0 [face/next-face-size: fc/size/:axis]
			;-- Fold/Unfold
			either face/folded [
				;-- Unfold next face
				fc/size/:axis: fc/real-size/:axis: face/next-face-size
				fc/show?: true
				face/next-face-spring: fc/spring
				face/effect/draw/image: arrow-down.png
			][
				;-- Fold next face
				fc/size/:axis: fc/real-size/:axis: 0
				fc/show?: false
				fc/spring: append copy [] pick [right bottom] axis = 'x
				face/effect/draw/image: arrow-right.png
			]
			face/folded: not face/folded
			;-- Push/pull remaining faces
			faces: next find face/parent-face/pane fc
			unless tail? faces [
				diff: next-face-size
				if fc/size/:axis = 0 [diff: negate diff]
				foreach f faces [
					if f/style <> 'highlight [
						f/offset/:axis: f/offset/:axis + diff
						f/win-offset/:axis: f/win-offset/:axis + diff
					]
				]
			]
			;-- Handle tab-face
			tab-face: get-tab-face fc
			set-tab-face
				either within-face? tab-face fc [
					either visible-face? tab-face [
						tab-face
					][
						unfocus
						face
					]
				][
					tab-face
				]
			show face/parent-face
		]
		next-face-size: 0
		next-face-spring: none
		folded: none
		append init [
			effect: [draw [image arrow-down.png]]
			insert-actor-func self 'on-click :fold
		]
	]
]