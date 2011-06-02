REBOL [
	Title: "Rendering Test"
	Short: "Rendering Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %filtering.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Jun-2011
	Date: 02-Jun-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test custom cell rendering in DATA-LIST using RENDER with CELL/NAME.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []

prototype: make object! [name: age: height: none]

loop 100 [
	append/only list-data make prototype [
		name: random "asd xyz"
		age: random 100
		height: random 50
	]
]

view make-window [
	h3 "Rendering Test 2"
	bar
	l-data: data-list data list-data setup [
		input prototype
		names ["Name" "Age (> 50 = bold)" "Height"]
		widths [100 150 100]
		render [
			cell/color: pick [240.240.240 230.230.230] even? cell/pos/y
			switch cell/name [
				age [
					cell/font/style: if all [cell/data cell/data > 50] ['bold]
				]
				height [
					cell/effect: all [cell/data compose/deep [draw [pen none fill-pen red box 0x0 (as-pair cell/data 20)]]]
				]
			]
		]
	]
]