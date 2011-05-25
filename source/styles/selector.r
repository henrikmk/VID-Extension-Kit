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
	SELECTOR-TOGGLE: TOGGLE with [
		virgin: true
		access: make access ctx-access/selector-nav
	]
	MULTI-SELECTOR-TOGGLE: SELECTOR-TOGGLE with [
		virgin: false
	] ; different flags

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
	CHOICE: BUTTON 150 with [
		setup: [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"]
		surface: 'choice
		feel: svvf/choice
		; opens and positions the menu list
		open-choice-face: func [face /local idx y-size] [
			if all [not face/choice-face? block? face/setup not empty? face/setup] [
				set-face face/choice-face/pane/1 extract/index face/setup 2 2
				idx: divide 1 + index? face/data 2
				face/choice-face/pane/1/selected: to-block idx
				face/choice-face/pane/1/over: as-pair 1 idx
				ctx-resize/align-contents face/choice-face none
				y-size: face/size/y - (second 2 * edge-size face)
				set-menu-face
					face
					face/choice-face
					as-pair face/size/x (2 * second edge-size face) + divide y-size * length? head face/data 2
					;-- Using WIN-OFFSET? here, because the parent face may be scrolled
					add win-offset? face as-pair 0 y-size - (y-size * idx)
				; [!] - set base tab face to menu-face, but this happens inside set-menu-face
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
						
					]
				]
				event
			]
		]
		choice-face: none ; cache of choice layout
		choice-face?: false ; whether the choice face is open
		init: [
			; the choice face should appear in a separate layout
			choice-face: layout/tight [
				space 0 origin 0 caret-list 100x100 fill 1x1
					on-key [ ; key-face is done before this
						use [fp pop-face] [
							fp: face/parent-face ; is this choice-face?
							pop-face: fp/pop-face
							probe event/key
							case [
								find [up down] event/key [
									; [ ] - adjustment needs to adhere to current selection rather than it's own up/down scheme
									unless empty? face/selected [
										if any [
											all [fp/offset/y < 0 event/key = 'up]
											all [fp/offset/y + fp/size/y > fp/parent-face/size/y event/key = 'down]
										] [
											fp/offset/y: face/choice-face-offset face pop-face
										]
									]
								]
								find [#"^M" #" "] event/key [ ; enter, space
									set-face pop-face pick pop-face/setup 2 * face/selected/1 - 1
									do-face pop-face none
									unset-menu-face pop-face
								]
								#"^[" = event/key [ ; escape
									unset-menu-face pop-face
								]
							]
						]
					]
					on-click [
						; perform this action every time the mouse is clicked
						unset-menu-face face/parent-face/pop-face
						face/parent-face/pop-face/choice-face?: false
					] [
						; perform this action only when the click happens on a different entry than the current one
						; happens before ON-CLICK
						set-face face/parent-face/pop-face pick face/parent-face/pop-face/setup 2 * face/selected/1 - 1
						do-face face/parent-face/pop-face none
					]
					with [
						render-func: func [face cell] [
							; [ ] - when using keyboard, colors are swapped here, due to the keyboard moving the selected face
							case [
								all [face/over face/over/y = cell/pos/y] [
									cell/color: svvc/line-color
									cell/font/color: svvc/select-body-text-color
								]
								find face/selected cell/pos/y [
									cell/color: svvc/select-color
									cell/font/color: svvc/select-body-text-color
								]
								true [
									cell/color: svvc/menu-color
									cell/font/color: svvc/body-text-color
								]
							]
						]
						choice-face-offset: func [face pop-face /local y-size] [
							y-size: pop-face/size/y - (2 * second edge-size pop-face)
							second pop-face/offset + as-pair 0 y-size - (y-size * face/selected/1)
						]
						select-mode: 'mutex
						sub-face: [list-text-cell bold 100 fill 1x0 spring [bottom]]
					]
			]
			flag-face choice-face tabbed
			; [ ] - tab-panel causes the offset to be incorrect. perhaps it's really a problem with win-offset and the edge
			sub-face: choice-face/pane/1/sub-face
			sub-face/pane/1/real-size: sub-face/real-size: none
			sub-face/pane/1/size: sub-face/size: size - (2 * edge-size face)
			sub-face/pane/1/font: make self/font [align: 'left]
			if setup [
				access/setup-face* self setup
			]
			;ctx-resize/do-align choice-face self none
		]
	]

	; Normal rotary
	ROTARY: BUTTON with [
		data: copy [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"]
		edge: [size: 4x2 effect: 'bezel]
		feel: svvf/rotary
		access: ctx-access/data-find
		insert init [if texts [data: texts]]
		flags: [input]
		words: [data [
			;second args
			if all [block? args new/texts: args/2 not empty? new/texts][new/text: first new/texts]
			next args
		]]
		access: ctx-access/selector
	]

	; Tab buttons for panel selection
	TAB-SELECTOR: SELECTOR with [
		color: none
		setup: [choice1 "Choice 1" 160.128.128 choice2 "Choice 2" 128.160.128 choice3 "Choice 3" 128.128.160]
		do-setup: func [face input-value /local i][
			i: 0
			face/emit [across space 0]
			foreach [pane text color] input-value [
				i: i + 1
				; does not perform selection properly
				face/emit compose/deep [
				 	tab-button (text) (any [color svvc/menu-color]) of 'selection [
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