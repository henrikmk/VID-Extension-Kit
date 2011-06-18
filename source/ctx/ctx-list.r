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

	; creates a list object from a number of columns
	make-list-object: func [size /words words-list /local i sample] [
		i: 0
		sample: array/initial
			size
			does [
				i: i + 1
				to-set-word either words [words-list/:i][join 'column- i]
			]
		append sample none
		make object! sample
	]

	;-- Functions to Apply Specification to List

	; function to generate header face from specs
	make-header-face: func [face /local i resize? resize-column w] [
		face/header-face: copy [across space 0]
		i: 0
		resize-column: find face/column-order face/resize-column
		resize-column: either resize-column [index? resize-column][1]
		resize?: false
		parse face/output [
			any [
				;-- Spacer
				'| (append face/header-face [pad 1x0])
				;-- Resizer
				| '|| (append face/header-face [resizer] resize=: true)
				;-- Column Header
				| set w word! (
					i: i + 1
					; Column Button Type
					append face/header-face
						switch face/modes/:i [
							sort ['sort-button]
							no-sort [[sort-button with [feel: none]]] ; static frame here
							filter ['filter-button]
						]
					; Column Button Arguments
					repend face/header-face [
						face/names/:i
						face/widths/:i
						'spring
						case [
							resize? [[bottom right]]
							i < resize-column [[bottom right]]
							i = resize-column [[bottom]]
							i > resize-column [[bottom left]]
						]
						'sort-column
						to-lit-word w
						'of
						to-lit-word 'sorting
					]
				)
			]
		]
		append face/header-face [sort-reset-button spring [bottom left]]
	]

	; generate sub-face from specs
	make-sub-face: func [face /local i resize? resize-column] [
		face/sub-face: copy [across space 0]
		i: 0
		resize-column: find face/column-order face/resize-column
		resize-column: either resize-column [index? resize-column][1]
		resize?: false
		parse face/output [
			any [
				;-- Spacer
				'| (append face/sub-face [pad 1x0])
				;-- Column Content
				| word! (
					i: i + 1
					repend face/sub-face [
						switch/default to-word face/types/:i [
							image! ['list-image-cell]
						][
							'list-text-cell
						]
						face/adjust/:i
						face/widths/:i
						'spring
						case [
							resize? [[bottom right]]
							i < resize-column [[bottom right]]
							i = resize-column [[bottom]]
							i > resize-column [[bottom left]]
						]
					]
				)
			]
		]
	]

	;-- Sorting, Filtering and Display

	data*: ffunc*: soc*: sod*: fidx*: sidx*: dadis*: out*: none

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
		data*:	face/data					; original data block
		ffunc*:	get in face 'filter-func	; filter function
		fidx*:	face/data-filtered			; filtering -> source map
		sidx*:	face/data-sorted			; sorting -> source map
		soc*:	face/sort-column			; sorted column as word
		sod*:	face/sort-direction			; not usable
		cols*:	face/columns				; names of columns (block of words)
		cor*:	face/column-order			; order and visibility of columns (block of words)
		dadis*:	face/data-display			; order of columns for display as indexes
		out*:	face/output					; data outputted to visible list
	]

	; filters source from the spec for the given list face
	set-filtered: func [face /local i j spec-func] [
		set-vars face
		clear fidx*
		repeat i length? data*
			either any-function? :ffunc* [
				[if ffunc* data*/:i [insert tail fidx* i]]
			][
				[insert tail fidx* i]
			]
		set-sorting face
	]

	; sets the sorting for the given list face
	set-sorting: func [face /local col values obtain] [
		set-vars face
		insert clear sidx*
			either all [sod* soc*] [
				values: clear []
				col: index? find cor* soc*
				obtain: func [row]
					case [
						object? data*/1 [[get in row soc*]]
						block? data*/1 [[pick row col]]
						true [[:row]]
					]
				foreach id fidx* [
					insert insert/only tail values obtain pick data* id id
				]
				either find [ascending asc] sod* [sort/skip values 2][sort/skip/reverse values 2]
				extract/index values 2 2
			][
				fidx*
			]
		set-columns face
	]

	; sets the indexes for the columns to be displayed in the list face in the correct order
	set-columns: func [face /local def] [
		set-vars face
		clear dadis*
		def: cols*
		foreach idx cor* [
			append dadis* index? find def idx
		]
		set-output face
	]

	; sets the output data index for display and for collection with GET-FACE
	set-output: func [face /local length pos row val] [
		set-vars face
		face/output: clear head face/output
		foreach idx sidx* [
			row: pick data* idx
			insert/only tail face/output make block! length? dadis*
			foreach col dadis* [
				set/any 'val either block? row [pick row col][row]
				insert/only tail last face/output
					case [
						not value? 'val [
							copy ""
						]
						object? val [
							get in val pick next first val col
						]
						any-block? val [
							pick val col
						]
						true [
							val
						]
					]
			]
		]
	]

	;-- Input Data Conversion

	; object to data
	object-to-data: func [obj] [
		values: make block! length? words-of obj
		foreach [word value] body-of obj [
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
		values
	]
]