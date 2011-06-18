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
		close-choice-face: func [face /local fc] [
			fc: find-style get-menu-face 'choice-list 'data
			set-face face second pick fc/data fc/selected/1
			hide-menu-face
		]
		open-choice-face: func [face] [
			show-menu-face/offset
				face
				compose/deep [
					origin 0
					choice-list
						on-scroll [ ; does not work
							probe 'scrolling
						]
						with [
							surface: 'edge
							value: none
							; Sub face with selection marker cell and text cell
							sub-face: [
								across space 0
								list-text-cell (as-pair face/size/x - face/size/y face/size/y) spring [bottom]
								list-text-cell (to-pair face/size/y) fill 0x0 spring [bottom left]
							]
							columns: [word value]
							back-render-func: func [face cell /local colors row] [
								row: pick face/data-sorted cell/pos/y
								colors: ctx-colors/colors
								case [
									find face/highlighted row [
										cell/color: colors/field-select-color
										cell/font/color: colors/body-text-color
									]
									find face/selected row [
										cell/color: colors/select-color
										cell/font/color: colors/select-body-text-color
									]
									true [
										cell/color: none
										cell/font/color: colors/body-text-color
									]
								]
							]
							render-func: func [face cell /local dot-center] [
								dot-center: (to-pair face/size/y / 2)
								if cell/pos/x = 2 [
									cell/text: none
									cell/effect: all [cell/data = face/value [draw [pen none fill-pen black circle 4 dot-center]]]
								]
							]
							insert init [
								; Get size
								size: get in get-opener-face 'size
								size/y: size/y * divide length? get in get-opener-face 'setup 2
								; Build data array
								data: make block! []
								value: get-face get-opener-face
								foreach [word string] get in get-opener-face 'setup [
									insert/only tail data reduce [string word]
								]
							]
							append init [
								; Get actors from opener face
								pass-actor get-opener-face self 'on-select
								; Perform initial selection, not using select-face, otherwise ON-SELECT would be used
								value: get-face get-opener-face
								highlighted: copy
								selected: reduce [divide 1 + index? find get in get-opener-face 'setup value 2]
							]
						]
				]
				as-pair 0 negate face/size/y * divide 1 + index? find face/setup get-face face 2
				; . - scroll using scroll-wheel
				;     need to get the actor here, but nothing happens
				;     no on-scroll actor is called, so face can't be scrolled

				; . - scroll to different value without opening, by using the scroll-wheel

				; x - face/value is unknown, possibly wrong path
				; x - sizes may be wrong, as we are not calculating certain edges correctly
				; . - need to share the font from parent
				; . - edge will be part of the list
				; x - the list has no background color
		]
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
			scroll-face*: func [face x y /local old] [
				old: face/data
				set-face*
					face
					first
						either y > 0 [
							skip face/data -2
						][
							either tail? skip face/data 2 [
								face/data
							][
								skip face/data 2
							]
						]
				old <> face/data
			]
		]
		init: [
			access/setup-face* self any [setup []]
			insert-actor-func self 'on-click :open-choice-face
			insert-actor-func self 'on-select :close-choice-face
			insert-actor-func self 'on-select :action
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