rebol []

; replacement list view. the old one is too complex.

stylize/master [
	; Prototypes for iterated face styles
	ITERATED-FACE: BLANK-FACE fill 1x0 spring [bottom]
	ITERATED-TEXT: TEXT fill 1x0 spring [bottom]
	ITERATED-TXT: TXT fill 1x0 spring [bottom]

	; text styles are modified in-place to accommodate the list, so we don't really have them here

	; generic cell for LIST
	LIST-CELL: TEXT with [
		text: none
		data: none
		row: none
		size: 0x20
		font: make font [valign: 'middle]
		para: make para [wrap?: false]
		pos: 0x0
		name: none
		feel: make face/feel [
			over: func [face act pos] [
				face/parent-face/parent-face/over: all [act face/pos]
				show face
			]
			engage: func [face act event /local lst pos] [
				lst: face/parent-face/parent-face
				if act = 'down [
					if all [
						in lst 'select-func
						any-function? get in lst 'select-func
						face/pos/y <= length? lst/data-filtered ; do not run for cells that are outside the list filter
					] [
						pos: face/pos
						lst/select-func face event
						act-face lst event pick [on-double-click on-click] event/double-click
						face/pos: pos ; maintain position even after list is closed
					]
				]
			]
		]
	]

	; cell text for LIST
	LIST-TEXT-CELL: LIST-CELL

	; editable cell text for LIST
	LIST-EDIT-CELL: LIST-CELL with [
		; a new feel for this type of text editing
		; need to doubleclick to bring up the cursor
	]

	; cell text for LIST with offset and icon for tree fold/unfold
	LIST-TREE-CELL: LIST-CELL with [
		level: 1
		node-type: 'data
		; [o] - specify level
		; [ ] - specify folder/data
		; [ ] - specify fold action
		; [ ] - specify unfold action
		; [ ] - specify fold icon
		; [ ] - specify unfold icon
	]

	; cell image for LIST
	LIST-IMAGE-CELL: LIST-CELL

	; iterated list with user defined sub-face. internal use only.
	LIST: IMAGE with [
		;-- Faces
		sub-face:					; face that is used to iterate through the list view
		pane:						; iterated sub-face here
		v-scroller:					; vertical scroller attached to list face
		h-scroller:					; horizontal scroller attached to list face
		selected:					; block of integers with selected indexes in the original data
		;-- CTX-LIST information
		filter-func:				; filter function
		sort-direction:				; 'asc, 'ascending or 'desc, 'descending
		sort-column:				; word name of column to sort by
		;-- Data source information
		prototype:					; row prototype
		data:						; source data list, always starts at header
		data-sorted:				; source as sorted indexes (block of integers)
		data-filtered:				; source as sorted and filtered indexes (block of integers)
		data-display:				; indexes of column positions (block of integers)
		columns:					; description of columns (block of words)
		column-order:				; block of words describing column output order (block of words)
		output:						; output to list from source. index position describes first visible entry.
			none
		;-- Layout information
		spacing: 0					; spacing between rows in pixels
		over:						; face position currently hovering over
		spring: none
		feel: make feel [
			redraw: func [face act pos][
				if all [not svv/resizing? act = 'draw] [
					act-face face none 'on-redraw
				]
			]
		]
		;-- Sub-face creation function
		make-sub-face: func [face lo /init /local fs] [
			fs: face/sub-face: layout/parent/origin lo iterated-face 0x0; copy face/styles ; this only works during init
			fs/parent-face: face
			fs/size/y: fs/size/y - face/spacing
			if face/size [fs/size/x: face/size/x]
			set-parent-faces/parent fs face
			unless init [ctx-resize/align/no-show fs]
		]
		list-size: func [face] [
			to integer! face/size/y - (any [attempt [2 * face/edge/size/y] 0]) / face/sub-face/size/y
		]
		; moves to the given position in the list and makes it visible, if not visible
		follow: func [face pos /local idx range size] [
			any [pos exit]
			range: sort reduce [
				index? face/output
				min length? face/data subtract add index? face/output size: face/list-size face 1
			]
			case [
				all [pos >= range/1 pos <= range/2] [exit]
				pos < range/1 [face/output: at head face/output pos]
				pos >= range/2 [face/output: at head face/output pos - size + 1]
			]
		]
		; calculates list size ratio (internal)
		calc-ratio: func [face] [
			divide face/list-size face max 1 length? head face/output
		]
		; calculates the list position (internal)
		calc-pos: func [face] [
			divide subtract index? face/output 1 max 1 (length? head face/output) - face/list-size face
		]
		; maps the face type to the sub-faces through setup types
		map-type: func [type] [
			any [
				select [
					number! list-text-cell
					string! list-text-cell
					image! list-image-cell
				] to word! type
				'list-text-cell ; default
			]
		]
		;-- Pane rendering function
		pane-func: func [face [object!] id [integer! pair!] /local count fs spane sz] [
			fs: face/sub-face id
			if pair? id [return 1 + second id / fs/size]
			fs/offset: fs/old-offset: id - 1 * fs/size * 0x1
			sz: size/y - any [attempt [2 * face/edge/size/y] 0]
			if fs/offset/y > sz [return none]
			count: 0
			foreach item fs/pane [
				if object? item [
					face/cell-func
						face							; list face
						item							; cell face
						id								; physical row
						count: count + 1				; phyiscal column
						fs/offset/y + fs/size/y <= sz	; render or not
				]
			]
			fs
		]
		;-- Cell content function
		cell-func: func [face cell row col render /local fp inside r] [
			cell/pos: as-pair col row - 1 + index? face/output
			cell/name: pick face/column-order col
			r: all [
				render
				inside: row <= length? face/output
				pick pick face/output row col
			]
			cell/access/set-face* cell r
			back-render-func face cell
			either inside [
				cell/row: pick face/data pick face/data-sorted cell/pos/y
				render-func face cell
			][
				empty-render-func face cell
			]
		]
		;-- Cell background render function
		back-render-func: func [face cell] [
			either find face/selected pick face/data-sorted cell/pos/y [
				cell/color:
					either flag-face? face disabled [
						ctx-colors/colors/select-disabled-color
					][
						ctx-colors/colors/select-color
					]
				cell/font/color: ctx-colors/colors/select-body-text-color
			][
				cell/color: ctx-colors/colors/field-color
				cell/font/color:
					either flag-face? face disabled [
						ctx-colors/colors/body-text-disabled-color
					][
						ctx-colors/colors/body-text-color
					]
			]
			if odd? cell/pos/y [
				cell/color: cell/color - 10
			]
		]
		;-- Cell foreground render function
		render-func: none
		;-- Empty Cell foreground render function
		empty-render-func: none
		;-- Content update function
		update: func [face] [
			ctx-list/set-filtered face
			; what is needed here is to keep the place at where it needs to be when sorting
			; this means that if the length does not change unreasonably, then there is no need to alter the position
			; perhaps we should then stick to where it is and then clamp
;			face/scroll/set-redrag face
			show face
			;if in face 'scroll [
			;	show face/scroll/v-scroller-face
			;]
		]
		;-- Cell selection function for mouse. FACE is cell that is clicked on.
		select-mode: 'multi
		start: end: none
		select-func: func [face event /local old s step] [
			old: copy selected
			lst: face/parent-face/parent-face
			switch select-mode [
				mutex [
					;-- Single selection
					append clear selected pick lst/data-sorted start: end: face/pos/y
				]
				multi [
					;-- Select multiple rows
					case [
						event/shift [
							either start [
								step: pick [1 -1] start < end
								for i start end step [remove find selected i]
								step: pick [1 -1] start < end: face/pos/y
								for i start face/pos/y step [
									append selected pick lst/data-sorted i
								]
							][
								append selected pick lst/data-sorted start: end: face/pos/y
							]
						]
						event/control [
							alter selected pick lst/data-sorted start: end: face/pos/y
						]
						true [
							append clear selected pick lst/data-sorted start: end: face/pos/y
						]
					]
				]
				persistent [
					;-- Selection stays
					alter selected pick lst/data-sorted start: end: face/pos/y
				]
			]
			sel: copy selected
			selected: head insert head clear selected unique sel
			if sel <> old [
				old: face/pos
				do-face self selected
				show self
				face/pos: old ; otherwise it changes due to SHOW
			]
			act-face self none 'on-select
		]
		;-- Cell selection function for keyboard. FACE is the list in focus.
		key-select-func: func [face event /local old out s step] [
			case [
				#"^A" = event/key [
					select-face/no-show face not event/shift
				]
				#"^/" = event/key [
					act-face face none 'on-return
				]
				#"^/" = event/key [
					act-face face none 'on-escape
				]
				find [up down] event/key [
					old: copy selected
					out: head output
					dir: pick [1 -1] event/key = 'down
					if event/control [dir: dir * list-size face]
					if empty? out [clear selected return false]
					either empty? selected [
						append selected pick face/data-sorted start: end: 1
					][
						case [
							all [select-mode <> 'mutex event/shift] [
								step: pick [1 -1] start < end
								for i start end step [remove find selected pick face/data-sorted i]
								step: pick [1 -1] start < (end: end + dir)
								end: max 1 min length? out end
								for i start end step [insert tail selected pick face/data-sorted i]
							]
							true [
								either start [
									append clear selected pick face/data-sorted start: end + dir
								][
									start: 1
								]
								start: end: max 1 min length? out start
								selected/1: pick face/data-sorted start
							]
						]
					]
					follow face end
				]
			]
			sel: copy selected
			selected: head insert head clear selected unique sel
			if sel <> old [
				do-face self get-face face
				act-face face none 'on-select
			]
		]
		;-- Accessor functions
		access: make access [
			; makes sure the list output does not scroll beyond the edge
			clamp-list: func [face /local sz] [
				if all [
					not head? face/output
					greater? sz: face/list-size face length? face/output
				] [
					face/output: skip tail face/output negate sz
				]
			]
			; performs face navigation using LIST-* styles in the sub-face
			key-face*: func [face event /local old] [
				face/key-select-func face event
				act-face face event 'on-key
			]
			; scrolls the list face
			scroll-face*: func [face x y /local old size] [
				old: face/output
				size: face/list-size face
				face/output:
					either 1 < abs y [ ; OSX sends only 1 step instead of 3
						;-- Scroll wheel
						skip face/output pick [1 -1] positive? y
					][
						;-- Scroll bar
						at head face/output add y * subtract length? face/data size 1
					]
				clamp-list face
				act-face face event 'on-scroll
				not-equal? index? old index? face/output ; update only for show when the index shows a difference
			]
			; returns selected rows from the list face
			get-face*: func [face /local vals] [
				case [
					none? face/selected [none]
					empty? face/selected [make block! []]
					face/select-mode = 'mutex [
						pick head face/data first face/selected
					]
					true [
						vals: make block! length? face/selected
						foreach pos face/selected [
							append/only vals pick head face/data pos
						]
						vals
					]
				]
			]
			; resizes the sub-face of the list
			resize-face*: func [face size x y] [
				;-- Resize main list face and sub-face
				resize/no-show
					face/sub-face
					as-pair
						face/size/x
						face/sub-face/size/y
					face/sub-face/offset
				;-- Clamp list if it's beyond end
				clamp-list face
			]
			; sets the content of face data and re-filters and re-sorts the list
			set-face*: func [face data] [
				clear face/selected
				if object? data [
					data: ctx-list/object-to-data data
				]
				face/data: data
				ctx-list/set-filtered face
				act-face face none 'on-unselect
			]
			; clears the face data block
			clear-face*: func [face] [
				clear face/selected
				clear face/data
				ctx-list/set-filtered face
				act-face face none 'on-unselect
			]
			; selects rows in the face
			select-face*: func [face values] [
				clear face/selected
				case [
					;-- Select Nothing
					empty? face/data-sorted [
						act-face face none 'on-unselect
					]
					;-- Select Range
					any-block? :values [
						insert face/selected unique intersect values face/data-sorted
						act-face face none 'on-select
					]
					;-- Select by Function
					any-function? :values [
						clear face/selected
						foreach id face/data-sorted [
							if values pick face/data id [insert tail face/selected id]
						]
						act-face face none either empty? face/selected ['on-unselect]['on-select]
					]
					;-- Select First
					'first = :values [
						insert clear face/selected first face/data-sorted
						follow face 1
						act-face face none 'on-select
					]
					;-- Select Last
					'last = :values [
						insert clear face/selected last face/data-sorted
						follow face length? face/data-sorted
						act-face face none 'on-select
					]
					;-- Select All
					true = :values [
						insert face/selected face/data-sorted
						act-face face none 'on-select
					]
				]
			]
			; performs filtering of rows in the list
			query-face*: func [face value] [
				clear face/selected
				face/filter-func: :value
				ctx-list/set-filtered face
				act-face face none 'on-unselect
			]
			; perform edits on the list, when the list is object based
			edit-face*: func [face op value pos /local j] [
				pos:
					switch/default pos [
						last [length? face/data]
						first [1]
						all [repeat i length? face/data [append [] i]]
					][
						face/selected
					]
				switch :op [
					add [
						append/only face/data make face/prototype any [:value []]
						ctx-list/set-filtered face
						select-face face 'last
					]
					duplicate [
						j: length? face/data
						repeat i length? pos [
							append/only face/data make face/prototype pick face/data pick pos i
						]
						ctx-list/set-filtered face
						select-face face array/initial length? pos does [j: j + 1]
					]
					edit update [
						repeat i length? pos [
							change at face/data pick pos i make pick face/data pick pos i :value
						]
						ctx-list/set-filtered face
					]
					delete remove [
						repeat i length? pos [change at face/data pick pos i ()]
						remove-each row face/data [not value? 'row]
						clear pos
						select-face/no-show face none
						ctx-list/set-filtered face
					]
				]
			]
		]
		init: [
			;-- Build sub-face from columns
			case [
				;-- Use sub-face directly and supply sorting and type information from columns
				all [sub-face columns] [
					; use columns for sorting and types and nothing else
					; this is applied to the ctx-list attached here
				]
				;-- Create new sub-face
				all [not sub-face columns] [
					sub-face: make block! 100
					foreach column columns [
						append sub-face map-type column/type
					]
				]
				;-- Create sub-face from data
				all [not sub-face not columns] [
					either block? data [
						unless empty? data [
							sub-face: make block! 100
							switch/default type?/word data/1 [
								object! [
									foreach item first data/1 [
										append sub-face map-type type? item
									]
								]
								block! [
									foreach item data/1 [
										append sub-face map-type type? item
									]
								]
							] [
								; assuming that all data are of the same type
								append sub-face map-type type? data/1
							]
						]
					][
						;-- Create empty single column list
						sub-face: [list-text-cell 100x20 spring [bottom] fill 1x0]
					]
				]
			]
			make-sub-face/init self any [sub-face attempt [second :action] [list-text-cell]] ; empty sub-face = infinite loop
			if none? size [
				size: 300x200
				size/x: sub-face/size/x + first edge-size? self
			]
			;-- Build column order
			unless block? column-order [
				column-order: make block! []
				repeat i length? sub-face/pane [
					append column-order to word! join 'column- i
				]
			]
			;-- Build columns from sub-face
			case [
				;-- Create column list from sub-face
				all [sub-face not columns] [
					columns: make block! []
					repeat i length? sub-face/pane [
						append columns to word! join 'column- i
						append columns none
					]
				]
			]
			;-- Attach source data
			if none? data [data: make block! []]
			if object? data [data: ctx-list/object-to-data data]
			output: copy data-sorted: copy data-filtered: copy data-display: make block! length? data
			ctx-list/set-filtered self
			any [block? selected selected: make block! []]
			pane: :pane-func
		]
	]

	; list with keyboard caret selection instead of plain selection
	CARET-LIST: LIST with [
		;-- Cell selection function for keyboard. FACE is cell that acts as caret.
		; face/selected is not actually touched and this only works on single selection
		key-select-func: func [face event /local out s step] [
			if find [up down] event/key [
				out: head output
				dir: pick [1 -1] event/key = 'down
				if event/control [dir: dir * list-size face]
				if empty? out [
					face/over: none
					clear face/selected
					act-face face none 'on-unselect
					return false
				]
				face/over: either face/over [0x1 * dir + face/over][1x1]
				face/over: min max 1x1 face/over to pair! length? out
				follow face face/over/y
				act-face face none 'on-select
			]
			if find [#" " #"^M"] event/key [
				append clear face/selected face/over/y
				act-face face none 'on-select
			]
		]
	]

	; iterated bottom-up list with user defined sub-face. internal use only.
	REVERSE-LIST: LIST with [
		; determine which changes are needed here:
		; output is reversed, so we need to output this somehow reversed, possibly pane-func ID
		; scroller should not be affected, as it behaves like normal, but is clamped to the bottom
		; the filter functions should not be needed, but may be possible to do
	]

	; panel that serves a list and navigation faces. internal.
	NAV-LIST: PANEL with [
		;-- Faces
		list:					; list face
		pane:					; layed out list and navigation faces
		;-- List information
		data:					; data block to use as source, passed to LIST
		columns:				; column description, passed to LIST
		column-order:			; column order, passed to LIST
		sub-face:				; sub-face block or layout, passed to LIST
		back-render:			; background cell render function body
		empty-render:			; empty row render function body
		render:					; cell render function body
		text:					; does not contain focusable text
			none
		;-- Basic accessors
		access: make access [
			get-face*: func [face] [
				if face/list [get-face face/list]
			]
		]
	]

	; standard data list with list, user defined header and user defined sub-face or column definition
	DATA-LIST: NAV-LIST with [ ; [!] - compound later
		;-- Faces
		header-face:			; header face
		v-scroller:				; vertical scroller face
		h-scroller:				; horizontal scroller face
			none
; [?] - do not allow focusing of individual items in list sub-face
; [ ] - inline field system, realized by having text styles that do inline editing
		;-- Specification
		prototype:				; prototype for list row (object)
		input:					; input words for data source (block of words)
		output:					; output words for data display (block of words)
		select-mode:			; selection mode (MULTI, MUTEX, PERSISTENT) (block of words)
		widths:					; widths of columns in pixels (block of integers)
		adjust:					; LEFT, RIGHT or CENTER adjustment of column texts (block of words)
		modes:					; Column modes (SORT, NO-SORT, FILTER)
		types:					; Column datatypes (block of datatypes)
		names:					; Column names (block of strings)
		selected:				; selected rows in list (block of integers)
		resize-column:			; which single column resizes (word)
			none
		access: make access [
			; adjusts the scroller ratio and drag (internal)
			set-scroller: func [face /only] [
				; this is done on each scroll
				face/v-scroller/ratio: face/list/calc-ratio face/list face/v-scroller
				face/v-scroller/redrag face/v-scroller/ratio
				any [only set-face/no-show face/v-scroller face/list/calc-pos face/list]
			]
			; checks if the output is scrolled past end
			past-end?: func [face] [
				all [
					not head? face/list/output ; not at beginning
					greater?
						face/list/list-size face/list
						length? face/list/output ; is past end
				]
			]
			key-face*: func [face event] [
				key-face face/list event
				set-scroller face
			]
			set-face*: func [face data] [
				set-face/no-show face/list data
				face/data: face/list/data
				set-scroller face
			]
			get-face*: func [face] [
				get-face face/list
			]
			clear-face*: func [face] [
				clear-face/no-show face/list data
				face/data: face/list/data
				set-scroller face
			]
			scroll-face*: func [face x y] [
				scroll-face face/list x y
				set-scroller face
			]
			setup-face*: func [face values /local output-length] [
				;-- Reset face values
				if object? values [values: reduce ['input words-of values]]
				foreach
					word
					[input output select-mode widths adjust modes types names resize-column header-face sub-face render]
					[set in face word none]
				foreach
					[word value]
					any [values []]
					[
						value:
							case [
								word? value [either value? :value [get :value][:value]]
								path? value [either value? :value [do :value][:value]]
								object? value [words-of :value]
								true [:value]
							]
						set in face word value
					]
				;-- Convert Input and Output, if they are objects
				if object? face/input [face/input: words-of face/input]
				if object? face/output [face/output: words-of face/output]
				;-- Determine prototype from input, output, first row of data or default in that order
				face/prototype:
					case [
						block? face/input		[ctx-list/make-list-object/words length? face/input face/input]
						block? face/output		[ctx-list/make-list-object/words length? face/output face/output]
						not block? face/data	[ctx-list/make-list-object 1]
						empty? face/data		[ctx-list/make-list-object 1]
						block? face/data/1		[ctx-list/make-list-object length? face/data/1]
						object? face/data/1		[make face/data/1 []]
						true					[ctx-list/make-list-object 1]
					]
				set face/prototype none
				;-- Determine Input and Output
				case [
					all [face/input not face/output] [face/output: copy face/input]
					all [not face/input face/output] [face/input: copy face/output]
					not all [face/input face/output] [face/output: copy face/input: words-of face/prototype]
				]
				;-- Determine Output Length
				face/column-order: copy face/output
				remove-each val face/column-order [find [| ||] val]
				output-length: length? face/column-order
				;-- Names
				if none? face/names [
					face/names: make block! length? face/output
					foreach word face/column-order [
						append face/names uppercase/part form word 1
					]
				]
				;-- Select Mode
				if none? face/select-mode [
					face/select-mode: 'multi
				]
				;-- Widths
				if none? face/widths [
					face/widths: array/initial output-length 100
				]
				;-- Adjustment
				if none? face/adjust [
					face/adjust: array/initial output-length 'left
				]
				;-- Types
				if none? face/types [
					face/types: array/initial output-length string!
				]
				;-- Modes
				if none? face/modes [
					face/modes: array/initial output-length 'sort
				]
				;-- Resize column
				if none? face/resize-column [
					face/resize-column: first face/column-order
				]
				;-- Header Face
				if none? face/header-face [
					ctx-list/make-header-face face
				]
				;-- Sub Face
				if none? face/sub-face [
					ctx-list/make-sub-face face
				]
				;-- Arrange Layout
				face/pane: copy [across space 0]
				;-- Build Header
				if face/header-face [
					append face/pane compose/only [
						panel blue fill 1x0 spring [bottom] (face/header-face) return
					]
				]
				;-- Build Pane
				append face/pane [
					scroller 20x100 fill 0x1 align [right] [
						scroll-face face/parent-face/list 0 get-face face
					]
					list fill 1x1 align [left]
						[do-face face/parent-face none]
						with [ ; size is ignored, because it's made inside list size
							sub-face: (face/sub-face)
							data: (face/data)
							columns: (face/input)
							column-order: (face/column-order)
						]
				]
				face/pane: layout/tight compose/deep/only face/pane
				set-parent-faces face
				;-- Calculate sizes
				any [face/size face/size: face/pane/size + any [all [object? face/edge 2 * face/edge/size] 0]]
				face/panes: reduce ['default face/pane: face/pane/pane]
				either empty? face/init [
					ctx-resize/align/no-show face
				][
					ctx-resize/resize/no-show face/pane/1 as-pair face/size/x - (2 * first edge-size face) 24 0x0
				]
				;-- Name faces
				set bind either face/header-face [
					[header-face v-scroller list]
				][
					[v-scroller list]
				] face face/pane
				;-- Sharing
				face/data:				face/list/data
				face/selected:			face/list/selected
				face/list/prototype:	face/prototype
				face/list/v-scroller:	face/v-scroller
				face/list/select-mode:	does [face/select-mode]
				if get in face 'back-render [face/list/back-render-func: func [face cell] get in face 'back-render]
				if get in face 'empty-render [face/list/empty-render-func: func [face cell] get in face 'empty-render]
				if get in face 'render [face/list/render-func: func [face cell] get in face 'render]
				;-- Map actors from DATA-LIST to internal components
				foreach actor first face/actors [
					if find [on-click on-key on-select on-unselect on-double-click] actor [
						face/list/actors/:actor: get in face/actors actor
					]
				]
				;-- Setup Scroller
				insert-actor-func face 'on-align get in access 'set-scroller
				insert-actor-func face 'on-resize get in access 'set-scroller
				;-- Actions
				;if empty? face/selected [act-face face none 'on-unselect]
			]
			select-face*: func [face values] [
				select-face/no-show face/list :values
				set-scroller face
			]
			query-face*: func [face value] [
				query-face/no-show face/list :value
				set-scroller face
			]
			edit-face*: func [face op value pos] [
				edit-face/at/no-show face/list :op :value :pos
				set-scroller face
			]
		]
		;-- List functions
		update: func [face] [
			face/list/update face/list
		]
		follow: func [face pos] [
			face/list/follow face/list pos
			set-face/no-show face/v-scroller face/list/calc-pos face/list
		]
		;-- Dialect Words
		words: [
			data [
				if block? args [new/data: args/2]
				next args
			]
		]

		init: [
			access/setup-face* self setup
		]
	]

	; single sort button for the header face
	SORT-BUTTON: BUTTON ctx-colors/colors/manipulator-color with [
		column:		none ; the name or index position of the column that is to be sorted.
		list:		none ; list face to sort
		feel:		svvf/mutex
		access:		ctx-access/data-state
		states:		[no-sort ascending descending]
		virgin:		true ; do not repeat the no-sort state
		surface:	'sort
		action: func [face value] [
			any [
				face/list
				face/list: find-style face/parent-face/parent-face 'list
			]
			face/list/sort-direction: first face/states
			face/list/sort-column: face/column
			ctx-list/set-sorting face/list
			scroll-face/no-show face/list 0 get-face face/list/v-scroller
			svvf/reset-related-faces face/parent-face
			show face/list
		]
		words: [
			sort-column [
				if block? args [new/column: args/2]
				next args
			]
		]
	]

	; perform reset sort action on parent list
	SORT-RESET-BUTTON: BUTTON 20x24 ctx-colors/colors/action-color with [
		font:		none
		text:		none
		list:		none ; list face to unsort
		surface:	'sort-reset
		action: func [face value] [
			any [
				face/list
				face/list: find-style face/parent-face/parent-face 'list
			]
			if face/list/sort-column [
				foreach f face/parent-face/pane [
					any [f = face clear-face f]
				]
				face/list/sort-direction: 'ascending
				face/list/sort-column: none
				ctx-list/set-sorting face/list
				scroll-face/no-show face/list 0 get-face face/list/v-scroller
				show face/list
			]
		]
	]

	; column filtering button
	FILTER-BUTTON: CHOICE with [
		column:		none
		list:		none
		choices:	[all "<All>" none "<None>" not-empty "<Not Empty>" empty "<Empty>"]
		action: func [face value] [
			; all
			; empty
			; not empty
			; unique entries
		]
		; need to allow changing this every time the contents change
		; need a method to set this face up, so we might need a new setup-face for this
		; derive filter-button from choice and then provide a new setup-face
		access: make access [
			setup-face*: func [face value] [
				; get this from parent
				; but the values must be fed in here from the outside
				
				face/setup: value
				if value [
					face/data: copy face/setup
					set-face* face face/data/1
				]
			]
		]
		append init [
			access/setup-face* self choices
		]
		words: [
			sort-column [
				if block? args [new/column: args/2]
				next args
			]
		]
	]

	TABLE: LIST
	TEXT-LIST: LIST
	PARAMETER-LIST: DATA-LIST with [
		setup: [
			; need to allow defining bold font
			input [key value]
			output [key | value]
			widths [100 200]
			resize-column value
		]
	]

]

; Exported styles
iterated-face: get-style 'iterated-face