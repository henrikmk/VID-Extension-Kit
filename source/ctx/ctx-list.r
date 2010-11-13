REBOL [
	Title: "List Context"
	Short: "List Context"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-ctx-list.r
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

; bound to places in the data-list and list-header

ctx-list: context [
	data*: fspec*: soc*: sod*: dfilt*: didx*: dsort*: dadis*: out*: none

	list-map: [data 0 filtered 0 sorted 0]

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
		didx*:	face/data-index			; source -> output map
		dfilt*:	face/data-filtered		; filtered data rows
		dsort*:	face/data-sorted		; sorted data
		soc*:	face/sort-column		; not usable
		sod*:	face/sort-direction		; not usable
		cor*:	face/column-order		; order and visibility of columns (block of words)
		dadis*:	face/data-display		; order of columns for display as indexes
		out*:	face/output				; data outputted to visible list
	]

	; filters source from the spec for the given list face
	set-filtered: func [face /local i j spec-func] [
		set-vars face
		clear dfilt*
		insert clear didx* array/initial length? data* list-map
		repeat i length? didx* [didx*/:i/data: i]
		either any [none? fspec* empty? fspec*] [
			insert dfilt* data*
		][
			spec-func:
				either object! = get-list-type [
					func [row] [do bind fspec* row]
				][
					func [row] any [fspec* [true]]
				]
			i: j: 0
			foreach row data* [
				i: i + 1
				if spec-func row [
					j: j + 1
					insert/only tail dfilt* row
					didx*/:i/filtered: j
				]
			]
		]
		set-sorting face
	]

	; sets the sorting for the given list face
	set-sorting: func [face /local op col] [
		set-vars face
		insert clear head dsort* dfilt*
		; somehow fit didx* in here
		; sorting appears to be lossy, so first we need to alter the sorting of the index block
		; so the sorting needs to occur in a way where the index is brought along
		if all [sod* soc*] [
			op: get select [asc lesser? desc greater?] sod*
			switch to-word get-list-type [
				object! [
					sort/compare dsort* func [a b] [op get in a soc* get in b soc*]
				]
				block! [
					col: index? find face/row soc*
					sort/compare dsort* func [a b] [op pick a col pick b col]
				]
			][
				either 'desc = sod* [sort/reverse dsort*][sort dsort*]
			]
		]
		set-columns face
	]

	; sets the indexes for the columns to be displayed in the list face in the correct order
	set-columns: func [face /local def] [
		set-vars face
		clear dadis*
		def: extract face/columns 2
		foreach idx face/column-order [
			append dadis* index? find def idx
		]
		set-output face
	]

	; sets the output data for display and for collection with GET-FACE
	set-output: func [face /local val] [
		set-vars face
		face/output: clear head face/output
		foreach row dsort* [
			insert/only tail face/output make block! length? dadis*
			foreach col dadis* [
				; append cell to row
				; so if there is only one column...?
				; output is used by didx* so we should use that as a pick index against data
				; perhaps we don't need to maintain the other indexes in order to do this
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
	get-cell: func [face row col /local r] [
		set-vars face
		either col <= length? dsort* [
			r: pick dsort* row
		][
			unset 'r
		]
		col: pick dadis* col
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
]