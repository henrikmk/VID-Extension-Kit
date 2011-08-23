REBOL [
	Title: "Popup Face Test"
	Short: "Popup Face Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %popup.r
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
	h3 "Popup Face Test"
	bar 300
	button on-click [show-menu-face face [data-list 200x200 data [1 2 3]]]
]