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
						act-face
							lst
							event
							pick [on-double-click on-click] event/double-click
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
	
	; column resizer for LIST
	LIST-RESIZER: RESIZER with [
		; needs an ON-DRAG that works on other ON-DRAG elements
		; also needs a different surface, so the list face won't fail here
		; 2 pixels wide
		; no drag bar necessary in sub-face, possibly
		; the drag bar needs to account for the face that it needs to redrag inside the on-drag item
		; 
		resize-column: func [face] [
			
		]
		append init [
			insert-actor-func self 'on-drag :resize-column
		]
	]

	; iterated list with user defined sub-face. internal use only.
	LIST: IMAGE with [
		;-- Faces
		sub-face:					; face that is used to iterate through the list view
		pane:						; iterated sub-face here
		v-scroller:					; vertical scroller attached to list face
		h-scroller:					; horizontal scroller attached to list face
		selected:					; block of integers with selected indexes in the original data
		highlighted:				; block of integers with highlighted indexes in the original data
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
		;-- Settings
		follow-size:				; whether to move a PAGE or a LINE, when following the selected row
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
			unless init [
				ctx-resize/align/no-show fs
			]
		]
		; determine number of visible rows in list
		list-size: func [face] [
			to integer! face/size/y - (any [attempt [2 * face/edge/size/y] 0]) / face/sub-face/size/y
		]
		; moves to the given position in the list and makes it visible, if not visible
		follow: func [face pos /local idx range size list-size] [
			any [pos exit]
			list-size: face/list-size face
			range: sort reduce [
				index? face/output
				min length? face/data subtract add index? face/output size: list-size 1
			]
			case [
				all [pos >= range/1 pos <= range/2] [exit]
				pos < range/1 [face/output: at head face/output pos]
				pos >= range/2 [face/output: at head face/output pos - size + 1]
			]
			; adjust new position by follow size
			if face/follow-size = 'page [
				case [
					; if cursor is now at top, move page size back
					equal? pos index? face/output [
						face/output: at face/output negate (list-size - 1)
					]
					; if cursor is now at bottom, move page size forward
					equal? pos - size + 1 index? face/output [
						face/output: min at face/output list-size at tail face/output negate list-size
					]
				]
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
			; this produces selected rows outside, which means that selected rows will appear at the bottom
			; with no text in them
			back-render-func face cell
			either inside [
				cell/row: pick face/data pick face/data-sorted cell/pos/y
				render-func face cell
			][
				empty-render-func face cell
			]
		]
		;-- Cell background render function (could be optimized, if we had disable-face*)
		back-render-func: func [face cell /local colors y-pos] [
			colors: ctx-colors/colors
			y-pos: pick face/data-sorted cell/pos/y
			case [
				find face/highlighted y-pos [
					cell/color:
						either flag-face? face disabled [
							colors/select-disabled-color
						][
							colors/field-select-color
						]
					cell/font/color:
						either flag-face? face disabled [
							colors/body-text-disabled-color
						][
							colors/body-text-color
						]
				]
				find face/selected y-pos [
					cell/color:
						either flag-face? face disabled [
							colors/select-disabled-color
						][
							colors/select-color
						]
					cell/font/color:
						colors/select-body-text-color
				]
				true [
					cell/color:
						colors/field-color
					cell/font/color:
						either flag-face? face disabled [
							colors/body-text-disabled-color
						][
							colors/body-text-color
						]
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
		key-select-func: func [face event /local dir keys old out s step] [
			case [
				#"^A" = event/key [
					select-face/no-show face not event/shift
				]
				#"^M" = event/key [
					act-face face none 'on-return
				]
				#"^[" = event/key [
					act-face face none 'on-escape
				]
				keys: find [up down] event/key [
					old: copy face/selected
					out: head face/output
					dir: pick [1 -1] event/key = 'down
					if event/control [dir: dir * list-size face]
					if empty? out [clear face/selected return false]
					either empty? face/selected [
						append face/selected pick face/data-sorted face/start: face/end: 1
					][
						case [
							all [select-mode <> 'mutex event/shift] [
								step: pick [1 -1] face/start < face/end
								for i face/start face/end step [remove find face/selected pick face/data-sorted i]
								step: pick [1 -1] face/start < (face/end: face/end + dir)
								face/end: max 1 min length? out face/end
								for i face/start face/end step [insert tail face/selected pick face/data-sorted i]
							]
							true [
								either face/start [
									append clear face/selected pick face/data-sorted face/start: face/end + dir
								][
									face/start: 1
								]
								face/start: face/end: max 1 min length? out face/start
								face/selected/1: pick face/data-sorted face/start
							]
						]
					]
					follow face face/end
				]
			]
			sel: copy face/selected
			face/selected: head insert head clear face/selected unique sel
			if sel <> old [
				do-face self get-face face
				if keys [act-face face none 'on-select]
			]
			event
		]
		;-- Accessor functions
		access: make access [
			; makes sure the list output does not scroll beyond the edge
			clamp-list: func [face] [
				face/output:
					at
						head face/output
						min
							index? face/output
							index? at tail face/output negate face/list-size face 
			]
			; performs face navigation using LIST-* styles in the sub-face
			key-face*: func [face event /local old] [
				event: face/key-select-func face event
				act-face face event 'on-key
				event
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
				not-equal? index? old index? face/output ; update only for show when the index shows a difference
			]
			; returns selected rows from the list face
			get-face*: func [face /local vals] [
				case [
					none? face/selected [none]
					face/select-mode = 'mutex [
						unless empty? face/selected [pick head face/data first face/selected]
					]
					empty? face/selected [make block! []]
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
				face/data: any [data make block! []]
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
			select-face*: func [face values /local old-selection new-value] [
				old-selection: copy face/selected
				clear face/selected
				case [
					;-- Select Nothing
					empty? face/data-sorted [
						act-face face none 'on-unselect
					]
					;-- Select Range
					any [integer? :values any-block? :values] [
						insert face/selected unique intersect to block! values face/data-sorted
						act-face face none 'on-select
					]
					;-- Select by Function
					any-function? :values [
						foreach id face/data-sorted [
							if values pick face/data id [insert tail face/selected id]
						]
						act-face
							face
							none
							either empty? face/selected ['on-unselect]['on-select]
					]
					;-- Select First
					'first = :values [
						insert face/selected first face/data-sorted
						follow face 1
						act-face face none 'on-select
					]
					;-- Select Next
					'next = :values [
						new-value: find face/data-sorted old-selection/1
						new-value: either new-value [
							at head new-value min index? next new-value index? back tail new-value
						][
							face/data-sorted
						]
						insert face/selected first new-value
						follow face index? new-value
						act-face face none 'on-select
					]
					;-- Select Previous
					'previous = :values [
						new-value: find face/data-sorted old-selection/1
						new-value: either new-value [back new-value][face/data-sorted]
						insert face/selected first new-value
						follow face index? new-value
						act-face face none 'on-select
					]
					;-- Select Last
					'last = :values [
						insert face/selected last face/data-sorted
						follow face length? face/data-sorted
						act-face face none 'on-select
					]
					;-- Select All
					true = :values [
						insert face/selected face/data-sorted
						act-face face none 'on-select
					]
				]
				face/start: face/selected/1
				face/end: all [not empty? face/selected last face/selected]
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
			; Set up columns
			any [columns columns: [column]]
			all [columns not column-order column-order: columns]
			; Build sub-face
			make-sub-face/init self any [sub-face [list-text-cell]] ; empty sub-face = infinite loop
			if none? size [
				size: 300x200
				size/x: sub-face/size/x + first edge-size? self
			]
			; Attach source data
			if none? data [data: make block! []]
			if object? data [data: ctx-list/object-to-data data]
			output: copy data-sorted: copy data-filtered: copy data-display: make block! length? data
			ctx-list/set-filtered self
			; Prepare selection
			any [block? selected selected: make block! []]
			any [block? highlighted highlighted: make block! []]
			; Prepare rendering
			pane: :pane-func
		]
	]

	; list with keyboard caret selection instead of plain selection
	CARET-LIST: LIST with [
		;-- Cell selection function for keyboard. FACE is the list that holds the caret.
		key-select-func: func [face event /local dir out s step] [
			if find [up down] event/key [
				out: head output
				dir: pick [1 -1] event/key = 'down
				if event/control [dir: dir * list-size face]
				if empty? out [
					face/over: none
					clear face/highlighted
					act-face face none 'on-unselect
					return false
				]
				either empty? face/highlighted [
					insert
						face/highlighted
						first either empty? face/selected [
							face/data-sorted
						][
							face/selected
						]
				][
					all [
						s: find face/data-sorted face/highlighted/1
						s: skip s dir
						change face/highlighted first either tail? s [back s][s]
					]
				]
				follow face first face/highlighted
				act-face face none 'on-highlight
			]
			if find [#" " #"^M"] event/key [
				unless empty? face/highlighted [
					append clear face/selected face/highlighted
				]
				if event/key = #"^M" [
					act-face face none 'on-return
				]
				act-face face none 'on-select
			]
			event
		]
	]

	; CARET-LIST used in CHOICE selector
	CHOICE-LIST: CARET-LIST fill 1x1 with [
		access: make access [
			; moves the window face to within screen-face dimensions
			scroll-face*: func [face x y /local dir menu-face opener-face window-face] [
				dir: pick [-1 1] positive? y
				opener-face: get-opener-face
				window-face: find-window opener-face
				menu-face: get-menu-face
				menu-face/offset/y: opener-face/size/y * dir + menu-face/offset/y
				; Fix pixel offset error for negative values
				; (not a perfect fix, as there is still a one-pixel but constant offset)
				if menu-face/offset/y < 0 [menu-face/offset/y: menu-face/offset/y - 1]
				; Restrain to opener-face top
				menu-face/offset/y:
					min
						menu-face/offset/y
						window-face/offset/y + opener-face/win-offset/y
				; Restrain to opener-face bottom
				menu-face/offset/y:
					max
						menu-face/offset/y
						add
							window-face/offset/y
							opener-face/win-offset/y + opener-face/size/y - menu-face/size/y
				show menu-face
				false
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
;		surface: 'static-frame
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
		follow-size:			; whether to move a PAGE or a LINE, when following the selected row
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
				event: face/list/access/key-face* face/list event
				set-scroller face
				event
			]
			set-face*: func [face data] [
				face/list/access/set-face* face/list data
				face/data: face/list/data
				set-scroller face
			]
			get-face*: func [face] [
				face/list/access/get-face* face/list
			]
			clear-face*: func [face] [
				face/list/access/clear-face* face/list data
				face/data: face/list/data
				set-scroller face
			]
			scroll-face*: func [face x y] [
				also
					face/list/access/scroll-face* face/list x y
					set-scroller face
			]
			setup-face*: func [face values /local output-length] [
				;-- Reset face values
				if object? values [values: reduce ['input words-of values]]
				foreach
					word
					[input output widths adjust modes types names resize-column header-face sub-face render]
					[set in face word none]
				foreach
					[word value]
					any [values []]
					[
						value:
							case [
								lit-word?	:value	[:value]
								word?		:value	[get :value]
								path?		:value	[either value? :value [do :value][:value]]
								object?		:value	[words-of :value]
								true				[:value]
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
				;-- Follow Size
				if none? face/follow-size [
					face/follow-size: 'line
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
						panel fill 1x0 spring [bottom] (face/header-face) return
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
							sub-face:		(face/sub-face)
							data:			(face/data)
							columns:		(face/input)
							column-order:	(face/column-order)
						]
				]
				face/pane: layout/tight compose/deep/only face/pane
				set-parent-faces face
				;-- Calculate sizes
				any [face/size face/size: face/pane/size + any [all [object? face/edge 2 * face/edge/size] 0]]
				face/panes: reduce ['default face/pane: face/pane/pane]
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
				face/list/select-mode:	face/select-mode
				face/list/follow-size:	face/follow-size
				if get in face 'back-render [face/list/back-render-func: func [face cell] get in face 'back-render] 
				if get in face 'empty-render [face/list/empty-render-func: func [face cell] get in face 'empty-render]
				if get in face 'render [face/list/render-func: func [face cell] get in face 'render]
				;-- Map actors from DATA-LIST to internal components
				foreach actor first face/actors [
					if find [
						on-click on-key on-select on-unselect on-return on-escape on-double-click
					] actor [
						pass-actor face face/list actor
					]
				]
				;-- Setup Scroller
				insert-actor-func face 'on-align get in access 'set-scroller
				insert-actor-func face 'on-resize get in access 'set-scroller
			]
			select-face*: func [face values] [
				face/list/access/select-face* face/list :values
				set-scroller face
			]
			query-face*: func [face value] [
				face/list/access/query-face* face/list :value
				set-scroller face
			]
			edit-face*: func [face op value pos] [
				face/list/access/edit-face* face/list :op :value :pos
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
	TEXT-LIST: DATA-LIST setup [
		input [items]
		widths [200]
		select-mode 'mutex
		header-face []
	]
	PARAMETER-LIST: DATA-LIST setup [
		; need to allow defining bold font
		input [key value]
		output [key | value]
		widths [100 200]
		resize-column value
	]

]

; Exported styles
iterated-face: get-style 'iterated-face