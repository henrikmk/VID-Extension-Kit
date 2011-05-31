REBOL [
	Title: "Column Mode Test"
	Short: "Column Mode Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %column-mode.r
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
		Test column modes in DATA-LIST.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 100 [append/only list-data array/initial 4 does [random "abcdef xyz nml"]]

view make-window [
	h3 "SUB-FACE Test"
	bar
	l-data: data-list data list-data setup [input [a b c d] modes [no-sort sort filter sort]]
]