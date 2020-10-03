REBOL [
	Title: "Field"
	Short: "Field"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2007, 2008 - HMK Design"
	Filename: %field.r
	Version: 0.0.6
	Created: 23-Mar-2007
	Date: 31-Mar-2008
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {}
	History: []
	Keywords: []
]

; Combine with view-edit.r for undo history and other enhanced editing abilities.

stylize/master [
	HIDDEN: FACE 0x0 with [
		access: ctx-access/data
		init: [access/set-face* self none]
	] spring [bottom right]
	
	FIELD: FACE 200x24 spring [bottom] with [
		numeric-keys: key-action: false
		key-range: range: none
		color: none
		max-length: -1
		surface: 'field
		ctrl-keys: make bitset! [#"^H" #"^M" #"^~" #"^-" #" "]
		feel: ctx-text/edit
		access: ctx-access/field
		flags: [field return tabbed on-unfocus input]
		; words list will be large
		words: [
			hide [new/data: copy "" flag-face new hide args] ; deprecated
			decimal [
				flag-face new decimal
				flag-face new sign
				new/key-range: make bitset! [#"0" - #"9" #"." #","]
				new/ctrl-keys: difference new/ctrl-keys make bitset! [#" "]
				args
			]
			integer [
				flag-face new integer
				; [ ] - figure a way to set or unset sign here
				new/key-range: make bitset! [#"0" - #"9"]
				new/ctrl-keys: difference new/ctrl-keys make bitset! [#" "]
				args
			]
			range [new/range: reduce second args args: next args]
			max-length [new/max-length: second args args: next args]
		]
		init: [
			;-- use actors here to map action to unfocus and return
			if function? :action [
				insert-actor-func self 'on-unfocus :action
				insert-actor-func self 'on-return :action
			]
			access/set-face* self copy any [text ""]
			para: make para [] ; avoid sharing the same para object across faces
		]
	]

	; Read only field
	INFO: FIELD with [
		surface: 'info
		colors: 180.180.180
		feel: ctx-text/swipe
	]

	NAME-FIELD: FIELD; on-key [capitalize face value] ; looks like it doesn't work in the style browser

	COMPLETION-FIELD: FIELD with [
		list: make block! []
		match: list
		sort list ; should be presorted always, but it can't truly be done here
		complete: func [face] bind [
			set-face/no-show face copy first match
			caret: highlight-start: at face/text index? caret
			highlight-end: tail face/text
			show face
		] system/view
		key-action: bind [
			case [
				'up = event/key [
					if find/match form pick match -1 copy/part get-face face caret [
						match: back match complete face
					]
				]
				'down = event/key [
					if find/match form pick match 2 copy/part get-face face caret [
						match: next match complete face
					]
				]
				all [not word? event/key ctrl-keys <> union ctrl-keys make bitset! event/key] [
					forall list [
						if find/match form first list get-face face [
							match: list complete face break
						]
					]
					list: head list
				]
			]
		] system/view
	]

	; Field that only stores and returns SHA1 binaries
	SECURE-FIELD: FIELD with [
		access: make access [
			set-face*: func [face value] [
				if binary? value [face/data: value]
				face/text: copy "*****"
			]
			get-face*: func [face] [face/data]
		]
		init: [
			old-value: copy "" ; really? It's supposed to be binary, I think
			if color [colors: reduce [color colors/2]]
		]
	]

	; need a combination of completion-field and name-field

	; ambiguity field that supports blocks as set-face
	DATA-FIELD: FIELD with [
		ambiguous?: false
		states: [ua fa u!a f!a]
		current-state: 'u!a
		state-event-block: [
			focus	[fa		fa		f!a		f!a]
			dirty	[ua		u!a		u!a		u!a]
			escape	[ua		ua		u!a		u!a]
			many	[ua		fa		ua		fa ]
			one		[u!a	f!a		u!a		f!a]
		]
		set-state: func [event] [
			current-state: pick select state-block event index? find states current-state
		]
		; the actions are blocks of code that should be run to set particular settings
		; for the data-field, such as text and font color and caret

		actions: bind bind bind [
			fa	[clear text	 font/color: black ambiguous: true]
			ua	[text: "<Multiple>" font/color: gray ambiguous: true]
			f!a [font/color: black ambiguous: false]
			u!a [font/color: black ambiguous: false]
		] system/view ctx-text face
		; setting the event:
		; set-state 'focus
		; set-state 'many

		;set-face is overwritten for field, which is a problem

		;access: make access []
		;
		;access/set-face*: func [face value] [
		;	 if face/para [face/para/scroll: 0x0]
		;	 ; not sure if this is the best method, but we're doing it now.
		;	 ; this will nicely filter decimal values
		;	 either block? value [
		;		 set-state 'many ; what about actions? or the current state
		;		 either 1 = length? value [
		;			 face/data: form first value
		;		 ][
		;			 ; select ambiguity display here
		;			 ; when ambiguity is enabled, the standard text is entered
		;			 ; and the font color is gray
		;			 ; weaker text
		;			 ; when focusing, the field should turn empty.
		;			 ; when escaping, the field should return to ambiguity
		;			 face/data: "<Multiple>"
		;		 ]
		;	 ][
		;		 face/data: form value
		;	 ]
		;	 face/text: either flag-face? face hide [
		;		 head insert/dup copy "" "*" length? face/data
		;	 ][
		;		 face/data
		;	 ]
		;	 face/line-list: none
		;]
		; change focus/unfocus mechanism here to use ambiguity

	]

	AREA: FIELD spring none with [
		surface: 'area
		; not sure that old-value is usable
		old-value: none
		set-old-value: func [face] [face/old-value: copy get-face face]
		access: make access [
			scroll: none
			scroll-face*: func [face x y /local dsz lh sz ssz] [
				ssz: face/text-body/size
				sz: face/text-body/area
				dsz: ssz - sz
				lh: face/text-body/line-height
				scroll: any [scroll face/para/scroll]
				face/para/scroll:
					either 1 < abs y [ ; OSX sends only 1 step instead of 3
						;-- Scroll wheel
						min
							face/para/margin
							max
								negate (dsz - face/para/margin)
									add
										face/para/scroll
											negate lh * as-pair
												max -1 min 1 x
												max -1 min 1 y
					][
						;-- Scroll bar
						add
							scroll
							negate
								as-pair
									dsz/x * x ; zero, as it should be
									dsz/y * y
					]
				;not-equal? index? old index? face/output ; update only for show when the index shows a difference
			]
		]
	]

	TEXT-AREA: COMPOUND spring none with [
		; [ ] - when DRAGGING the scroller to the bottom and then ctrl-a for all text, the ratio changes for the scroller to 1
		; [ ] - there seem to be more bugs that cause the scroller ratio to be incorrect
		; [ ] - check that set-text-body actually sets correct ratio for the face
		area: v-scroller: h-scroller: none
		area-surface: 'area
		size: 200x200
		set-scroller: func [face /local fc fp ft] [ ; used in both area and text-area
			fc: either face/style = 'area [face][face/area]
			fp: either face/style = 'area [face/parent-face][face]
			ft: fc/text-body
			;-- Adjust vertical scroller
			fp/v-scroller/redrag ft/v-ratio
			set-face/no-show fp/v-scroller ft/v-scroll
			show fp/v-scroller
			;-- Adjust horizontal scroller, if used
			unless in fp 'h-scroller [
				fp/h-scroller/redrag ft/h-ratio
				set-face fp/h-scroller ft/h-scroll
				show fp/h-scroller
			]
		]
		access: make access [
			set-face*: func [face value] [
				;-- Set text
				set-face/no-show face/area value
				ctx-text/set-text-body face head face/area/text
				;-- Set scrollers
				face/set-scroller face
			]
			get-face*: func [face] [
				get-face face/area
			]
			resize-face*: func [face size x y /local sz] [
				sz: size
				;-- Resize Faces
				if face/h-scroller [sz/y: sz/y - face/h-scroller/size/y]
				if face/v-scroller [sz/x: sz/x - face/v-scroller/size/x]
				resize/no-show face/area sz 0x0 ; set-text-body is not set here
				;-- Resize and Position Scrollers
				if face/h-scroller [
					resize face/h-scroller as-pair sz/x face/h-scroller/size/y as-pair 0 sz/y
				]
				if face/v-scroller [
					resize face/v-scroller as-pair face/v-scroller/size/x sz/y as-pair sz/x 0
				]
				;-- Redrag scrollers
				; this does not work, when the scroller is moved to the end
				; when moving to the end, then the scroller should be
				; work on clamp problem
				; when clamping, the scroller may be used to redrag here inside this function
				
				; [ ] - scroller does not clamp, after resizing, when it's scrolled to the end
				; [ ] - scroller does not allow clamping, when clicked
				; [ ] - scroller does not resize down after resizing up, when it has been scrolled to the end
				; [ ] - so when you scroll to the end, you need to do things to get it going
				set-scroller face
				; when scroller is set, then do the scroller
;				probe get-face face/v-scroller
				; the value is always zero after resizing
			]
		]
		init: [
			;-- Build pane
			pane: compose/deep/only [
				across space 0
				area 100x100 spring none with [surface: (to-lit-word area-surface)]
				scroller 20x100 spring [left] align [right]
				; this does not scroll
				; value is passed correctly
				; scroll-face does not scroll properly
				; the para is reset to 4x4, where it shouldn't be
					on-scroll [scroll-face face/parent-face/area 0 value]; probe face/parent-face/area/para/origin]
			]
			;-- Add horizontal scroller if no text wrapping is used
			unless self/para/wrap? [
				append pane [
					return
					scroller 100x20 spring [top]
						on-scroll [scroll-face face/parent-face/area value 0]
				]
			]
			pane: layout/styles/tight pane copy self/styles
			set-parent-faces self
;			any [size <> -1x-1 size: pane/size + any [all [object? edge 2 * edge/size] 0]] ; not sure
			panes: reduce ['default pane: pane/pane]
			set [area v-scroller h-scroller] pane
;			if font [
;				area/font: font ; can't propagate it like this, as the font is now determined by the surface
;			]
			;-- Set actor sharing between self and area
			foreach act [on-key on-return on-escape on-tab on-unfocus] [
				insert-actor-func self act :set-scroller
				pass-actor self area act
			]
			; set scroller when pressing a key
			deflag-face area tabbed ; don't allow tabbing to it
			; this will be interesting: we need to use the focus ring on one style and focus another style
			; i.e. tab-face will be different from focal-face. it could be profound.
			area/para/wrap?: para/wrap?
			;-- Add text
			if string? text [
				access/set-face* self text
				text: none
			]
		]
	]

	; TEXT-AREA with full text editing. See vid-flags.r
	FULL-TEXT-AREA: TEXT-AREA with [
		append init [
			deflag-face area 'text-edit
			flag-face area 'full-text-edit
		]
	]

; can't append surface here, as the surface has already been defined during layout
	CODE-TEXT-AREA: FULL-TEXT-AREA with [area-surface: 'code]; font [shadow: none color: black name: "courier"]
]