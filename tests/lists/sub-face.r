REBOL [
	Title: "SUB-FACE Test"
	Short: "SUB-FACE Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %sub-face.r
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
		Test SUB-FACE in DATA-LIST.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 100 [append/only list-data array/initial 3 does [random "abcdef xyz nml"]]

view make-window [
	h3 "SUB-FACE Test"
	bar
	l-data: data-list 300x400 data list-data setup [
		header-face [across button "Values" fill 1x0 spring [bottom]]
		sub-face [
			across space 0
			list-text-cell 300 font-size 16 bold spring [bottom] return
			list-text-cell 150 font-size 11 60.60.60 spring [bottom]
			list-text-cell 150 font-size 11 right spring [left bottom]
		]
	]
]