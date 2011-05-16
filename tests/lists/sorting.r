REBOL [
	Title: "Sorting Test"
	Short: "Sorting Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %sorting.r
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
		Test sorting in DATA-LIST with a header-face.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

data: [[1 2 3][a b c][4 5 6][d e f]]

view make-window [
	h3 "Sorting Test"
	bar
	; sorting buttons here for testing sorting
	; name of header in header-face
	data-list 424x400 with [
		data: [[1 2 3][a b c][4 5 6][d e f]]
		header-face: [
			across space 0
			; [ ] - add column word to sort
			; [ ] - by default it sorts by its own index
			sort-button "Name" 100 spring [bottom right]
			sort-button "Age" 200 spring [bottom]
			sort-button "Weight" 100 spring [left bottom]
		]
		sub-face: [
			across space 0
			list-text-cell 100 spring [bottom right]
			list-text-cell 200 spring [bottom]
			list-text-cell 100 spring [left bottom]
		]
	]
]