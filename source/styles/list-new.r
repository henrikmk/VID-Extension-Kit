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
			engage: func [face act event /local lst] [
				lst: face/parent-face/parent-face
				if act = 'down [
					if all [
						in lst 'select-func
						any-function? get in lst 'select-func
					] [
						lst/select-func face event
					]
					do-face lst face/pos ; run the action for the list on click
					act-face lst event 'on-click ; run on-click actor for list on click
				]
			]
		]
	]

	; cell text for LIST
	LIST-TEXT-CELL: LIST-CELL

	; cell text for LIST with offset and icon for tree fold/unfold
	LIST-TREE-CELL: LIST-CELL with [
		; [ ] - specify level
		; [ ] - specify fold action
		; [ ] - specify unfold action
		; [ ] - specify fold icon
		; [ ] - specify unfold icon
	]

	; cell image for LIST
	LIST-IMAGE-CELL: LIST-CELL

	; iterated list with user defined subface. internal use only.
	LIST: IMAGE with [
		;-- Faces
		subface:					; face that is used to iterate through the list view
		pane:						; iterated subface here
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
		;-- Subface creation function
		make-subface: func [face lo /local fs] [
			fs: face/subface: layout/parent/origin/styles lo iterated-face 0x0 copy face/styles
			fs/parent-face: face
			fs/size/y: fs/size/y - face/spacing
			if face/size [fs/size/x: face/size/x]
			set-parent-faces/parent fs face
			align fs
		]
		list-size: func [face] [
			to-integer
				face/size/y - (any [attempt [2 * face/edge/size/y] 0]) / face/subface/size/y
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
		; maps the face type to the subfaces through setup types
		map-type: func [type] [
			any [
				select [
					number! list-text-cell
					string! list-text-cell
					image! list-image-cell
				] to-word type
				'list-text-cell ; default
			]
		]
		;-- Row selection
		select-row: func [face indexes] [
			; select rows
			;face/select-func face
			insert clear head face/selected indexes
;			length? 
			; need the selection to occur on unfiltered data, so there is a general problem here
			; selection should be mapped to an internal index
			remove-each idx face/selected
			face/update face
		]
		;-- Pane rendering function
		pane-func: func [face [object!] id [integer! pair!] /local count fs spane sz] [
			fs: face/subface id
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
			either find face/selected cell/pos/y [
				cell/color:
					either flag-face? face disabled [
						svvc/select-disabled-color
					][
						svvc/select-color
					]
				cell/font/color: svvc/select-body-text-color
			][
				cell/color: svvc/field-color
				cell/font/color:
					either flag-face? face disabled [
						svvc/body-text-disabled-color
					][
						svvc/body-text-color
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
		select-func: func [face event /local s step] [
			if tail? at data face/pos/y [exit]
			switch select-mode [
				mutex [
					;-- Single selection
					append clear selected start: end: face/pos/y
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
			show self
		]
		;-- Cell selection function for keyboard. FACE is cell that is selected.
		key-select-func: func [face event /local out s step] [
			if find [up down] event/key [
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
			; performs face navigation using LIST-* styles in the subface
			key-face*: func [face event /local old] [
				old: copy face/selected
				face/key-select-func face event
				if old <> face/selected [
					do-face face none
					act-face face event 'on-key
				]
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
			; resizes the subface of the list
			resize-face*: func [face size x y] [
				;-- Resize main list face and subface
				resize;/no-show
					face/subface
					as-pair
						face/size/x
						face/subface/size/y
					face/subface/offset
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
			;-- Build subface from columns
			case [
				;-- Use subface directly and supply sorting and type information from columns
				all [subface columns] [
					; use columns for sorting and types and nothing else
					; this is applied to the ctx-list attached here
				]
				;-- Create new subface
				all [not subface columns] [
					subface: make block! 100
					foreach column columns [
						append subface map-type column/type
					]
				]
				;-- Create subface from data
				all [not subface not columns] [
					either block? data [
						unless empty? data [
							subface: make block! 100
							switch/default type?/word data/1 [
								object! [
									foreach item first data/1 [
										append subface map-type type? item
									]
								]
								block! [
									foreach item data/1 [
										append subface map-type type? item
									]
								]
							] [
								; assuming that all data are of the same type
								append subface map-type type? data/1
							]
						]
					][
						;-- Create empty single column list
						subface: [list-text-cell 100x20 spring [bottom] fill 1x0]
					]
				]
			]
			;if none? size [
			;	size: 300x200
			;	size/x: subface/size/x + first edge-size? self
			;] ; size is really set to 100x100
			; if size is set here, the subface will adhere to the size
			; if size is not set here, the subface will determine the size
			; still a problem, because we don't really determine the size from fill until the outer part has been aligned
			make-subface self any [subface attempt [second :action] [list-text-cell]] ; empty subface = infinite loop
			if none? size [
				size: 300x200
				size/x: subface/size/x + first edge-size? self
			]
			;-- Build column order
			unless block? column-order [
				column-order: make block! []
				repeat i length? subface/pane [
					append column-order to-word join 'column- i
				]
			]
			;-- Build columns from subface
			case [
				;-- Create column list from subface
				all [subface not columns] [
					columns: make block! []
					repeat i length? subface/pane [
						append columns to-word join 'column- i
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
				face/over: min max 1x1 face/over to-pair length? out
				follow face face/over/y
			]
			if find [#" " #"^M"] event/key [
				append clear face/selected face/over/y
			]
		]
	]

	; iterated bottom-up list with user defined subface. internal use only.
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
		pane:					; list and navigation faces here
		;-- List information
		data:					; data block to use as source, passed to LIST
		columns:				; column description, passed to LIST
		column-order:			; column order, passed to LIST
		subface:				; subface block or layout, passed to LIST
		text:					; does not contain focusable text
			none
		;-- Basic accessors
		access: make access [
			get-face*: func [face] [
				if face/list [get-face face/list]
			]
		]
	]

	; standard data list with list, header and user defined subface or column definition
	DATA-LIST: NAV-LIST with [ ; [!] - compound later
		;-- Faces
		header:					; header face
		v-scroller:				; vertical scroller face
		h-scroller:				; horizontal scroller face
			none
; [?] - do not allow focusing of individual items in list subface
; [ ] - inline field system
; [ ] - figure out why list subface content does not resize properly to the width of the outer faces immediately
; [ ] - align
		select-mode: 'multi
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
		]
		update: func [face] [
			face/list/update face/list
		]

		init: [
			;-- Build pane
			pane: layout/tight compose/deep/only [
				across space 0
;				header 200x20 return
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
;					on-click [act-face face/parent-face event 'on-click]
;					on-key [act-face face/parent-face event 'on-key]
					with [ ; size is ignored, because it's made inside list size
						subface: (subface)
						data: (data) ; make sure it's same
						columns: (columns) ; make sure it's same
						column-order: (column-order) ; make sure it's same
					]
			]
			reverse pane/pane
			set-parent-faces self
			any [size size: pane/size + any [all [object? edge 2 * edge/size] 0]]
			panes: reduce ['default pane: pane/pane]
			set [list v-scroller] pane
			selected: list/selected ; shared selection list
			list/select-mode: select-mode
			;-- Scroller setup
			access/set-scroller self
			;-- Build Header
			; not yet
		]
	]

	SORT-BUTTON: BUTTON
	SORT-RESET-BUTTON: SORT-BUTTON
	LIST-HEADER: LIST
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
		subface: [
			across space 1x1
			list-text-cell bold spring [bottom right] right 100 200.200.200
			list-text-cell 180 spring [bottom]
		]
	]

]

; Exported styles
iterated-face: get-style 'iterated-face