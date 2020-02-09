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

view make-window [
	field on-close-window [print ["Face contained:" get-face face] wait 2]
]