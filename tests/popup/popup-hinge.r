REBOL [
	Title: "Popup Face Test with Hinge"
	Short: "Popup Face Test with Hinge"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %popup-hinge.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 15-Jun-2011
	Date: 15-Jun-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test the use of popup with the /hinge refinement.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

insert insert insert clear ctx-vid-debug/debug 'face 'resize 'align

view make-window [
	h3 "Popup Face Test with Hinge"
	bar 300
	button 300 on-click [
		show-menu-face/hinge
			face
			[data-list 200x200 data [1 2 3]]
			[bottom right]
			[top right]
	]
]