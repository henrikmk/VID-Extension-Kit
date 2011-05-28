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
		size: 0x20
		font: make font [valign: 'middle]
		para: make para [wrap?: false]
		pos: 0x0
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
						; this shows the incorrect item
						act-face lst event 'on-click
						face/pos: pos ; maintain position even after list is closed
						lst/select-func face event
					]
				]
			]
		]
	]

	; cell text for LIST
	LIST-TEXT-CELL: LIST-CELL

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
		selected:					; block of integers with selected indexes
		;-- CTX-LIST information
		filter-spec:				; filter specification
		sort-direction:				; 'asc or 'desc
		sort-column:				; word name of column to sort by
		;-- Data source information
		data:						; source data list, always starts at header
		data-index:					; source index map
		data-sorted:				; source as sorted indexes
		data-filtered:				; source as sorted and filtered indexes
		data-display:				; indexes of column positions
		columns:					; description of columns
		column-order:				; block of words describing column output order
		output:						; output to list from source. index position describes first visible entry.
			none
		;-- Layout information
		spacing: 0					; spacing between rows in pixels
		over:						; face position currently hovering over
		spring: none
		;-- Sub-face creation function
		make-sub-face: func [face lo /init /local fs] [
			fs: face/sub-face: layout/parent/origin lo iterated-face 0x0; copy face/styles ; this only works during init
			fs/parent-face: face
			fs/size/y: fs/size/y - face/spacing
			if face/size [fs/size/x: face/size/x]
			set-parent-faces/parent fs face
			unless init [ctx-resize/align fs]
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
		;-- Row selection
		select-row: func [face indexes] [
			; select rows
			; unfinished function
			;face/select-func face
			insert clear head face/selected indexes ; indexes should be from the total list, not just visible items
;			length?

			; [?] - need the selection to occur on unfiltered data, so there is a general problem here

			; [?] - the selection is also necessary to perform on filtered data, so there are two sides to this problem

			; [!] - selection should be mapped to an internal index

			; [!] - also selection should adhere to sorted data

			; finish this function next. it makes sense to have this done prior to any other function

			; [!] - check that highlighting will follow filtered highlighting

			;face/update face ; is this needed?
		]
		;-- Row manipulation
		; CRUD functions?
		; insert, delete, update
		; actors for each function
		; on-edit
		; on-insert
		; on-delete
		edit-cell: func [x y data] [
			; the problem to fix is that this will essentially edit the data that we promised to separate out
			; list-view handles the data as well as the editing
			; we want to allow editing the data and then performing a simple update
			; perhaps this should be done in here
			; when editing this cell, we are updating the single value in the block/element/object
			; this causes many testing scenarios
			; this may be possible to use with in-line editing, but not sure
			; [!] - inline editing would use inline versions of the cell styles, so this should be done by the cell styles themselves
			; and then you do a get-face on the data in the sub-face
			; [!] - and the cells close up again
			; [!] - this is only useful for editing a single item very quickly
			act-face face event 'on-edit
			; update the face or the single row
			face/update face
		]
		edit-row: func [idx data] [
			; as used by inline editing
			change at face/data idx data
			act-face face event 'on-change
			; put the row selection here
			face/update face
		]
		insert-row: func [idx data] [
			; when inserting the row, use the proper location
			; what good is on-insert for?
			insert at face/data idx data
			act-face face event 'on-change
			; put the row selection here
			face/update face
		]
		append-row: func [data] [
			insert-row length? face/data data
		]
		delete-row: func [idx] [
			act-face face event 'on-change
			; update selection
			face/update face
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
		cell-func: func [face cell row col render /local fp r] [
			cell/pos: as-pair col row - 1 + index? face/output
			r: either all [render row <= length? face/output] [
				; call output here instead as it's much faster
				
				pick pick face/output row col
;				ctx-list/get-cell face row col
			][
				copy ""
			]
			if function? :render-func [
				render-func face cell
			]
			set-face/no-show cell r
		]
		;-- Cell render function
		render-func: func [face cell] [
			either find face/selected cell/pos/y [ ; [!] - this is bound on visible selection?
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
		;-- Content update function
		update: func [face] [
			ctx-list/set-filtered face
			;face/scroll/set-redrag face
			show face
			;if in face 'scroll [
			;	show face/scroll/v-scroller-face
			;]
		]
		;-- Cell selection function for mouse. FACE is cell that is clicked on.
		select-mode: 'multi
		start: end: none
		select-func: func [face event /local old s step] [
;			if tail? at data face/pos/y [exit] ; [!] - convert this to use the unfiltered position
			old: copy selected
			switch select-mode [
				mutex [
					;-- Single selection
					append clear selected start: end: face/pos/y ; [!] - convert this to use the unfiltered position
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
									append selected i
								]
							][
								append selected start: end: face/pos/y
							]
						]
						event/control [
							alter selected start: end: face/pos/y
						]
						true [
							append clear selected start: end: face/pos/y
						]
					]
				]
				persistent [
					;-- Selection stays
					alter selected start: end: face/pos/y
				]
			]
			sel: copy selected
			selected: head insert head clear selected unique sel
			if sel <> old [
				old: face/pos
				do-face self face/pos
				show self
				face/pos: old ; otherwise it changes due to SHOW
			]
		]
		;-- Cell selection function for keyboard. FACE is cell that is selected.
		key-select-func: func [face event /local old out s step] [
			if find [up down] event/key [
				old: copy selected
				out: head output
				dir: pick [1 -1] event/key = 'down
				if event/control [dir: dir * list-size face]
				if empty? out [clear selected return false]
				either empty? selected [
					append selected start: end: 1
				][
					case [
						all [select-mode <> 'mutex event/shift] [
							step: pick [1 -1] start < end
							for i start end step [remove find selected i]
							step: pick [1 -1] start < (end: end + dir)
							end: max 1 min length? out end
							for i start end step [insert tail selected i]
						]
						true [
							start: either start [first append clear selected end + dir][1]
							start: end: max 1 min length? out start
							selected/1: start
						]
					]
				]
				follow face end
			]
			sel: copy selected
			selected: head insert head clear selected unique sel
			if sel <> old [
				do-face self face/pos
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
					empty? face/selected [none]
					face/select-mode = 'mutex [
						pick head face/data-filtered first face/selected
					]
					true [
						vals: make block! length? face/selected
						foreach pos face/selected [
							append/only vals pick head face/data-filtered pos
						]
						vals
					]
				]
			]
			; resizes the sub-face of the list
			resize-face*: func [face size x y] [
				;-- Resize main list face and sub-face
				resize;/no-show
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
				face/data: data
				ctx-list/set-filtered face
			]
			; clears the face data block
			clear-face*: func [face] [
				clear face/selected
				clear face/data
				ctx-list/set-filtered face
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
			;if none? size [
			;	size: 300x200
			;	size/x: sub-face/size/x + first edge-size? self
			;] ; size is really set to 100x100
			; if size is set here, the sub-face will adhere to the size
			; if size is not set here, the sub-face will determine the size
			; still a problem, because we don't really determine the size from fill until the outer part has been aligned
			; this should also work, even if we are not running this through init
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
			output: copy data-sorted: copy data-index: copy data-filtered: copy data-display: make block! length? data
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
				if empty? out [face/over: none clear face/selected return false]
				face/over: either face/over [0x1 * dir + face/over][1x1]
				face/over: min max 1x1 face/over to pair! length? out
				follow face face/over/y
			]
			if find [#" " #"^M"] event/key [
				append clear face/selected face/over/y
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
; [ ] - figure out why list sub-face content does not resize properly to the width of the outer faces immediately
; [ ] - align
; [ ] - does not respond to ON-CLICK actor, due to incorrect mapping
; [x] - optional header layout, which will be freely defined
; [ ] - header button style, which loosely connects to the list by its index in the parent header face
		select-mode: 'multi
		specs:					; specification objects
			none
		resize-column:			; which single column resizes (integer)
			1
		access: make access [
			; adjusts the scroller ratio and drag (internal)
			set-scroller: func [face /only] [
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
				set-scroller face
			]
			clear-face*: func [face] [
				clear-face/no-show face/list data
				set-scroller face
			]
			scroll-face*: func [face x y] [
				scroll-face face/list x y
				set-scroller face
			]
			setup-face*: func [face value] [
				if any [block? value object? value] [
					face/specs: make block! []
					ctx-list/make-list-spec face value
					ctx-list/make-header-face face
					ctx-list/make-sub-face face
				]
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
			;-- Setup
			if setup [access/setup-face* self setup]
			pane: copy [across space 0]
			;-- Build Header
			if header-face [
				append pane compose/only [panel spring [bottom] (header-face) return]
			]
			;-- Build Pane
			append pane [
				scroller 20x100 fill 0x1 align [right] [
					scroll-face face/parent-face/list 0 get-face face
					face/parent-face/access/set-scroller/only face/parent-face
				] on-resize [
					;-- Do not resize, if scroller is either past end or not at beginning
					any [
						face/parent-face/access/past-end? face/parent-face
						face/parent-face/access/set-scroller face/parent-face
					]
				]
				list fill 1x1 align [left]
					[do-face face/parent-face none]
					with [ ; size is ignored, because it's made inside list size
						sub-face: (sub-face)
						data: (data) ; make sure it's same
						columns: (columns) ; make sure it's same
						column-order: (column-order) ; make sure it's same
					]
			]
			pane: layout/tight compose/deep/only pane
			set-parent-faces self
			any [size size: pane/size + any [all [object? edge 2 * edge/size] 0]]
			panes: reduce ['default pane: pane/pane]
			ctx-resize/resize pane/1 as-pair size/x - (2 * first edge-size self) 24 0x0
			;-- Name faces
			set either header-face [
				[header-face v-scroller list]
			][
				[v-scroller list]
			] pane
			selected: list/selected ; shared selection list
			list/select-mode: select-mode
			;-- Map actors from DATA-LIST to internal components
			foreach actor first actors [
				if find [on-click on-key] actor [
					list/actors/:actor: get in actors actor
				]
			]
			;-- Scroller setup
			access/set-scroller self
		]
	]

	SORT-BUTTON: BUTTON ctx-colors/colors/manipulator-color with [
		column: none ; the name or index position of the column that is to be sorted. this is set from the DATA-LIST. no it's not.
		list: none ; list face to sort
		direction: none ; direction to sort in
		; function to perform the sorting. perhaps this reaches into the context.
		; based on the column
		; when sorted, go by first
		; attach to list face
		; [ ] - add up/down arrow for sort in redraw
		; [ ] - allow setting the sort using the data-list itself, so the sort button needs to abstract only basic information
		; [ ] - when clicked, perform sort action on parent list
		; [ ] - sensibly find the parent using init
		states: [no-sort ascending descending]
		virgin: true ; do not repeat the first state
		surface: 'sort
		action: func [face value] [
			; [ ] - sort parent face by calling the parent action
			; [ ] - redraw parent face header
;			probe face/data
		]
		append init [
			;-- Find column position, if not given
			column
			;-- Find list face
			list
			;-- Find direction
		]
	]
	; [ ] perform reset sort action on parent list
	SORT-RESET-BUTTON: BUTTON 20x24 ctx-colors/colors/action-color with [
		font: none
		text: none
		surface: 'sort-reset
	]
	TABLE: LIST
	TEXT-LIST: LIST
	PARAMETER-LIST: DATA-LIST with [
		access: make access [
			; sets the content of face data and re-filters and re-sorts the list
			set-face*: func [face data /local values] [
				either object? data [
					values: make block! length? first data
					;-- Insert whole object in parameter list
					foreach [word value] third data [
						repend/only values [
							word
							either all [series? :value greater? index? :value length? head :value] [
								; dumb solution, I think, but until we get a universal way to mold such a string, we'll use it
								"Past End"
							][
								form :value
							]
						]
					]
				][
					;-- Insert as normal block data
					values: data
				]
				set-face/no-show face/list values
				set-scroller face
			]
		]
		sub-face: [
			across space 1x1
			list-text-cell bold spring [bottom right] right 100 200.200.200
			list-text-cell 180 spring [bottom]
		]
		header-face: [
			across space 0x0
			sort-button "Key" 100 spring [bottom right]
			sort-button "Value" 180 spring [bottom]
		]
	]

]

; Exported styles
iterated-face: get-style 'iterated-face