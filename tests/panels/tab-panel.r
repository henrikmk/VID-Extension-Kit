REBOL [
	Title: "Tab Panel Test"
	Short: "Tab Panel Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %tab-panel.r
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
		Test TAB-PANEL.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

view make-window [
	h3 "TAB-PANEL Test"
	bar
	tab-panel setup [
		tab1 "Tab 1" [origin 4 text-area fill 1x1]
		tab2 "Tab 2" [origin 4 data-list fill 1x1]
	]
]