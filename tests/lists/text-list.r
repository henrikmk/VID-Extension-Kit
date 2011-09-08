REBOL [
	Title: "Text List Test"
	Short: "Text List Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %text-list.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 28-May-2011
	Date: 28-May-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test TEXT-LIST, which is a 1-dimensional DATA-LIST derivative without a header.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: ["aaa" "bbb" "ccc"]
print ""

view make-window [
	h3 "Text List Test"
	bar
	l-data: text-list data list-data [probe get-face face]
]