REBOL [
	Title: "VID Box"
	Short: "VID Box"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %box.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 19-Apr-2009
	Date: 19-Apr-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Various VID Boxes
	}
	History: []
	Keywords: []
]

stylize/master [
	BOX: IMAGE doc [info: "shortcut for image"]

	BAR: BLANK-FACE -1x3 fill 1x0 spring [bottom] with [
		edge: [size: 1x1 effect: 'bevel]
		doc: [
			info: "horizontal separator"
			integer: "width of bar"
			pair: "size of bar"
			tuple: "color of the bar"
		]
		init: [
			if data: color [edge: make edge [color: data + 20]]
			if negative? size/x [size/x: 200]
		]
	]

	; Fixed aspect box
	ASPECT-BOX: BOX with [fixed-aspect: true]

	; Dummy box for replacing fields or other user manipulated elements.
	; need tile effect here, possibly through DRAW
	DUMMY: BOX load-stock 'blocked 200x24 spring [bottom] with [
		access: make access [
			set-face*: func [face value] [value]
			get-face*: func [face] [none]
			clear-face*: func [face] []
		]
	]
]
