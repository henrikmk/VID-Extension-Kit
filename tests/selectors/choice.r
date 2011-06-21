REBOL [
	Title: "Choice Test"
	Short: "Choice Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %choice.r
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
		Test of TOGGLE and its variants.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

probe ""

choices: []
loop 50 [val: random "abcdefgh" repend choices [to-word val val]]

view make-window [
	c: choice setup choices [probe get-face face]
]
