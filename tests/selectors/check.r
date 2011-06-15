REBOL [
	Title: "Check Mark Test"
	Short: "Check Mark Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %check.r
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
		Test of CHECK and its variants.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

view make-window [
	across
	panel [
		h3 "Non-Related"
		bar
		a: panel [
			check
			check
			check
		]
		button "Get Face" [probe get-face a]
		button "States" [traverse-face a [probe face/states]]
	]
	panel [
		h3 "Related"
		bar
		b: panel [
			check of 'selection
			check of 'selection
			check of 'selection
		]
		button "Get Face" [probe get-face b]
		button "States" [traverse-face b [probe face/states]]
	]
]
