REBOL [
	Title: "List Context"
	Short: "List Context"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %ctx-list.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 15-Jul-2009
	Date: 15-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Context for list views for sorting,
		filtering and management of column display for list data.
	}
	History: []
	Keywords: []
]

; bound to places in the data-list

ctx-list: context [

	;-- List Specifications

	; object for list column specification
	spec-object: make object! [
		word: 'default
		name: "Untitled"
		adjust: 'left
		type: string!
		width: 100
		hidden: false
		tool-tip: none
	]

	; creates a specification block from a dialect or an object
	make-list-spec: func [face data /local i] [
		clear face/specs
		clear face/columns
		if object? data [data: words-of data]
		i: 0
		parse data [
			any [
				(i: i + 1)
				set word word!
				set name opt string!
				set adjust opt ['left | 'right | 'center]
				set width opt integer!
				set type opt datatype!
				set hidden opt 'hidden
				set resizable opt 'resizable
				(
					append face/specs make-spec-object word name adjust width type hidden
					append face/columns word
					append face/columns none ; what is this supposed to be?
					any [hidden append face/column-order word]
					if resizable [face/resize-column: i]
				)
			]
		]
	]

	; creates a single specification object
	make-spec-object: func [word' name' adjust' width' type' hidden'] [
		make spec-object [
			word: word'
			name: any [name' uppercase/part form word 1]
			adjust: any [adjust' 'left]
			width: any [width' 100]
			type: to-datatype any [type' string!]
			hidden: any [to logic! hidden' false]
		]
	]

	; creates a list object, if none is defined
	make-list-object: func [face /local i sample] [
		if block? face/data [
			either empty? face/data [
				make object! [column-1: none]
			] [
				sample: face/data/1
				case [
					object? sample [
						make object! sample
						set sample none
						sample
					]
					block? sample [
						i: 0
						sample: array/initial length? face/data/1 does [i: i + 1 to-set-word rejoin ['column- i]]
						append sample none
						make object! sample
					]
				]
			]
		]
	]

	;-- Functions to Apply Specification to List

	; function to generate header face from specs
	make-header-face: func [face /local i] [
		face/header-face: if face/specs [copy [across space 0]]
		any [face/header-face exit]
		i: 0
		foreach spec face/specs [
			i: i + 1
			; Column Sort Button
			repend face/header-face [
				'sort-button
				spec/name
				spec/width
				'spring
				case [
					i < face/resize-column [[bottom right]]
					i = face/resize-column [[bottom]]
					i > face/resize-column [[left bottom]]
				]
				'sort-column
				to-lit-word spec/word
				'of
				to-lit-word 'sorting
			]
			; Resizer
			; this will only work when the list does not have a single adjustable column
			;if all [i < length? face/specs] [
			;	repend face/header-face [
			;		; [!] - second resizer does not move properly when resizing window
			;		'resizer 6x24
			;		'spring
			;		either i = 1 [[bottom right]][[bottom left]]
			;	]
			;]
		]
		append face/header-face [sort-reset-button spring [bottom left]]
	]

	; generate sub-face from specs
	make-sub-face: func [face /local i] [
		either face/specs [
			face/sub-face: copy [across space 0]
		][
			exit
		]
		i: 0
		foreach spec face/specs [
			i: i + 1
			repend face/sub-face [
				switch/default to-word spec/type [
					image! ['list-image-cell]
				][
					'list-text-cell
				]
				spec/adjust
				spec/width
				'spring
				case [
					i < face/resize-column [[bottom right]]
					i = face/resize-column [[bottom]]
					i > face/resize-column [[left bottom]]
				]
			]
		]
	]

	;-- Sorting, Filtering and Display

	data*: fspec*: soc*: sod*: fidx*: sidx*: dadis*: out*: none

	; returns the type of the list data, either as an object if empty or the type of the first entry
	get-list-type: does [
		if empty? data* [return object!]
		if first data* [return type? first data*]
	]

	; returns the length of the filtered data
	get-count: func [face] [
		length? face/data-filtered
	]

	; sets context variables (internal)
	set-vars: func [face] [
		data*:	face/data				; original data block
		fspec*:	face/filter-spec		; filter specification
		fidx*:	face/data-filtered		; filtering -> source map
		sidx*:	face/data-sorted		; sorting -> source map
		soc*:	face/sort-column		; sorted column as word
		sod*:	face/sort-direction		; not usable
		cols*:	face/columns			; names of columns (block of words)
		cor*:	face/column-order		; order and visibility of columns (block of words)
		dadis*:	face/data-display		; order of columns for display as indexes
		out*:	face/output				; data outputted to visible list
	]

	; filters source from the spec for the given list face
	set-filtered: func [face /local i j spec-func] [
		set-vars face
		clear fidx*
		either any [none? fspec* empty? fspec*] [
			repeat i length? data* [insert tail fidx* i]
		][
			spec-func:
				either object! = get-list-type [
					func [row] [do bind fspec* row]
				][
					func [row] any [fspec* [true]]
				]
			i: 0
			repeat i length? data* [
				if spec-func data*/:i [insert tail fidx* i]
			]
		]
		set-sorting face
	]

	; sets the sorting for the given list face
	set-sorting: func [face /local op col idx] [
		set-vars face
		insert clear sidx* fidx*
		if all [sod* soc*] [
			op: get select [ascending lesser? asc lesser? descending greater? desc greater?] sod*
			switch to word! get-list-type [
				object! [
					sort/compare sidx* func [x y] [op get in a soc* get in b soc*] ; [!] - incorrect source
				]
				block! [
					col: index? find extract cols* 2 soc*
					sort/compare sidx* func [x y] [op pick pick data* x col pick pick data* y col]
				]
			][
				sort/compare sidx* func [x y] [op pick data* x pick data* y]
				if find [desc descending] sod* [reverse sidx*]
			]
		]
		set-columns face
	]

	; sets the indexes for the columns to be displayed in the list face in the correct order
	set-columns: func [face /local def] [
		set-vars face
		clear dadis*
		def: extract cols* 2
		foreach idx cor* [
			append dadis* index? find def idx
		]
		set-output face
	]

	; sets the output data for display and for collection with GET-FACE
	set-output: func [face /local length pos row val] [
		set-vars face
		face/output: clear head face/output
		foreach idx sidx* [
			row: pick data* idx
			insert/only tail face/output make block! length? dadis*
			foreach col dadis* [
				set/any 'val either block? row [pick row col][row]
				insert tail last face/output
					case [
						not value? 'val [
							copy ""
						]
						object? val [
							form get in val pick next first val col
						]
						any-block? val [
							form pick val col
						]
						true [
							form val
						]
					]
			]
		]
	]

	; returns the contents of a single cell according to filtered and sorted data
	get-cell: func [face phys-row col /local val] [
		set-vars face
		either col <= length? sidx* [
			val: pick data* pick sidx* phys-row
		][
			unset 'val
		]
		col: pick dadis* col
		case [
			not value? 'val [
				copy ""
			]
			object? val [
				form get in val pick next first val col
			]
			any-block? val [
				form pick val col
			]
			true [
				val ; not form?
			]
		]
	]
	
	; functions for articulate ways of configuring a list face
	; [ ] - complete articulation of base list:
	;       [x] - creation of header-face
	;       [ ] - display sorting in header
	;       [ ] - creation of list-face
	;       [ ] - display filtering of rows
	;       [ ] - display of sorting of rows
	;       [ ] - set of scrolling
	;       [ ] - setting of column widths
	; [o] - apply specs to data-list:
	;       [x] - build header-face
	;       [x] - build list-row-face
	;       [o] - use SETUP to apply specs with DATA-LIST. find anything that collides here.
	;       [o] - free articulation between using setup or *-face appliance in WITH
	; [ ] - apply specs directly to list only:
	;       [o] - build list-row-face
	; [ ] - need to set default object
	; [ ] - need to set specs for columns
	; [x] - require specs block
	;       [x] - generate list columns and column header from specs block
	; [ ] - manipulate articulation of list through these functions
	; [ ] - investigate specs dialect to generate specs object block, using a specs parser
]