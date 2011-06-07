REBOL [
	Title: "VID Panel"
	Short: "VID Panel"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2008 - HMK Design"
	Filename: %panel.r
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
	Purpose: {
		Patched version of PANEL that supports a better SET-FACE and GET-FACE and multiple panes.
		Allows recursive SET in subpanels.
		Removes support for words setting fields as this clashes with setting values as words.
	}
	History: []
	Keywords: []
]

stylize/master [
	; Standard COMPOUND, meant for gathering multiple faces without the overhead of PANEL
	COMPOUND: IMAGE fill 0x0 spring none with [
		font: none ; panels do not contain a font object
		access: ctx-access/compound
		init: [
			pane:
				layout/styles/tight
					either all [function? :action not empty? second :action] [
						second :action
					][
						make block! []
					]
					copy self/styles
			action: none ; to avoid performing the action on click
			size: any [
				size								; user sets size
				pane/size + (2 * edge-size self)	; content sets size
			]
			pane: pane/pane
			set-parent-faces self
		]
	]

	; Standard PANEL, based on COMPOUND with multiple panes and SETUP
	PANEL: COMPOUND fill 0x0 spring none with [
		feel:
		setup:
		path:
		submit:
		panes:
		scroller-face:
		word:
			none
		access: ctx-access/panel
		size: none; -1x-1 ; none instead?
		;-- Adds a single pane to the panel
		; need to find a way to use add-pane outside of init, as face/styles is not available there
		add-pane: func [[catch] face word pane /local out] [
			if error? set/any 'err try [
				; face/styles only works if add-pane is used during init
				out: either face/styles [layout/styles/tight pane copy face/styles][layout/tight pane]
				out/color:			none
				out/spring:			face/spring
				out/align:			face/align
				out/fill:			face/fill
				out/parent-face:	face
				out/style:			'pane
				set-parent-faces/parent out face
			] [
				probe disarm err
				throw make error! reform ["Layout error in pane" word]
			]
			repend face/panes [word out]
			face/panes: back back tail face/panes
		]
		;-- Removes a single pane from the panel
		remove-pane: func [face word /local current] [
			current: face/panes
			remove/part find head face/panes word 2
			current
		]
		;-- Moves a single pane in the panel to a new position
		move-pane: func [face word offset] [
			current: face/panes
			;move/to/skip find head face/panes word offset 2
			;probe extract head face/panes 2
			; this still doesn't work
			current
		]
		;-- Resizes the current pane in the panel to the size of its content
		resize-pane: func [face /local faces pane] [
			pane: second face/panes
			faces: pane/pane
			all [block? faces empty? faces exit]
			if pane/fill/x = 0 [
				;-- Resize the X direction
				pane/size/x: 0
				repeat i length? faces [
					pane/size/x: max pane/size/x faces/:i/offset/x + faces/:i/size/x
				]
			]
			if pane/fill/y = 0 [
				;-- Resize the Y direction
				pane/size/y: 0
				repeat i length? faces [
					pane/size/y: max pane/size/y faces/:i/offset/y + faces/:i/size/y
				]
			]
			;-- Append origin
			pane/real-size: pane/size: pane/size + faces/1/origin
		]
		init: [
			if all [
				not block? setup
				function? :action
				not empty? second :action
			] [
				setup: reduce ['default second :action]
			]
			access/setup-face* self setup
			action: none
			word: any [default first setup]
			access/set-panel-pane self word
		]
	]

	; Oriented Panels
	; half of these don't show up with the correct flags
	LEFT-PANEL:				PANEL spring [right] align [left] fill 0x1
	LEFT-TOP-PANEL:			PANEL spring [right bottom] align [left top]
	LEFT-BOTTOM-PANEL:		PANEL spring [right top] align [left bottom]
	RIGHT-PANEL:			PANEL spring [left] align [right] fill 0x1
	RIGHT-TOP-PANEL:		PANEL spring [left bottom] align [right top]
	RIGHT-BOTTOM-PANEL:		PANEL spring [left top] align [right bottom]
	BOTTOM-PANEL:			PANEL spring [top] align [bottom] fill 1x0
	TOP-PANEL:				PANEL spring [bottom] align [top] fill 1x0
	CENTER-PANEL:			PANEL spring [left right bottom top] align [center]
	CENTER-TOP-PANEL:		PANEL spring [left right bottom] align [left right top]
	CENTER-BOTTOM-PANEL:	PANEL spring [left right top] align [left right bottom]
	CENTER-LEFT-PANEL:		PANEL spring [right bottom top] align [left top bottom]
	CENTER-RIGHT-PANEL:		PANEL spring [left bottom top] align [right top bottom]

	; Scrollable PANEL wrapped in a COMPOUND
	SCROLL-PANEL: COMPOUND with [
		compound: [
			across space 0
			button "" 20x20 spring [left top] align [right bottom] ; this gets different purposes
			;-- 21x20 is necessary as fill does not set orientation after init
			scroller 21x20 fill 1x0 align [left bottom] [scroll-face face/parent-face value none]
			return
			scroller 20x21 fill 0x1 align [right top] [scroll-face face/parent-face none value]
			panel fill 1x1 align [top left] ; panel acts as clipping area
		]
		panel-face:											; The face which is the panel
		nav-face:											; The button face in the lower right corner
		h-scroller:											; The horizontal scroller
		v-scroller:											; The vertical scroller
			none
		faces: [nav-face h-scroller v-scroller panel-face]	; The collection of faces that exist in the compound
		panel-pane:											; The content of the panel face
			none
		pane-spring: [right bottom]							; Which springs to use for the content
		pane-fill: 0x0										; Which side of the content to restrict to the size of the panel
		; adjust scrollers to size and offset of content
		adjust-scrollers: func [face /local content] [
			content: face/panel-face/pane
			if face/v-scroller [
				v-scroller/redrag min 1 face/panel-face/size/y / max 1 content/size/y
			]
			if face/h-scroller [
				h-scroller/redrag min 1 face/panel-face/size/x / max 1 content/size/x
			]
		]
		; adds a pane to the panel
		add-pane: func [face word pane] [
			face/panel-face/add-pane face/panel-face word pane
			face/adjust-scrollers face
		]
		; remove a pane from the panel
		remove-pane: func [face word] [
			face/panel-face/remove-pane face/panel-face word
			face/adjust-scrollers face
		]
		; moves a pane in the panel
		move-pane: func [face word offset] [
			face/panel-face/move-pane face/panel-face word offset
			face/adjust-scrollers face
		]
		; resizes the pane in the panel according to its own content
		resize-pane: func [face] [
			face/panel-face/resize-pane face/panel-face
			face/adjust-scrollers face
		]
		access: make access [
			set-face*: func [face value] [
				face/panel-face/access/set-face* face/panel-face value
				if word? value [
					face/access/scroll-face*
						face
						all [face/h-scroller get-face face/h-scroller]
						all [face/v-scroller get-face face/v-scroller]
				]
				face/adjust-scrollers face
			]
			get-face*: func [face] [
				face/panel-face/access/get-face* face/panel-face
			]
			setup-face*: func [face value] [
				face/panel-face/access/setup-face* face/panel-face value
				face/adjust-scrollers face
			]
			scroll-face*: func [face x y /local content sz ssz] [
				content: face/panel-face/pane
				sz: face-size face/panel-face
				ssz: content/size
				if x [ ; scroll horizontally
					content/offset/x: min 0 negate ssz/x - sz/x * x
				]
				if y [ ; scroll vertically
					content/offset/y: min 0 negate ssz/y - sz/y * y
				]
				if tab-face: get in root-face face 'tab-face [ ; should not be necessary as tab-face should always be there
					set-tab-face tab-face
				]
			]
		]
		init: [
			pane: layout/styles/tight compound copy self/styles
			set :faces pane/pane
			if all [
				not block? setup
				function? :action
				not empty? second :action
			] [
				setup: reduce ['default second :action]
			]
			set-parent-faces self
			panel-face/size: none ; do not determine size
			setup-face panel-face setup
			size: any [
				size							; user sets size
				add add add panel-face/size		; panel content sets size
					any [all [v-scroller as-pair v-scroller/size/x 0] 0]
					any [all [h-scroller as-pair 0 h-scroller/size/y] 0]
					(2 * edge-size self)
			]
			pane: pane/pane
			action: none
			insert-actor-func self 'on-resize :resize-pane
			word: any [default all [setup first setup]]
			panel-face/access/set-panel-pane panel-face word
			panel-face/pane/fill: pane-fill
		]
	]

	; Scroll panel with only a horizontal scroller
	H-SCROLL-PANEL: SCROLL-PANEL with [
		faces: [h-scroller panel-face]
		pane-spring: [right]
		pane-fill: 0x1
		compound: [
			space 0
			scroller 21x20 fill 1x0 align [left bottom] [scroll-face face/parent-face value none]
			panel fill 1x1 align [top left] spring none
		]
	]

	; Scroll panel with only a vertical scroller
	V-SCROLL-PANEL: H-SCROLL-PANEL with [
		faces: [v-scroller panel-face]
		pane-spring: [bottom]
		pane-fill: 1x0
		compound: [
			across space 0
			scroller 20x21 fill 0x1 align [top right] [scroll-face face/parent-face none value]
			panel fill 1x1 align [top left] spring none
		]
	]

	; PANEL with visible frame
	FRAME: PANEL; 100x100 ; see vid-styles.r for style

	; Oriented Frames
	LEFT-FRAME:				FRAME spring [right] align [left] fill 0x1
	LEFT-TOP-FRAME:			FRAME spring [right bottom] align [left top]
	LEFT-BOTTOM-FRAME:		FRAME spring [right top] align [left bottom]
	RIGHT-FRAME:			FRAME spring [left] align [right] fill 0x1
	RIGHT-TOP-FRAME:		FRAME spring [left bottom] align [right top]
	RIGHT-BOTTOM-FRAME:		FRAME spring [left top] align [right bottom]
	BOTTOM-FRAME:			FRAME spring [top] align [bottom] fill 1x0
	TOP-FRAME:				FRAME spring [bottom] align [top] fill 1x0
	CENTER-FRAME:			FRAME spring [left right bottom top] align [center]
	CENTER-TOP-FRAME:		FRAME spring [left right bottom] align [left right top]
	CENTER-BOTTOM-FRAME:	FRAME spring [left right top] align [left right bottom]
	CENTER-LEFT-FRAME:		FRAME spring [right bottom top] align [left top bottom]
	CENTER-RIGHT-FRAME:		FRAME spring [left bottom top] align [right top bottom]

	; SCROLL-PANEL with a FRAME style frame
	SCROLL-FRAME: SCROLL-PANEL

	; V-SCROLL-PANEL with a FRAME style frame
	V-SCROLL-FRAME: V-SCROLL-PANEL

	; H-SCROLL-PANEL with a FRAME style frame
	H-SCROLL-FRAME: H-SCROLL-PANEL

	; Experimental Column style by Maxim
	COLUMN: BOX EDGE NONE with [
		color: none
		multi: make multi [
			block: func [
				face 
				blks
				/local frame tt
			][
				if block? blks/1 [
					; [!] - may not work, because of new parent-face
					frame: layout compose [
						origin 0x0
						space 10x10
						below
						(blks/1)
					]
					face/pane: frame/pane
					unless face/size [face/real-size: none face/size: -1x-1] ; prevent error below
					if face/size/x = -1 [
						face/size/x: frame/size/x + any [all [face/edge/x 2 * face/edge/size/x] 0]
					]
					if face/size/y = -1 [
						face/size/y: frame/size/y + any [all [face/edge/y 2 * face/edge/size/y] 0]
					]
				]
			]
		]
	]

	; PANEL with transparent flag set. See vid-flags.r for flags.
	TRANSPARENT-PANEL: PANEL

	; panel with a tab panel frame. See vid-styles.r for appearance.
	TAB-PANEL-FRAME: PANEL

	; Panel with tabs at the top
	TAB-PANEL: PANEL fill 1x1 with [
		access: make access ctx-access/tab-panel
		tab-selector: none		; tab selector faces
		tabs: none				; word/string/tuple block set
		panes: none				; word/pane block set
		;-- Adds a single tab and its pane to the tab panel
		add-tab: func [face data] [
			face/tab-selector/add-item face/tab-selector copy/part data 2 ; data is word/string/tuple/content set
			face/pane/1/add-pane face/pane/1 data/1 data/3
			; new size? I'm not sure that's a good idea
			; select new tab here? not sure
		]
		;-- Removes a single tab and its pane from the tab panel
		remove-tab: func [face word /local m n] [
			all [
				face/tab-selector/remove-item face/tab-selector word
				face/pane/1/remove-pane face/pane/1 word
			]
			; display the tab at the current index
		]
		;-- Moves a tab to a new location in the tab panel
		move-tab: func [face name offset] [
			; this doesn't work
			face/tab-selector/move-item face/tab-selector name offset
			face/pane/1/move-pane face/pane/1 name offset
			; no change in display
		]
		init: [
			access/setup-face* self setup
			default: any [default all [not empty? setup first setup]]
			access/set-face* self default
			; display arrows, when there are too many tabs
		]
	]

	; aspect fixed picture frame
	PICTURE: COMPOUND [
		space 0 across
		pad 2x2
		image white edge [size: 1x1] spring none
		pad 0x2
		box coal 2x98 spring [left] return
		pad 4x-2
		box coal 100x2 spring [top]
	] with [
		access: make access [
			set-face*: func [face value] [
				if image? value [
					face/pane/1/image: value
					show face
				]
			]
			get-face*: func [face] [
				face/pane/1/size
			]
		]
		;append init [
		;	; this is not going to work under the new scheme
		;	foreach fc pane [ctx-resize/do-resize fc size - 104]
		;]
	]

	; Frame with a dotted edge with user definable color and thickness. See vid-styles.r for edge definition.
	WARNING-FRAME: FRAME

	; Vertical "accordion" style of panes inside a vertically scrolling panel, separated by fold/unfold buttons
	ACCORDION: V-SCROLL-PANEL with [
		access: make access [
			set-face*: func [face value] [
				either word? value [
					set-face face/panel-face/pane value
					do-face face/panel-face/pane none
				][
					; not sure this will work properly
					; but we do need a method to open and close each fold-button programmatically
					set-face/no-show face/pane/1 value
				]
			]
			get-face*: func [face] [
				get-face face/panel-face/pane
			]
			reset-face*: func [face] [
				set-face* face/panel-face/pane face/default
			]
		]
		lo: none
		fold-func: func [face] [
			fp: face/parent-face ; scrolled-face
			fpp: fp/parent-face ; clipper-face
			fc: last fp/pane
			fp/real-size/y: fp/size/y: fp/origin/y * 2 + fc/offset/y + fc/size/y
			fpp/parent-face/resize-pane fpp/parent-face
			fpp/parent-face/adjust-scrollers fpp/parent-face
			show fpp/parent-face ; expensive, but necessary
		]
		insert init [
			;-- Create accordion setup
			if block? setup [
				lo: copy setup
				insert clear setup [space 0]
				use [b s t w] [
					t: none
					parse lo [
						any [
							set w word!
							set s string!
;							opt [set t tuple!]
							[set b block! | set b word! (b: get b)] (
								insert tail setup compose/deep/only [
									fold-button (s) with [var: (to-lit-word w)]
									compound (b)
								]
							)
						]
					]
				]
				setup: reduce ['default setup]
			]
		]
		append init [
			foreach fc panel-face/pane/pane [
				if fc/style = 'fold-button [
					; fold function here will resize the scrolled-face to fit the offset + size + origin of the last face
					insert-actor-func fc 'on-click :fold-func
				]
			]
		]
	]

]
