REBOL [
	Title: "SETUP-FACE Test"
	Short: "SETUP-FACE Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %setup-face.r
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
		Test SETUP-FACE in DATA-LIST.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

;insert insert insert clear ctx-vid-debug/debug 'align 'face 'resize

list-data: []
loop 100 [append/only list-data array/initial 3 does [random "abcdef xyz nml"]]

view make-window [
	h3 "SETUP-FACE Test"
	bar
	l-data: data-list 300x200 fill 1x0 data list-data
	bottom-panel [
		across
		button "Setup 1" [
			setup-face l-data [
				header-face [across button "Values" fill 1x0 spring [bottom]]
				sub-face [
					across space 0
					list-text-cell 300 font-size 16 bold spring [bottom] return
					list-text-cell 150 font-size 11 60.60.60 spring [bottom]
					list-text-cell 150 font-size 11 right spring [left bottom]
				]
			]
		]
		button "Setup 2" [
			setup-face l-data [input [a b c] select-mode 'mutex]
		]
		button "Setup 3" [
			setup-face l-data [input [a b c d] output [a] select-mode 'persistent]
		]
		button "No Setup" [
			setup-face l-data none
		]
	]
]