REBOL [
	Title: "Selection Test"
	Short: "Selection Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %selection.r
	Version: 0.0.2
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 29-May-2011
	Date: 30-Oct-2011
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
		"Selected:" length? any [get-select-face l-data []]
	]
]

view make-window [
	h3 "Selection Test"
	bar
	across
	panel fill 0x1 [
		l-data: data-list data list-data
			on-key [set-i-status]
			on-click [set-i-status]
			on-select [set-i-status]
			on-unselect [set-i-status]
			setup [select-mode 'mutex]
		i-status: info fill 1x0 spring [top]
	]
	right-panel [
		h-fill-button "Select All" [select-face l-data true]
		h-fill-button "Select None" [select-face l-data none]
		h-fill-button "Select Invert" [select-face l-data 'invert]
		h-fill-button "Select First" [select-face l-data 'first]
		h-fill-button "Select Next" [select-face l-data 'next]
		h-fill-button "Select Previous" [select-face l-data 'previous]
		h-fill-button "Select Last" [select-face l-data 'last]
		h-fill-button "Select > 90" [select-face l-data func [val] [any [val/1 > 90 val/2 > 90 val/3 > 90 val/4 > 90]]]
		h-fill-button "Select Row 3" [select-face l-data 3]
		h-fill-button "Select Row 6" [select-face l-data 6]
		h-fill-button "Select 4, 7" [select-face l-data [4 7]]
		h-fill-button "Unselect 4, 7" [unselect-face l-data [4 7]]
		bar
		h3 "Select Mode:"
		rs: radio-selector
			setup [mutex "Mutex" multi "Multi" persistent "Persistent"]
			[l-data/select-mode: l-data/list/select-mode: value select-face l-data none]
		do [set-face rs l-data/select-mode set-i-status]
	]
]
