REBOL [
	Title: "Alternative Column Order Test"
	Short: "Alternative Column Order Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %column-order.r
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
		Test alternative column order in DATA-LIST.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 100 [append/only list-data array/initial 4 does [random "abcdef xyz nml"]]

view make-window [
	h3 "Test Alternative Column Order"
	bar
	l-data: data-list data list-data setup [input [a b c d] output [d c b a]]
]
