REBOL [
	Title: "VID Lists"
	Short: "VID Lists"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009 - HMK Design"
	Filename: %vid-list.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 07-May-2009
	Date: 07-May-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Variations of LIST-VIEW.
	}
	History: []
	Keywords: []
]

stylize/master [
	; Prototypes for iterated face styles
	ITERATED-FACE: BLANK-FACE fill 1x0 spring [bottom]
	ITERATED-TEXT: TEXT fill 1x0 spring [bottom]
	ITERATED-TXT: TXT fill 1x0 spring [bottom]

	; [ ] - must be able to handle formed text
	; cell text for TABLE
	TABLE-TEXT: TEXT with [
		flags: []
		color: white
	]

	; cell text for LIST
	LIST-TEXT: TABLE-TEXT with [
		para: make para [wrap?: false]
		feel: make feel [
			over: none
			engage: func [face act event /local lst] [
				lst: face/parent-face/parent-face
				if act = 'down [
					lst/set-selection lst event face/pos
				]
			]
			redraw: none
			detect: none
		]
	]

	; cell image for LIST
	LIST-IMAGE: LIST-TEXT with [
		; centered image here and no text
		text: none
	]

	; sort button for LIST
	SORT-BUTTON: STATE font [align: 'left] [
		if face/var [
			use [fpp fppl] [
				fpp: face/parent-face/parent-face
				fppl: find-flag fpp iterated
				fppl/sort-column: face/var
				fppl/sort-direction: get-face face
				ctx-list/set-filtered fppl
				show fppl
			]
		]
	] with [
		states: reduce [none 'asc 'desc]
		images: load-stock-block [arrow-down arrow-up]
		para: make para [wrap?: false]
		access: make access [
			resize-face*: func [face size x y /local pos] [
				if face/font/align = 'right [exit]
				foreach ap face/appearances [
					pos: none
					if ap/effect [
						parse ap/effect [
							thru 'draw into ['image pos: pair!]
						]
					]
					if pos [
						change pos as-pair size/x - 20 0
					]
				]
			]
		]
		appearances: [
			; none
			make object! [
				effect: reduce ['gradient 0x1 color + 16 color - 16]
			]
			; asc
			button-skin self images/1 color - 16
			; desc
			button-skin self images/2 color - 16
		]
	]

	SORT-RESET-BUTTON: BUTTON 16x24 "..." align [right] spring [left bottom] [
		; reset sort for parent-face ctx-list
		use [fppl] [
			fppl: face/parent-face/parent-face
		]
	]

	SORT-RESIZER: RESIZER with [
		action: func [face value /local def fp fpp fppl i] [
			fp: face/parent-face ; header face is two levels up
			fpp: fp/parent-face
			if none? fpp/list-face [
				fpp/list-face: find-flag fpp/parent-face iterated
			]
			fppl: fpp/list-face
			i: 0
			foreach fc fp/pane [
				if fc/style <> face/style [
					def: pick fppl/definition 2 * pick fppl/source-display i: i + 1
					set in def 'width fc/size/x
				]
			]
			fppl/set-subface fppl
		]
	]

	; list header with sort buttons
	LIST-HEADER: FACE-CONSTRUCT fill 1x0 spring [bottom] with [
		; [x] - be inspired by selector
		; [o] - input is row object
		; [o] - set input correctly from layout
		; [o] - append sort-reset button
		; [ ] - proper widths of sort-buttons
		; [ ] - align widths of buttons to those of columns by formatting
		; [ ] - consider how the foreach loop in process could be identical to that of make-subface-layout
		; [x] - align those sort-buttons that come after the resize column
		; [x] - spring the sort-button that belongs to the resize column
		; [x] - convey the resize-column to the list-header
		; [o] - use the resize-column in the compound list
		; [x] - face construct does not handle resizing well
		; [ ] - add balancer to sort columns, so we can resize columns
		row:			; [block!] row display description
		resize-column:	; [word! none!] column that is resizable
		definition:		; [block! none!] block of objects to describe the columns of the list
		list-face:		; [object!] list face that this face is attached to
			none
		spacing: 0
		column: make object! [
			name: "Unnamed"
			width: 100
			font: [
				align: 'left
			]
		]
		cell-type: 'sort-button
		bar-size: 4
		do-setup: func [face data /local c spring* words idx llo with fill var width] [
			row: data
			spring*: none
			face/emit reduce [
				'origin 0 'across 'space spacing
				'panel make block! [across space 0]
			]
			llo: last face/lo
			either data [
				idx: 0
				foreach cell data [
					idx: idx + 1
					c: make column any [select any [definition []] cell []]
					repend llo ['sort-button form c/name 'of to-lit-word 'cols]
					insert/only insert tail llo 'font c/font
					with: [width 'with compose/only [var: (to-lit-word var) fill: (fill) spring: (spring)]]
					spring: spring*
					fill: none
					var: cell
					width: c/width
					case [
						; button for last column
						all [size size/x <> -1 c/width = -1 idx = length? data] [
							width: width - bar-size
							fill: 1x0
						]
						; button for resize column
						any [cell = resize-column c/width = -1] [
							spring: [bottom]
							spring*: [left]
						]
						; any other button with more than one column
						1 < length? data [
							width: width - bar-size
						]
					]
					repend llo with
					if cell <> last data [
						repend llo ['sort-resizer as-pair bar-size 20]
					]
				]
			][
				c: make column []
				repend llo ['sort-button form c/name [with [spring: [bottom] fill: 1x0]]]
			]
			append lo 'sort-reset-button
		]
	]
	
	; don't force it

	; Basic Iterated List
	LIST: IMAGE 240.240.240 spring none with [
		feel:
		subface:
		subfunc:
		edge:
			none
		spacing: 0
		make-subface: func [face lo /local fs] [
			fs: face/subface: layout/parent/origin/styles lo iterated-face 0x0 copy face/styles
			fs/parent-face: face
			fs/size/y: fs/size/y - face/spacing
			set-parent-faces/parent fs face
			align fs
		]
		; [ ] - problem now in that panefunc should also manage data and we need to deal with multiple different fs
		;       [ ] - fs must not be set at all. we must use a way to pass these items to the face without making a new object or such
		; the alternative is to provide an entirely different panefunc
		; vertical iteration function
		panefunc: func [face id /local count fs spane sz] [
			fs: face/subface
			if pair? id [return 1 + second id / fs/size]
			fs/offset: fs/old-offset: id - 1 * fs/size * 0x1
			sz: size/y - any [attempt [2 * face/edge/size/y] 0]
			if fs/offset/y > sz [return none]
			count: 0
			foreach item fs/pane [
				if object? item [
					face/subfunc
						face							; list face
						item							; cell face
						id								; row
						count: count + 1				; col
						fs/offset/y + fs/size/y <= sz	; render or not
				]
			]
			fs
		]
		list-size: func [face] [
			to-integer
				face/size/y - (any [attempt [2 * face/edge/size/y] 0]) / face/subface/size/y
		]
		init: [
			make-subface self any [attempt [second :action] [list-text]] ; if empty, pane loops infinitely
			pane: :panefunc
			if none? size [size: 100x100] ; size is really set to 100x100
			size/x: subface/size/x + first edge-size? self
		]
	]

	; static list for display only purposes
	TABLE: LIST with [
		row:				; [block!] row display description
		source:				; [block!] connects to a data source, block of objects
		source-sorted:		; [block!] source sorted
		source-filtered:	; [block!] source filtered
		source-display:		; [block!] column indexes for display
		filter-spec:		; [block!] filter specification
		sort-column:		; [word!] column for sorting
		sort-direction:		; [word!] direction of sorting
		selection:			; [block! none!] selection of indexes
		resize-column:		; [word! none!] column that is resizable
		definition:			; [block! none!] block of objects to describe the columns and ordering of the list
		cellfunc:
		setup:
			none
		column: make object! [
			name: "Unnamed"
			width: 100
			type: string!
			cell-type: 'table-text
			font: [
				align: 'left
				style: none
				color: 0.0.0
			]
		]
		; also definition on the row colors, etc.
		; per row manipulation of the entire list object. we want definition editing per row.
		spacing: 1
		color: black
		cell-type: 'table-text ; not here, but per column
		; updates the list filtering and sorting
		update: func [face] [
			ctx-list/set-filtered face
			face/scroll/set-redrag face
			show face
			if in face 'scroll [
				show face/scroll/v-scroller-face
			]
		]
		; sets definition block, if it's not already set by user
		set-definition: func [face] [
			; manipulation occurs even earlier
			if block? face/definition [exit]
			face/definition: make block! []
			if none? face/row [face/row: [data]]
			; face/row is an object here
			foreach word face/row [
				insert insert tail face/definition word make face/column []
			]
		]
		set-words: func [face] [
			face/words: extract face/definition 2
		]
		make-subface-layout: func [face /local c idx lo rc] [
			; [ ] - blocks of words as input should work formed
			; [ ] - possibly do this by definitions instead of relying on contents
			; [ ] - use source display or row instead of definition
			rc: false
			lo: make block! 100
			repend lo ['origin spacing 'across 'space spacing]
			either face/row [
				idx: 0
				foreach cell face/row [
					idx: idx + 1
					c: make column any [select face/definition cell []]
					insert/only insert insert tail lo c/cell-type 'font c/font
					case [
						all [face/size face/size/x <> -1 idx = length? face/row] [
							append lo [with [spring: [bottom] fill: 1x0]]
						]
						cell = resize-column [
							insert insert tail lo c/width [with [spring: [bottom]]]
							rc: true
						]
						true [
							append lo c/width
						]
					]
					if rc [
						insert insert tail lo c/width [with [spring: [left bottom]]]
					]
				]
			][
				insert insert tail lo cell-type [with [spring: [bottom] fill: 1x0]]
			]
			lo
		]
		; cell rendering function
		subfunc: func [face cell-face row col render /local r] [
			any [any-block? face/source-sorted exit]
			either all [render row <= length? face/source-sorted] [
				r: pick face/source-sorted row
			][
				unset 'r
			]
			col: pick face/source-display col
			if get in face 'cellfunc [
				cell-face/pos: as-pair col row
				face/cellfunc face cell-face row col
			]
			set-face/no-show cell-face
				case [
					not value? 'r [
						copy ""
					]
					object? r [
						form get in r pick next first r col
					]
					any-block? r [
						form pick r col
					]
					true [
						r
					]
				]
		]
		set-subface: func [face /local i w] [
			; [ ] - consider functions at an earlier convenience to alter the list definition
			;       [ ] - method to alter widths in the definition
			;       [ ] - method to swap columns around in the definition, perhaps using MOVE
			;       [ ] - the last act would be set-subface face during that manipulation
			; this should be simple: use a single interface to access the definition
			; [ ] - consider what to do when we have no definition:
			;       the problem here would be that there are no widths to manipulate here, so we create
			;       an artificial definitions block
			; [ ] - consider what to do when definitions and column order do not match
			; [ ] - consider method for looping properly through the subface
			face/set-definition face
			face/set-words face
			either (length? face/row) <> (length? face/subface/pane) [
				; rebuild subface
				face/make-subface face face/make-subface-layout face
			][
				; refresh subface
				i: w: 0
				foreach word face/row [
					def: select face/definition word
					i: i + 1
					face/subface/pane/:i/size/x: def/width + 4
					face/subface/pane/:i/offset/x: w
					w: w + def/width + 4
				]
			]
			show face
		]
		init: [
			;if setup [source: make ctx-list setup] ; might be changed, since ctx-list is not instanced
			if none? source [source: make block! []]
			source-sorted: copy source-filtered: copy source-display: make block! length? source
			set-definition self
			set-words self
			ctx-list/set-filtered self
			make-subface self make-subface-layout self ; change this
			; calculate inner size here somehow
			pane: :panefunc
			; possibly allow rendering of Y in the size of the data, in case we want to use this as a table view
			; height here should be multiplied by the amount of rows to get an even size
			if none? size [size: 100x100]
			size/x: subface/size/x + first edge-size? self
		]
	]

	; data list with selectable rows, no scroller
	DATA-LIST: TABLE with [
		column: make column [
			cell-type: 'list-text
		]
		spacing: 0
		color: snow
		scroll: none
		access: make access [
			key-face*: func [face event] [
				face/set-selection face event none
			]
			scroll-face*: func [face x y] [
				face/scroll/set-face-scroll face x y
			]
			get-face*: func [face /local vals] [
				case [
					none? face/selection [none]
					empty? face/selection [none]
					1 = length? face/selection [
						pick head face/source-sorted face/selection/1/y
					]
					true [
						vals: make block! length? head face/source-sorted
						foreach pos face/selection [
							append vals pick head face/source-sorted pos/y
						]
						vals
					]
				]
			]
			resize-face*: func [face size x y /local s1] [
				resize
					face/subface
					as-pair
						face/size/x
						face/subface/size/y
					face/subface/offset
				unless face/parent-face [exit]
				face/scroll/assign-scrollers face ; [!] - changing
				face/scroll/set-redrag face ; [!] - changing
			]
			get-offset*: func [face dir] [
				if dir = 'x [
					return face/subface/offset/x
				]
				if dir = 'y [
					unless series? face/source-sorted [return 0]
					; this appears not to be correct
					divide
						subtract index? face/source-sorted 1
						subtract
							length? head face/source-sorted
							face/list-size face
				]
			]
		]
		cellfunc: func [face cell-face row col] [
			row: row - 1 + index? face/source-sorted
			cell-face/font/style: none
			cell-face/color: snow
			; this can be customized by the user
			;if any [row = 1 col = 1] [
			;	cell-face/color: 140.140.140
			;	cell-face/font/style: 'bold
			;]
			if odd? row [
				cell-face/color: cell-face/color - 10
			]
			; [ ] - consider how to get a larger selection highlighted using multiple selected
			if all [
				face/selection face/selection/1/y = row
			] [
				cell-face/color: cell-face/color - 30
			]
		]
		select-mode: 'single
		follow: func [face /local item sz start end] [
			unless attempt [item: face/selection/1/y] [exit]
			start: index? face/source-sorted
			sz: (face/list-size face) - 1
			end: start + sz
			case [
				item < start [
					start: item
				]
				; view bar is not visible for last selected item. is this fixed?
				item > end [
					start: item - sz
				]
			]
			face/source-sorted: at head face/source-sorted start
			; [ ] - redrag scroller too. we are ever only setting the vertical scroller
			face/scroll/set-scrollers face
		]
		set-selection: func [face event pos /local old step] [
			old: all [face/selection copy face/selection]
			pos: to-pair pos
			if pos/y > face/list-size face [exit]
			pos/y: pos/y - 1 + index? face/source-sorted ; this is only for a single count, which should be OK
			if pos/y > length? head face/source-sorted [exit]
			switch face/select-mode [
				single [
					all [
						find [up down] event/key
						not face/selection
						not empty? face/source-sorted
						face/selection: [1x0]
					]
					switch/default event/key [
						up [
							step: 1
							; [!] - determine step size from qualifier, but alt won't work here
							face/selection/1/y: max 1 face/selection/1/y - step
							face/follow face
						]
						down [
							step: 1
							; [!] - determine step size from qualifier, but alt won't work here
							face/selection/1/y: min length? head face/source face/selection/1/y + step
							face/follow face
						]
						left []
						right []
					][
						; [ ] - possibly allow keyboard searching of elements here
						any [
							event/key
							face/selection: to-block pos
						]
					]
				]
				multi [
					either event/shift [
						; [ ] - append a selection from last selected to the newly selected
						;       [ ] - consider how to create this selection
						append face/selection pos ; not correct.
					][
						either event/control [
							append face/selection pos
						][
							face/selection: to-block pos
						]
					]
					; [ ] - sort face/selection here. this is a challenge in sorting y-values for pairs.
				]
			]
			if face/selection <> old [
				show face
				do-face face none
			]
		]
		init: [
			if setup [source: make ctx-list setup]
			if none? source [source: make block! []]
			source-sorted: copy source-filtered: copy source-display: make block! length? source
			set-definition self
			set-words self
			ctx-list/set-filtered self
			make-subface self make-subface-layout self
			; calculate inner size here somehow
			pane: :panefunc
			; possibly allow rendering of Y in the size of the data, in case we want to use this as a table view
			; height here should cut off at the required height
			; use -1 as size adjuster
			either none? size [
				size: 0x0
				; adaptive x-size
				size/x: subface/size/x + first edge-size? self
				size/y: 100
			][
				if pair? size [
					if size/x = -1 [
						size/x: subface/size/x
					]
					if size/y = -1 [
						size/y: subface/size/y * length? source-filtered
					]
				]
			]
			scroll: make ctx-scroll [
				step-unit: func [face] [
					1 / max 1 length? face/source-filtered
				]
				v-scroll-val-func: func [face] [
					((index? face/source-sorted) - 1) /
					((length? head face/source-sorted) - face/list-size face)
				]
				v-redrag-val-func: func [face] [
					either empty? head face/source-sorted [
						1
					][
						(face/list-size face) / length? head face/source-sorted
					]
				]
				v-scroll-face-func: func [face y /local len sz] [
					len: length? head face/source-sorted
					sz: face/list-size face
					if all [y len > sz] [
						face/source-sorted: at head face/source-sorted round len - sz + 1 * y
					]
				]
			]
		]
	]
