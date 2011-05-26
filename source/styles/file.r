REBOL [
	Title: "Styles for File Management"
	Short: "Styles for File Management"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %file.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 22-Mar-2011
	Date: 22-Mar-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Styles for various file and directory management windows
	}
	History: []
	Keywords: []
]

stylize/master [

; choice with selection of paths from root to current directory
PATH-CHOICE: CHOICE ctx-colors/colors/action-color with [
	make-crumb: func [path /local blk root] [
		blk: make block! 100
		while [not root] [
			repend blk [form path path]
			root: path = %/
			path: first split-path path
		]
		reverse blk
	]
	access: make access [
		setup-face*: func [face value] [
			face/setup: make-crumb value
			face/data: back back tail copy face/setup
		]
		set-face*: func [face value /local blk] [
			value: attempt [clean-path to-file value]
			if file? value [
				unless dir? value [value: split-path value]
			]
			setup-face* face value
			if val: find/skip head face/data value 2 [
				face/data: val
				face/text: form select face/setup value
			]
		]
	]
	insert init [
		setup: clean-path any [data %./]
	]
]

]