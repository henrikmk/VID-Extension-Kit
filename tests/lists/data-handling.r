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
	Created: 28-May-2011
	Date: 28-May-2011
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

data: [[1 2 3][a b c][4 5 6][d e f]]

; object for main data list
default-object: make object! [
	name:
	age:
	height:
		none
]

specs: make-window [
	h3 "Data Table Specifications"
	bar
	panel [
		across
		l-columns: data-list spring [right]
		l-specs: parameter-list
		right-panel [
			button "Add" [
				l-specs
			]
			button "Remove" [
				l-specs
			]
			button "Edit" [
				l-specs
			]
		]
	]
]

list: []

main: make-window [
	h3 "Data Handling Test"
	bar
	panel [
		across
		l-data: data-list 424x400 setup default-object with [
			data: :list
		]
		right-panel [
			highlight-button "Object Specs" [
				view/new specs
			]
			bar
			button "Add" [
				append list make default-object []
				show l-data
			]
			button "Remove" [
				remove
				show l-data
			]
			button "Update" [
				make default-object []
				show l-data 
			]
		]
	]
]

view main