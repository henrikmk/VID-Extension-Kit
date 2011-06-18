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

clear ctx-vid-debug/debug

inform make-window [
	h3 "Popup Face Test with Hinge"
	bar 300
	f1: button "Field" on-click [
		show-menu-face face [origin 4 space 0 field button "..."]
	]
	date1: date-time-field
	b1: button "Over There ->" 300 on-click [
		show-menu-face/hinge
			face
			[
				date-month
					on-click [
						set-face d1 get-face face
						hide-menu-face face
					]
			]
			[top right]
			[top left]
	]
	d1: info
]