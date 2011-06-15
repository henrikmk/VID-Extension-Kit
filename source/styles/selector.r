REBOL [
	Title: "VID Selector"
	Short: "VID Selector"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2008 - HMK Design"
	Filename: %selector.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 23-Dec-2008
	Date: 23-Dec-2008
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {}
	History: []
	Keywords: []
]

stylize/master [
	SELECTOR-TOGGLE: TOGGLE ctx-colors/colors/action-color with [
		virgin: true
		feel: svvf/mutex
		access: make access ctx-access/selector-nav
	]
	MULTI-SELECTOR-TOGGLE: TOGGLE ctx-colors/colors/action-color with [
		virgin: false
		access: make access ctx-access/selector-nav
	]

	; list of toggles that can't be multi-selected
	SELECTOR: FACE-CONSTRUCT with [
		size: 200x24 ; one line for all toggles
		setup: copy [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"]
		spacing: 0
		widths: none
		calc-widths: func [n width /local widths l spaces error w] [
			if zero? n [return width]
			spaces: n - 1 * spacing
			width: width - spaces
			w: round/floor width / n
			widths: array/initial n w
			error: width - (w * n)
			if n > 1 [
				l: either even? n [
					n
				][
					round/ceiling n / 2
				]
				widths/:l: error + widths/:l
			]
			widths
		]
		;-- Constructs the layout of buttons inside the selector
		do-setup: func [face input-value /local keys i][
			keys: extract input-value 2
			face/widths: face/calc-widths length? keys face/size/x
			i: 0
			emit [across space 0]
			foreach [key value] input-value [
				i: i + 1
				face/emit compose/deep [
					selector-toggle (face/color) (as-pair face/widths/:i face/size/y) (value) of 'selection [
						face/parent-face/dirty?: true
						do-face face/parent-face none
						validate-face face/parent-face
					] with [
						var: (to-lit-word key)
					]
				]
			]
		]
		;-- Adds a new button to the selector
		add-item: func [face data] [
			face/access/setup-face* face append face/setup data
		]
		;-- Removes a buttom from the selector
		remove-item: func [face word /local w] [
			any [w: find face/setup word return false]
			face/access/setup-face* face head remove/part w any [find next w word! tail w] ; independent of record length
		]
		;-- Moves a button in the selector to a new location
		;move-item: func [face word offset /local next-size skip-size] [
		;	probe 'a
		;	all [
		;		probe 'a1
		;		skip-size: find face/setup word
		;		probe 'a2
		;		next-size: any [
		;			find next skip-size word!
		;			tail face/setup
		;		]
		;		probe 'a3
		;	]
		;	probe 'b
		;	all [
		;		probe 'b1
		;		block? skip-size
		;		probe 'b2
		;		block? next-size
		;		probe 'b3
		;		skip-size: offset? skip-size next-size
		;		probe 'b4
		;	]
		;	probe 'c
		;	any [integer? skip-size return false]
		;	probe 'd
		;	probe '--
		;	probe word
		;	probe offset
		;	probe skip-size
		;	probe '--
		;	face/access/setup-face* face probe head move/to/skip probe find probe face/setup word offset skip-size
		;	probe 'e
		;]
		words: reduce [
			'data func [new args][
				all [
					block? args
					new/data: args/2 ; [!] - or first?
				]
				next args
			]
		]
		access: ctx-access/selector
	]

	; list of toggles that can be multi-selected
	MULTI-SELECTOR: SELECTOR with [
		default: copy data: make block! []
		setup: reduce ['choice1 "Choice 1" false 'choice2 "Choice 2" false 'choice3 "Choice 3" false]
		do-setup: func [face input-value /local keys i clr][
			clr: any [color 0.0.0]
			keys: extract input-value 3
			face/widths: face/calc-widths length? keys face/size/x
			i: 0
			face/emit [across space 0]
			foreach [key text value] input-value [
				i: i + 1
				; should be the same as for check
				face/emit compose/deep [
					multi-selector-toggle (widths/:i) (text) (value) (clr) [
						face/parent-face/dirty?: true
						do-face face/parent-face none
						validate-face face/parent-face
					] with [var: (to-lit-word key)]
				]
			]
		]
		access: ctx-access/multi-selector
	]

	; Vertical list of radio buttons
	RADIO-SELECTOR: SELECTOR with [
		color: none
		do-setup: func [face input-value /local first-key keys i][
			keys: extract input-value 2
			first-key: first input-value
			i: 0
			face/emit [space 0]
			foreach [key value] input-value [
				i: i + 1
				; [ ] - allow disabling of single radio buttons in this panel
				face/emit compose/deep [
					radio-line (value) of 'selection with [
						var: (to-lit-word key)
					] [
						face/parent-face/dirty?: true
						do-face face/parent-face none
						validate-face face/parent-face
					]
				]
			]
		]
	]

	; Vertical list of check buttons
	CHECK-SELECTOR: MULTI-SELECTOR with [
		color: none
		do-setup: func [face input-value /local keys i][
			keys: extract input-value 2
			i: 0
			face/emit [space 0]
			foreach [key text value] input-value [
				i: i + 1
				face/emit compose/deep [
					; [ ] - allow disabling of single checkmarks in this panel
					check-line (text) (value) with [
						var: (to-lit-word key)
						;font: (make face/font []) ; this is necessary for disable-face
						;para: (make face/para [])
						append init [
							font: make font []
							para: make para []
						]
					] [
						face/parent-face/dirty?: true
						alter face/parent-face/data face/var
						do-face face/parent-face none
						validate-face face/parent-face
					]
				]
			]
		]
	]

	; Normal choice
	CHOICE: BUTTON 150 ctx-colors/colors/action-color with [
		setup: [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"]
		surface: 'choice
		feel: svvf/choice
		; opens and positions the menu list
		open-choice-face: func [face /local edge idx line-height] [
			if all [face <> get-opener-face face block? face/setup not empty? face/setup] [
				set-face face/choice-face/pane/1 extract/index face/setup 2 2
				idx: divide 1 + index? face/data 2
				face/choice-face/pane/1/selected: to-block idx
				face/choice-face/pane/1/over: as-pair 1 idx
				ctx-resize/align-contents face/choice-face none
				line-height: face/choice-face/pane/1/sub-face/size/y
				edge: edge-size get in root-face face 'menu-face
				; should actually focus the menu face here
				; but the focus ring is not set around the menu
				show-menu-face/size/offset
					face
					face/choice-face
					as-pair face/size/x add divide line-height * length? head face/data 2 edge/y * 2
					;-- Using WIN-OFFSET? here, because the parent face may be scrolled
					add win-offset? face as-pair 0 line-height - (line-height * idx)
				; [!] - set base tab face to menu-face, but this happens inside show-menu-face
				svvf/set-face-state face none
			]
		]
		; need a common resize face here
		; balancer and resizer
		access: make access [
			setup-face*: func [face value] [
				face/setup: value
				if value [
					face/data: copy face/setup
					set-face* face face/data/1
				]
			]
			set-face*: func [face value /local val] [
				if val: find/skip head face/data value 2 [
					face/data: val
					face/text: form select face/setup value
				]
			]
			get-face*: func [face] [
				first face/data
			]
			key-face*: func [face event] [
				switch event/key [
					#" " [  ; space
						; open and focus list
						open-choice-face face
					]
					#"^M" [ ; enter
						; open and focus list
						open-choice-face face
					]
					#"^[" [ ; escape
						; close choice face
						act-face face/choice-face/pane/1 event 'on-click
					]
				]
				event
			]
		]
		choice-face: none ; cache of choice layout
		init: [
			; the choice face should appear in a separate layout
			choice-face: layout/tight [
				space 0 origin 0 caret-list 100x100 fill 1x1
					; this does not work as it's never focused
					on-key [ ; key-face is done before this
						use [fp opener-face] [
							fp: face/parent-face ; is this choice-face?
							opener-face: fp/opener-face
							case [
								find [up down] event/key [
									; [ ] - adjustment needs to adhere to current selection rather than it's own up/down scheme
									unless empty? face/selected [
										if any [
											all [fp/offset/y < 0 event/key = 'up]
											all [fp/offset/y + fp/size/y > fp/parent-face/size/y event/key = 'down]
										] [
											fp/offset/y: face/choice-face-offset face opener-face
										]
									]
								]
								find [#"^M" #" "] event/key [ ; enter, space
									set-face opener-face pick opener-face/setup 2 * face/selected/1 - 1
									do-face opener-face none
									hide-menu-face face
								]
								#"^[" = event/key [ ; escape
									hide-menu-face face
								]
							]
						]
					]
					on-click [
						; perform this action every time the mouse is clicked
						hide-menu-face face
					] [
						; perform this action only when the click happens on a different entry than the current one
						; happens before ON-CLICK
						use [opener-face] [
							opener-face: get-opener-face face
							set-face opener-face pick opener-face/setup 2 * face/selected/1 - 1
							do-face opener-face none
							act-face opener-face none 'on-click
							act-face opener-face none 'on-select
						]
					]
					with [
						render-func: func [face cell] [
							; [ ] - when using keyboard, colors are swapped here, due to the keyboard moving the selected face
							; unconfirmed that this still happens
							case [
								all [face/over face/over/y = cell/pos/y] [
									cell/color: ctx-colors/colors/line-color
									cell/font/color: ctx-colors/colors/select-body-text-color
								]
								find face/selected cell/pos/y [
									cell/color: ctx-colors/colors/select-color
									cell/font/color: ctx-colors/colors/select-body-text-color
								]
								true [
									cell/color: ctx-colors/colors/menu-color
									cell/font/color: ctx-colors/colors/body-text-color
								]
							]
						]
						choice-face-offset: func [face opener-face /local y-size] [
							y-size: opener-face/size/y; - (2 * second edge-size pop-face)
							second opener-face/offset + as-pair 0 y-size - (y-size * face/selected/1)
						]
						select-mode: 'mutex
						sub-face: [list-text-cell right bold 100 fill 1x0 spring [bottom]] ; does not bold and has the wrong size
					]
			]
			flag-face choice-face tabbed
			; [ ] - tab-panel causes the offset to be incorrect. perhaps it's really a problem with win-offset and the edge
			sub-face: choice-face/pane/1/sub-face
			sub-face/pane/1/real-size: sub-face/real-size: none
;			sub-face/pane/1/size: sub-face/size: size + 10; - (probe 2 * self/draw-body/margin/y); (2 * edge-size face) ; size is now wrong, because the edge is wrong here
; [ ] - when not present, this face is right aligned
			sub-face/pane/1/font: make sub-face/pane/1/font [align: 'left]
			if setup [
				access/setup-face* self setup
			]
			;ctx-resize/do-align choice-face self none
		]
	]

	; Normal rotary
	; redesign this later
	;ROTARY: BUTTON ctx-colors/colors/action-color with [
	;	data: copy [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"]
	;	edge: [size: 4x2 effect: 'bezel]
	;	surface: none
	;	feel: svvf/rotary
	;	access: ctx-access/data-find
	;	insert init [if texts [data: texts]]
	;	flags: [input]
	;	words: [data [
	;		;second args
	;		if all [block? args new/texts: args/2 not empty? new/texts][new/text: first new/texts]
	;		next args
	;	]]
	;	access: ctx-access/selector
	;]

	; Tab buttons for panel selection
	TAB-SELECTOR: SELECTOR with [
		color: none
		setup: [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"]
		do-setup: func [face input-value /local i][
			i: 0
			face/emit [across space 0]
			foreach [pane text] input-value [
				i: i + 1
				face/emit compose/deep [
				 	tab-button (text) of 'selection [
						set-face/no-show face/parent-face (to-lit-word pane)
						do-face face/parent-face none
					] with [
						var: (to-lit-word pane)
					] ; switch pane
				]
			]
		]
	]
]