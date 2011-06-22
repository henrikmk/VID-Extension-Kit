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

set-i-status: does [
	set-face i-status reform [
		"Total:" length? l-data/data
		"Selected:" length? any [get-face l-data []]
	]
]

view make-window [
	h3 "Selection Test"
	bar
	across
	panel [
		l-data: data-list data list-data
			on-key [set-i-status]
			on-click [set-i-status]
			on-select [set-i-status]
			setup [select-mode 'mutex]
		i-status: info fill 1x0 spring [top]
	]
	right-panel [
		button "Select All" [select-face l-data true]
		button "Select None" [select-face l-data none]
		button "Select First" [select-face l-data 'first]
		button "Select Last" [select-face l-data 'last]
		button "Select > 90" [select-face l-data func [val] [any [val/1 > 90 val/2 > 90 val/3 > 90 val/4 > 90]]]
		bar
		h3 "Select Mode:"
		rs: radio-selector
			setup [mutex "Mutex" multi "Multi" persistent "Persistent"]
			[l-data/select-mode: l-data/list/select-mode: value select-face l-data none]
		do [set-face rs l-data/select-mode set-i-status]
	]
]