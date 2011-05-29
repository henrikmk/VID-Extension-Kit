REBOL [
	Title: "One Column Test"
	Short: "One Column Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %one-column.r
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
		Test DATA-LIST with a single column.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: ["1" "2" "3"]

view make-window [
	h3 "Sorting Test"
	bar
	l-data: data-list data list-data setup [items]
]