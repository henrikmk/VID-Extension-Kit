REBOL [
	Title: "Horizontal Scroll Panel Test"
	Short: "Horizontal Scroll Panel Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %h-scroll-panel.r
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
		Test basic H-SCROLL-PANEL.
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
	h3 "Horizontal Scroll Panel"
	bar
	panel [
		across
		s: h-scroll-panel 300x300 pane
	]
]