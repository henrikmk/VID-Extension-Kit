REBOL [
	Title:  "REBOL/View: Color Management Core"
	Author: "Henrik Mikael Kristensen"
	Rights: "Copyright 2000 REBOL Technologies. All rights reserved."
	Note:   {Improvements to this code are welcome, but all changes preserve the above copyright.}
	Purpose: {
		Functions for color management
	}
	; You are free to use, modify, and distribute this software with any
	; REBOL Technologies products as long as the above header, copyright,
	; and this comment remain intact. This software is provided "as is"
	; and without warranties of any kind. In no event shall the owners or
	; contributors be liable for any damages of any kind, even if advised
	; of the possibility of such damage. See license for more information.

	; Please help us to improve this software by contributing changes and
	; fixes via http://www.rebol.com/feedback.html - Thanks!

	; Changes in this file are contributed by Henrik Mikael Kristensen.
	; Changes and fixes to this file can be contributed to Github at:
	; https://github.com/henrikmk/VID-Extension-Kit
]

ctx-colors: context [

; Skin color object
colors: none

; interpolate between two colors
set 'interpolate func [color1 color2 length /local step] [
	blk: make block! length
	color1: color1 + 0.0.0.0
	color2: color2 + 0.0.0.0
	diff: reduce [
		color2/1 - color1/1
		color2/2 - color1/2
		color2/3 - color1/3
		color2/4 - color1/4
	]
	append blk color1
	; linear interpolate between colors
	; negative is showing the diff properly
	length: length - 1
	repeat i length - 1 [
		append blk to-tuple reduce [
			to-integer diff/1 / length * i + color1/1
			to-integer diff/2 / length * i + color1/2
			to-integer diff/3 / length * i + color1/3
			to-integer diff/4 / length * i + color1/4
		]
	]
	append blk color2
]

; set saturation level for an RGB color
set 'saturate func [rgb level /local hsv] [
	hsv: rgb-to-hsv rgb
	hsv/2: level
	hsv-to-rgb hsv
]

]