REBOL [
	Title: "Resize Window Test"
	Short: "Resize Window Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %window.r
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
		Test programmatic resize of window.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

lay: make-window [box "Box" 400x400 spring none edge [size: 2x2] red button fill 1x1 spring [top]]

view make-window [
	h3 "Resize Window Test"
	bar 300
	across
	button "Open" spring [bottom] [view/new center-face lay] text "(Do This First)" return
	button "Resize Bigger" [resize-face lay lay/size + 30x30]
	button "Resize Smaller" [resize-face lay lay/size - 30x30]
]