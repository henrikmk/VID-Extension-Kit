REBOL [
	Title: "Follow Size Test"
	Short: "Follow Size Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %follow-size.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Nov-2011
	Date: 02-Nov-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test FOLLOW-SIZE in DATA-LIST.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 25 [append/only list-data array/initial 4 does [random 100]]

view make-window [
	h3 "Follow Size Test"
	bar
	text "Move up and down with cursor keys to test" fill 1x0
	l-data: data-list data list-data setup [follow-size 'page]
	across
	s-follow: selector ; selector has no on-select or on-click actor
		setup [line "By Line" page "By Page"]
		spring [top right]
		[setup-face l-data reduce ['follow-size to-lit-word value]]
	arrow 24x24 up [select-face l-data 'previous]
	arrow 24x24 down [select-face l-data 'next]
	do [set-face s-follow 'page]
]