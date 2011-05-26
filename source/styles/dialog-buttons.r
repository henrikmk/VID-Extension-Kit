REBOL [
	Title: "VID Dialog Button Groups"
	Short: "VID Dialog Button Groups"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %dialog-buttons.r
	Version: 0.0.2
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Jan-2009
	Date: 09-May-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Common button groups for dialogs
	}
	History: []
	Keywords: []
]

stylize/master [
	;-- Buttons
	LEFT-BUTTON: BUTTON ctx-colors/colors/true-color
	RIGHT-BUTTON: BUTTON align [right] spring [left bottom]
	CENTER-BUTTON: BUTTON align [left right] spring [left right]
	; the actions are not working here. review this. this may have changed.
	TRUE-BUTTON: LEFT-BUTTON "True" ctx-colors/colors/true-color [ctx-dialog/set-dialog-value face true]
	FALSE-BUTTON: RIGHT-BUTTON "False" ctx-colors/colors/false-color [ctx-dialog/set-dialog-value face false]
	VALIDATE-BUTTON: TRUE-BUTTON "Validate" ctx-colors/colors/true-color [ctx-dialog/dialog-use face]
	OK-BUTTON: TRUE-BUTTON "OK" ctx-colors/colors/true-color
	YES-BUTTON: TRUE-BUTTON "Yes" ctx-colors/colors/true-color
	RETRY-BUTTON: TRUE-BUTTON "Retry" ctx-colors/colors/true-color
	SAVE-BUTTON: VALIDATE-BUTTON "Save" ctx-colors/colors/true-color
	USE-BUTTON: VALIDATE-BUTTON "Use" ctx-colors/colors/true-color
	SEND-BUTTON: VALIDATE-BUTTON "Send" ctx-colors/colors/true-color
	CANCEL-BUTTON: FALSE-BUTTON "Cancel" ctx-colors/colors/false-color
	CLOSE-BUTTON: CENTER-BUTTON "Close" [ctx-dialog/set-dialog-value face false]
	NO-BUTTON: FALSE-BUTTON "No" ctx-colors/colors/false-color

	;-- Button Groups
	BTN-GROUP: COMPOUND fill 1x0 spring [top]
	CLOSE: BTN-GROUP [bar close-button]
	CANCEL: BTN-GROUP [bar cancel-button align [left right] spring [left right]]
	OK-CANCEL: BTN-GROUP [across bar return ok-button cancel-button]
	SAVE-CANCEL: BTN-GROUP [across bar return save-button cancel-button]
	USE-CANCEL: BTN-GROUP [across bar return use-button cancel-button]
	SEND-CANCEL: BTN-GROUP [across bar return send-button cancel-button]
	YES-NO: BTN-GROUP [across bar return yes-button no-button]
	YES-NO-CANCEL: BTN-GROUP [across bar return yes-button cancel-button align none no-button align none]
	RETRY-CANCEL: BTN-GROUP [across bar return retry-button no-button cancel-button]
]
