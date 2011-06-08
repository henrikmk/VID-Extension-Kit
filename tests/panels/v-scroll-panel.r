REBOL [
	Title: "Vertical Scroll Panel Test"
	Short: "Vertical Scroll Panel Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %v-scroll-panel.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 06-Jun-2011
	Date: 06-Jun-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test basic V-SCROLL-PANEL.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

img: draw make image! 400x400 [pen black fill-pen red circle 200x200]

pane: [
	image img
]

view make-window [
	h3 "Vertical Scroll Panel"
	bar
	panel [
		across
		s: v-scroll-panel 300x300 pane
	]
]