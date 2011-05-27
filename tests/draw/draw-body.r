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

;insert clear ctx-vid-debug/debug 'draw-body

m: make-window [
;	f: dummy ; shows binding issue
	button
	toggle "Disable" [either value [disable-face f][enable-face f]]
	f: form-text
	ff: field
	scroller
]

view m