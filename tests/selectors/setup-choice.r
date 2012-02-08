REBOL [
	Title: "Setup Choice Test"
	Short: "Setup Choice Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %setup-choice.r
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
		Test different content of CHOICE with SETUP-FACE.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

probe ""

setup-choice: does [ ; this will setup the choice
	choices: make block! []
	loop 50 [val: random "abcdefgh" repend choices [to-word val val]]
	setup-face c choices
]

view make-window [
	button "SETUP-FACE" [setup-choice]
	c: choice [probe get-face face]
	do [setup-choice] ; initial setup
]
