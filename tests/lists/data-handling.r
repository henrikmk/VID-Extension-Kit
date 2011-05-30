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

; object for main data list
default-object: make object! [
	name:
	age:
	height:
	time:
		none
]

list-data: []

view make-window [
	h3 "Data Handling Test"
	bar
	panel [
		across
		l-data: data-list 500x400 data list-data setup [name age height time 200]
		right-panel [
			button "Add" [
				edit-face l-data 'add make default-object [
					name: random "abc"
					age: random 50
					height: random 100
					time: now/precise
				]
			]
			button "Remove" [
				either empty? l-data/selected [
					alert "No rows selected."
				][
					edit-face l-data 'delete none
				]
			]
			button "Update" [
				; should find a more elegant way to deal with this, which might be with objects
				edit-face l-data 'edit make default-object [time: now/precise]
			]
		]
	]
]