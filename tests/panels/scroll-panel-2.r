REBOL [
	Title: "Scroll Panel Test 2"
	Short: "Scroll Panel Test 2"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2012 - HMK Design"
	Filename: %scroll-panel-2.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 27-Dec-2012
	Date: 27-Dec-2012
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test basic SCROLL-PANEL with SETUP-FACE.
		Using different sizes of panes to test redraw, resize, etc.
		Starts with an empty panel, to allow user initialization.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

img: draw make image! 400x400 [pen black fill-pen red circle 200x200]

setup-1: [
	default [button "Test"]
]

setup-2: [
	default [image img]
]

view make-window [
	h3 "Scroll Panel"
	bar
	across
	panel [
		button "Panel 1" [
			setup-face s setup-1
			s/set-panel-pane s 'default
		]
		button "Panel 2" [
			setup-face s setup-2
		]
	]
	right-panel [
		s: scroll-panel 300x300
	]
]