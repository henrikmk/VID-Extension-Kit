REBOL [
	Title: "SET-FACE and GET-FACE Test"
	Short: "SET-FACE and GET-FACE Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %set-get.r
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
		Test SET-FACE and GET-FACE in DATA-LIST.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list1: copy list2: []

loop 50 [append/only list1 array/initial 4 does [random "abcdef xyz nml"]] ; Chars
loop 100 [append/only list2 array/initial 4 does [random 100]] ; Numbers

view make-window [
	h3 "SET-FACE/GET-FACE Test"
	bar
	l-data: data-list setup [a b c d]
	across
	button "Chars" [set-face l-data list1]
	button "Numbers" [set-face l-data list2]
	button "GET-FACE" [probe get-face l-data]
]