REBOL [
	Title: "Caret List Test"
	Short: "Caret List Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %caret-list.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 29-May-2011
	Date: 29-May-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test CARET-LIST using its special keyboard navigation.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 100 [append/only list-data array/initial 4 does [random "abcdef xyz nml"]]

view make-window [
	h3 "CARET-LIST Test"
	bar
	l-data: caret-list 300x200 with [data: list-data columns: [a b c] sub-face: [across space 0 list-text-cell 100 list-text-cell 100 list-text-cell 100]]; columns: [a b c] column-order: [a b c]]
	field
]