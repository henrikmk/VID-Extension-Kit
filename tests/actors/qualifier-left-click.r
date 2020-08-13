REBOL [
	Title: "ACTOR qualifier test"
	Short: "ACTOR qualifier test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - 2020 - HMK Design"
	Filename: %qualifier-left-click.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 13-Aug-2020
	Date: 13-Aug-2020
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test use of qualifier keys in actors.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug
print ""

; use EVENT event! in the actor code.	
; It's the same as in REBOL's feel functions, so check the REBOL documentation for the fields available in EVENT.

; here EVENT is tested with /SHIFT and /CONTROL

new-win: make-window [
	across
	button 250 "Click with or without Shift/Ctrl"
		on-click [
			use [click] [
				click: copy "Click"
				case/all [
					event/shift [
						append click " + Shift"
					]
					event/control [
						append click " + Control"
					]
				]
				append click join " " now/time/precise
				set-face i click
			]
		]
	return
	i: info fill 1x0
]
view new-win