; [ ] - allow header to resize
; [ ] - consider how to pass important arguments to sub-faces before they are inited
; [ ] - consider if data can be passed from this face to the subface properly before init using this panel
;       [ ] - requires passing the panel and composing the panel
; [ ] - consider building the panel using face-construct instead, so we can pass any values inside it
;       [ ] - this makes the base style more complex, I think

; big panel deficiencies:
; [ ] FACT - it's difficult to compose or reduce a panel with the purpose of passing data into it
; [ ] FACT - you cannot init the panel before its contents to pass values to faces inside it
; [ ] FACT - in R3 you can directly pass values to the inner layout by simply binding that layout to the parent object
; [ ] FACT - you cannot grab values from the faces inside the panel as the parent-face system is not established at that point
; this is causing a great amount of trouble for these types of faces. it would be necessary to fix that
; before moving on. as a solution, we could create a COMPOUND style, or PANEL could bind its faces to the face we are dealing with now, given that the WITH keyword allows specific binding of values

	; DATA-LIST with attached scroller
	; this style is not valid
	TEXT-LIST: PANEL with [
		row:
		source:
		resize-column:
		definition:
			none
		; not valid
		insert init [
			if none? row [row: make object! [data: none]]
			if none? resize-column [resize-column: second first row]
		]
		; [ ] - this panel has no size
		setup: compose/deep [
			default [
				across space 0
				data-list fill 1x1 spring none with [
					row: (row)
					source: (source)
					resize-column: (resize-column)
					definition: (definition)
				]
				scroller align [right] spring [left] with [
					scroll-face: 'face/parent-face/pane/1
					; [ ] - referring scroll-face by a word or lit-path probably won't work
				]
			]
		]
	]
	; this is not trivial, so it will have to wait
	; number of columns in view
	; headline per column
	;column-view: face-construct [
	;	
	;]

	; DATA-LIST with attached scroller and header
	HEADER-DATA-LIST: PANEL with [
		row:
		source:
		resize-column:
		definition:
			none
		insert init [
			if none? row [row: make object! [data: none]]
			if none? resize-column [resize-column: second first row]
		]
		; [ ] - this panel has no size
		; [ ] - resize-column does not exist here
		setup: compose/deep [
			default [
				across space 0
				list-header return
				data-list fill 1x1 spring none with [
					row: (row)
					source: (source)
					resize-column: (resize-column)
					definition: (definition)
				]
				scroller align [right] spring [left] with [
					scroll-face: 'face/parent-face/pane/1
					; [ ] - referring scroll-face by a word or lit-path probably won't work
				]
			]
		]
	]
	;[
	;	across space 0
	;	; [ ] - list headers dynamically
	;	; [ ] - header style with headers for input
	;	return
	;	data-list with [fill: 1x1 spring: [horizontal vertical]]
	;	scroller with [align: 'right scroll-face: 'parent-face/pane/1]
	;]

	; Two-column list suitable for displaying a list of parameters
	PARAMETER-LIST: DATA-LIST with [
		size: 300x200
		cellfunc: func [face cell-face row col] [
			row: row - 1 + index? face/source-sorted
			cell-face/color: pick [200.200.200 255.255.255] col
			if all [
				face/selection face/selection/1/y = row
			] [
				cell-face/color: cell-face/color - 30
			]
		]
		row: [key value]
		definition: reduce [
			'key make column [
				width: 75
				font: [
					align: 'right
					style: 'bold
				]
			]
			'value make column [
				width: 225
			]
		]
		resize-column: 'value
		doc: make object! [
			info: "Displays key/value pairs as a list of parameters"
			pair: "Width and Height"
			block: ["Block of key/value pairs"]
		]
	]
]

; Exported styles
iterated-face: get-style 'iterated-face