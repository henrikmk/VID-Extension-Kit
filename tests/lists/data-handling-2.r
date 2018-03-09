REBOL [
	Title: "Data Handling Test"
	Short: "Data Handling Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011-2018 - HMK Design"
	Filename: %data-handling.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-Mar-2018
	Date: 09-Mar-2018
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test EDIT-FACE with multiple rows, copying and moving data between lists.
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
	time:
		none
]

list-data-1: []
list-data-2: []

loop 10 [
	insert
		tail
			list-data-1
		make default-object [
			name: random "abc"
			age: random 50
			height: random 100
			time: random now/precise
		]
]

view make-window [
	h3 "Copy and Move Data Between Lists"
	bar
	panel [
		across
		l-data-1: data-list 500x400 data list-data-1 spring [right] setup [
			input default-object widths [100 100 100 200]
		]
		l-data-2: data-list 500x400 data list-data-2 setup [
			input default-object widths [100 100 100 200]
		]
		right-panel [
			button "Move Right" [
				edit-face l-data-2 'add get-face l-data-1 none none
				edit-face l-data-1 'delete none none none none
			]
			button "Move Left" [
				edit-face l-data-1 'add get-face l-data-2 none none
				edit-face l-data-2 'delete none none none none
			]
			button "Copy Right" [
				edit-face l-data-2 'add get-face l-data-1 none none
			]
			button "Copy Left" [
				edit-face l-data-1 'add get-face l-data-2 none none
			]
		]
	]
]