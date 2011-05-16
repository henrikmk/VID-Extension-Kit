REBOL [
	Title: "VID Construct"
	Short: "VID Construct"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2008 - HMK Design"
	Filename: %construct.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 23-Dec-2008
	Date: 23-Dec-2008
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Used to build complex faces using user defined data.
	}
	History: []
	Keywords: []
]

stylize/master [
	; constructs complex faces from user setup
	; USAGE: Create the layout using DO-SETUP and run DO-SETUP using SETUP-FACE with a content argument.
	;        Set the content as normally using SET-FACE.
	FACE-CONSTRUCT: FACE with [
		size: 60x60
		emit: func [data] [insert tail lo data]
		text: none
		lo: make block! 1000	; internal layout block
		do-setup: none			; user defined process to build the layout
		access: ctx-access/face-construct
		init: [
			if setup [
				access/setup-face* self setup
			]
		]
	]

]