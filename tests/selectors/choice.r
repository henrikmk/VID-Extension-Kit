REBOL [
	Title: "Choice Test"
	Short: "Choice Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %choice.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-Jun-2010
	Date: 26-Jun-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test of TOGGLE and its variants.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug
probe 's
view make-window [
	; [ ] - focus with keyboard input
	c: choice
	button "Focus?" [probe describe-face system/view/focal-face]
]
