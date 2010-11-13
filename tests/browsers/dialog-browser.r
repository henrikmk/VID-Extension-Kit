REBOL [
	Title: "Dialog Browser"
	Short: "Dialog Browser"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %dialog-browser.r
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
		Browse and inspect all dialogs in the VID Extension Kit.
	}
	History: []
	Keywords: []
]

do %../vid-include.r

ctx-vid-debug/debug: false

view make-window [
	at 0x0
	button "About..." align [top right] spring [left bottom] [about-program]
	style bt button spring [bottom] 200 [do get to-word face/text "Argument 1" "Argument 2" "Argument 3"][probe get to-word face/text]
	style bl-bt bt [do get to-word face/text ["Argument 1" "Argument 2" "Argument 3"]]
	across
	panel [
		panel [
			h3 "Simple Dialogs"
			bar
			bt "ALERT"
			bt "NOTIFY"
			bt "WARN"
			bt "ABOUT-PROGRAM"
		]
		panel [
			h3 "Requesters"
			bar
			bt "REQUEST-COLOR"
			bt "REQUEST-FILE"
			bt "REQUEST-VALUE"
			bt "REQUEST-RENAME"
			bl-bt "REQUEST-ITEM"
			bt "REQUEST-ITEMS"
			bt "REQUEST-USER"
			bt "REQUEST-PASS"
			bt "REQUEST-DATE"
			bt "REQUEST-DOWNLOAD"
			bt "REQUEST-EMAIL"
			bt "REQUEST-MESSAGE"
			bt "QUESTION"
			bt "IMPORTANT-QUESTION"
		]
	]
]