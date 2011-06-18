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
probe 's
view make-window [
	c: choice
		[probe 'a]						; this is still run as an action with do-face somewhere
;		on-select [wait 1 probe describe-face face probe 'selecting]	; choice-list
;		on-click [probe describe-face face probe 'clicking]		; choice
	;button "Focus?" [probe describe-face system/view/focal-face]
	;button "Get-face" [probe get-face c]
	;button "Set-face" [set-face c 'choice2]
	;button "Do-face" [do-face c none] ; this should perform the selection, rather than open the face
	;button "On-select" [act-face c none 'on-select] ; wrong face here
]
