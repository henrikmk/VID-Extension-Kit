REBOL [
	Title: "Alternative Column Order Test 2"
	Short: "Alternative Column Order Test 2"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %column-order-2.r
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
		Tests for column ordering, while some columns are also hidden.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 100 [append/only list-data array/initial 4 does [random 100]]

view make-window [
	h3 "Test Alternative Column Order 2"
	bar
	l-data: data-list
	setup [
		input [a b c d]
		output [b c]
		names ["B" "C"]
		data list-data
	]
]