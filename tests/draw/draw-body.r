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
	b: button with [states: [no-sort ascending descending]] [probe face/states]
	toggle "Disable" [either value [disable-face f][enable-face f]]
	toggle
	s: sort-button "a"
	a: text-area "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
	; [ ] - scroller does not clamp, after resizing, when it's scrolled to the end
	; [ ] - scroller does not allow clamping, when clicked
	; [ ] - scroller does not resize down after resizing up, when it has been scrolled to the end
	; [ ] - so when you scroll to the end, you need to do things to get it going
]

view m