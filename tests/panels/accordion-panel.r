REBOL [
	Title: "Accordion Panel Test"
	Short: "Accordion Panel Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %fold-panel.r
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
		Test basic ACCORDION.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

view make-window [
	h3 "ACCORDION Panel"
	bar
	a: accordion 300x300 setup [
		page1 "Page 1" [
			field
		]
		page2 "Page 2" [
			button
		]
		page3 "Page 3" [ ; this panel does not resize or show properly
			image help.gif
		]
	]
]