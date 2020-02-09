REBOL [
	Title: "ON-INIT-WINDOW Test"
	Short: "ON-INIT-WINDOW Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - 2020 - HMK Design"
	Filename: %on-init-window.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-Feb-2020
	Date: 09-Feb-2020
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test ON-INIT-WINDOW
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug
print ""

get-window-offset: func [face] [
	get in find-window face 'offset
]

get-window-size: func [face] [
	get in find-window face 'size
]

new-win: make-window [
	across
	label "Window Offset"
	info
		on-init-window [set-face face get-window-offset face]
	return
	label "Window Size"
	info
		on-init-window [set-face face get-window-size face]
]

view new-win