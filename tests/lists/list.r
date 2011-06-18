REBOL [
	Title: "LIST Test"
	Short: "LIST Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %list.r
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
		Test bare LIST with basic requirements.
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
	l-data: list 450x200 with [
		data: list-data
		columns: [a b c]
		sub-face: [across space 0 list-text-cell 150 pad 1x0 list-text-cell 150 list-text-cell 150 spring [bottom]]
	]
]