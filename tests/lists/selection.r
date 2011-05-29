REBOL [
	Title: "Selection Test"
	Short: "Selection Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %selection.r
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
		Test selection in DATA-LIST.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 25 [append/only list-data array/initial 4 does [random 100]]

view make-window [
	h3 "Selection Test"
	bar
	across
	l-data: data-list data list-data on-key [probe value] on-click [probe value]
	right-panel [
		button "Select All" [l-data]
		button "Select None" [l-data]
	]
]