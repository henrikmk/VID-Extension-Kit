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
	Created: 29-May-2011
	Date: 29-May-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test custom cell rendering in DATA-LIST using RENDER-FUNC.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []
loop 100 [append/only list-data array/initial 4 does [random 100]]

view make-window [
	h3 "Rendering Test"
	bar
	l-data: data-list data list-data with [
		render-func: func [face cell] [
			switch cell/pos/x [
				1 [cell/color: random 255.255.255]
				2 [cell/color: white cell/font/style: if all [cell/data 50 < cell/data] ['bold]]
				3 [cell/color: white * (cell/pos/y / length? face/data)]
			]
		]
	]
]