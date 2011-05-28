REBOL [
	Title: "Specs Object Test"
	Short: "Specs Object Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %specs-object.r
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
		Test minimal setup in DATA-LIST using a single object.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

obj: make object! [
	name:
	age:
	height:
	weight:
		none
]

list-data: []

append list-data make obj [
	name: "Luke Skyswimmer"
	age: 19
	height: 174
	weight: 72
]

append list-data make obj [
	name: "Darth Vader"
	age: 40
	height: 206
	weight: 120
]

view make-window [
	h3 "List Specs Test"
	bar
	l-data: data-list 424x400 setup obj data list-data on-click [probe get-face face]
]