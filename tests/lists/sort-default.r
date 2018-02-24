REBOL [
	Title: "Default Sorting Test"
	Short: "Default Sorting Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2018 - HMK Design"
	Filename: %sort-default.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 24-Feb-2018
	Date: 24-Feb-2018
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test resetting sorting in DATA-LIST to configurable column and direction.
		Should also configure and apply sorting on SETUP-FACE.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 25 [append/only list-data array/initial 4 does [random 100]]

view make-window [
	h3 "Default Sorting Test"
	bar
	l-data: data-list data list-data setup [
		default-sort-column 'column-2
		default-sort-direction 'descending
	]
	bottom-panel [
		across
		button "Standard" [
			setup-face l-data [
				default-sort-column none
				default-sort-direction none
			]
		]
		button "Default Sort 1" [
			setup-face l-data [
				default-sort-column 'column-2
				default-sort-direction 'descending
			]
		]
		button "Default Sort 2" [
			setup-face l-data [
				default-sort-column 'column-1
				default-sort-direction 'ascending
			]
		]
		button "Default Sort 3" [
			setup-face l-data [
				default-sort-column 'column-4
				default-sort-direction 'descending
			]
		]
	]
]
