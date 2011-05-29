REBOL [
	Title: "Filtering Test"
	Short: "Filtering Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %filtering.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 28-May-2011
	Date: 28-May-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test filtering in DATA-LIST using QUERY-FACE.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 100 [append/only list-data array/initial 4 does [random "abcdef xyz nml"]]

filter-row: func [data /local value] [
	if empty? value: get-face f-filter [return true]
	foreach cell data [if find cell value [return true]]
	false
]

view make-window [
	h3 "Sorting Test"
	bar
	right-panel [
		across
		label "Filter:" f-filter: field on-key [query-face l-data :filter-row]
	]
	l-data: data-list data list-data
]