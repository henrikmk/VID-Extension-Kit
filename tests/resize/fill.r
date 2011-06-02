REBOL [
	Title: "Resize Test"
	Short: "Resize Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %resize.r
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
		Test resize.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

insert insert insert clear ctx-vid-debug/debug 'face 'resize 'align

view make-window [
	h3 "Resize Test"
	bar 300
	panel red fill 1x0 [
		; this button cannot resize beyond the intended size,
		; because the difference between the default size and the fill for panel
		; is not registered. if it were, the size would change beyond the default
		; but this may pose a problem for unintended resizes, as the user cannot
		; know what the default size of a face is
		; therefore the result is correct and we may not provide a fill for the panel
		button spring [bottom]
	]
]