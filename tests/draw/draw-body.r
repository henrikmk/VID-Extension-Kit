REBOL [
	Title: "DRAW-BODY Test"
	Short: "DRAW-BODY Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %draw-body.r
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
		Test the DRAW-BODY context with a derivative BUTTON
	}
	History: []
	Keywords: []
]

; arrow-down problem here

do %../../build/include.r

insert clear ctx-vid-debug/debug 'draw-body

m: make-window [
	b1: button "Button Test 1"
	b2: button "Button Test 2"
	b3: button "Button Test 3"
	t1: toggle "Toggle Test 1"
	t2: toggle "Toggle Test 2"
	t3: toggle "Toggle Test 3"
	check
]

view m