REBOL [
	Title: "Data Handling Test"
	Short: "Data Handling Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %data-handling.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-Jun-2010
	Date: 26-Jun-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test data handling in DATA-LIST using plain blocks and objects.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

; object for main data list
default-object: make object! [
	name:
	age:
	height:
	weight:
		none
]

view make-window [
	h3 "List Specs Test"
	bar
	l-data: data-list 424x400 setup default-object
]