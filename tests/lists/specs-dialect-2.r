REBOL [
	Title: "List Specs Dialect Test"
	Short: "List Specs Dialect Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %specs-dialect.r
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
		Test specification dialect in DATA-LIST using words.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

in-obj: make object! [a: b: c: none]

view make-window [
	h3 "List Specs Test"
	bar
	l-data: data-list 624x400 setup [input in-obj]
]