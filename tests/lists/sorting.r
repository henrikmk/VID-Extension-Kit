REBOL [
	Title: "Sorting Test"
	Short: "Sorting Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %sorting.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-Jun-2010
	Date: 26-Jun-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test sorting in DATA-LIST with a header-face.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: [[1 2 3]["a" "b" "c"][4 5 6]["d" "e" "f"]["g" 8 "h"]]

view make-window [
	h3 "Sorting Test"
	bar
	l-data: data-list data list-data
]