REBOL [
	Title: "VID Extension Kit COLORS Core"
	Short: "VID Extension Kit COLORS Core"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %ctx-colors.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-May-2010
	Date: 09-May-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		COLORS context for color management for surfaces as well as color conversion functions.
	}
	History: []
	Keywords: []
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