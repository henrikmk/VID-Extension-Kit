REBOL [
	Title: "Build Test"
	Short: "Build Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %built-vid-ext-kit.r
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
		Test of build process and inclusion of the built release.
	}
	History: []
	Keywords: []
]

do %../../build/build.r ; no need to use this in your program, just testing build process here

do %../../release/vid-ext-kit.r ; include this in your program

clear ctx-vid-debug/debug

view make-window [text 250 "VID Extension Kit works as a single built file." button "Quit" [quit]]