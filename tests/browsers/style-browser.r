REBOL [
	Title: "Style Browser"
	Short: "Style Browser"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %style-browser.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Jul-2009
	Date: 02-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Browse and inspect all styles in the VID Extension Kit.
		Can be used as a requester.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

append ctx-vid-debug/debug 'align

vid-styles: system/view/vid/vid-styles

style-list: extract vid-styles 2

alpha-style-list: sort copy style-list

tree-style-list: sort copy style-list

tag-list: make block! 1000

foreach [word style] vid-styles [
	if style/tags [
		append tag-list style/tags
	]
]

tag-list: unique tag-list

style-tags-window: make-window [
	panel [
		across
		data-list 200x200 with [
			sub-face: [list-text-cell spring [bottom] fill 1x0] ; this should work
			data: :tag-list
		]
	]
	close
]

style-help-window: make-window [
	panel [
		across
		l-doc: parameter-list 300x300
	]
	close
]

style-previews: make block! 1000

foreach [word style] vid-styles [
	repend style-previews ['no-display [test-frame [box "?"]]] ; for styles that have no init block
	all [
;		style/size
		style/init ; only styles that have an init block are allowed in
		repend style-previews [word reduce ['test-frame reduce [word]]]
	]
]

stylize/master [
	TEST-FRAME: CENTER-PANEL edge [
		size: 2x2
		color: 240.240.0
		effect: [tile colorize 100.100.100]
		image: load-stock 'blocked
	]
]

; the currently displayed face
p-face: does [first get-pane first get-pane p-preview]

list-types: [
	alphabetic [list-text-cell fill 1x0 spring [bottom]]
	creation [list-text-cell fill 1x0 spring [bottom]]
	tree [list-tree-cell fill 1x0 spring [bottom]]
]

; it's time to visit a simple tree face style
; the style would indent based on level
; the tree is evident only by a single column being the tree. the rest are still normal non-indented columns
; the rendering would change from a list based renderer to a tree-based renderer
; the number of items may vary in the list as items are folded or unfolded
; the cell would allow double-clicking to open or close a branch
; cells can act as branches or data
; LIST-TREE-CELL
; the indent level is determined by the PARA/MARGIN/X item
; level starts at 1
; level is posted like POS in the tree renderer
; the input for the list is a plain object, not blocks of blocks.
; need LIST/PANE-FUNC that works with a tree
; know where to render from
; create level block to render with, rather than re-rendering the list every time
; then we can use the PANE-FUNC without changing it
; data would be input as an object
; tree processing function would output to data
; there would be a hidden level column somewhere
; if DATA is an object, then render as a tree

; DATA > tree-func > TREE-DATA > pane-func

; problem with data not related to this item should be specially formatted in data

view main: make-window [
	across
	a1: left-panel fill 0x1 [
		across
		l-styles: data-list 250x0 fill 0x1 with [
			select-mode: 'mutex
			header-face: [
				choice fill 1x0
					spring [bottom]
					setup [alphabetic "Styles by alphabetic" creation "Styles by creation" tree "Styles by tree"]
					[
						use [current-list old idx] [
							old: get-face l-styles

							l-styles/list/make-sub-face l-styles/list select list-types get-face face

							set-face/no-show l-styles current-list: get select [
								alphabetic alpha-style-list
								creation style-list
								tree tree-style-list
							] get-face face

							; set up the sub-face for each type

							if old [
								l-styles/list/select-row l-styles/list index? find current-list old
								l-styles/follow l-styles first l-styles/list/selected
							]
							show l-styles
						]
					]
			]
			sub-face: list-types/alphabetic ; initialize using the choice selector in header-face instead
			data: :alpha-style-list ; initialize using the choice selector in header-face instead
		] [
			style-word: to-word get-face face
			style: select vid-styles style-word
			set-face/no-show p-details 'selection
			set-face p-details reduce [
				get-face face
				style/style
				attempt [style/doc/info]
				form style/tags
				form style/flags
				style/size
				style/offset
			]
			set-face p-preview either block? style/init [style-word]['no-display] ; this takes time
			either pp: get-pane p-preview [
				enable-face p-acts
				set-face first get-pane p-acts to-logic flag-face? p-face 'disabled
			][
				probe p-acts/flags
				disable-face p-acts
			]
		]
	]
;	a2: balancer
	a3: panel [
		h3 "Details"
		bar
		p-details: panel spring [bottom] setup [
			no-selection [
				plate "Please select a style to inspect its details"
			]
			no-init [
				plate "The selected style cannot be displayed"
			]
			selection [
				across
				style i info 300
				label "Name" ii: i bold return
				label "Based On" i return
				label "Description" i 274 pop-button "..." spring [left bottom] [
					; style-help-data should be directly grabbed from the object
					use [st] [
						st: select vid-styles to-word get-face l-styles
						either all [in st 'doc object? st/doc] [
							set-face l-doc st/doc
							inform/title style-help-window "Style Help"
						][
							message "No Information available for this Style." "OK"
						]
					]
				] return
				label "Tags" i 274 pop-button "..." spring [left bottom] [
					inform/title style-tags-window "Style Tags"
				] return
				label "Flags" i return
				label "Size"
					i 75 spring [right bottom]
					label "Offset" 46 spring [right bottom]
					i 75 spring [right bottom] return
				button "View Source..." align [right] spring [left bottom] [
					inform/title make-window reduce [
						'code-text-area 600x400 mold select vid-styles to-word get-face l-styles
						'close
					] reform ["Style source for" get-face l-styles]
				]
			]
		]
		h3 "Preview"
		bar
		p-acts: panel fill 1x0 spring [bottom] [
			across
			t-dis: toggle "Disable" [
				either value [
					disable-face p-face
				][
					enable-face p-face
				]
			]
			button "Reset" [
				reset-face p-face
			]
			button "Get Face..." [
				notify mold get-face p-face
			]
		]
		p-preview: frame 300x300 fill 1x1 with [setup: bind :style-previews 'self]
	]
	at 0x0
	button "About..." align [top right] spring [left bottom] [about-program]
]