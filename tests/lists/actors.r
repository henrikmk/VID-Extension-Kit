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

insert clear ctx-vid-debug/debug 'actor

list-data: []
loop 100 [append/only list-data array/initial 3 does [random "abcdef xyz nml"]]

view make-window [
	h3 "Actors Test"
	bar
	l-data: data-list 300x400 data list-data
		on-key []
		on-click []
;		on-double-click []
		on-resize []
		on-align []
]