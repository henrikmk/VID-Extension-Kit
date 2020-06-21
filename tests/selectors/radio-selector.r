REBOL [
	Title: "Radio Selector Test"
	Short: "Radio Selector Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2020 - HMK Design"
	Filename: %radio-selector.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 21-Jun-2020
	Date: 21-Jun-2020
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test of RADIO-SELECTOR.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

custom-selection: [ketchup "Ketchup" mustard "Mustard" pickles "Pickles" onions "Onions"] ; use a key/value block to set choices

view make-window [
	across
	panel [
		below
		h3 "Default setup"
		r1: radio-selector																; without SETUP, you are provided with a standard set of choices
		button "Set Choice 1" [set-face r1 'choice1]
		button "Set Choice 2" [set-face r1 'choice2]
		button "Set Choice 3" [set-face r1 'choice3]
		button "Set Invalid" [set-face r1 'non-existent]	; R1/DATA will be set to NONE, if trying to set a non-existent key
		button "Get Choices" [probe get-face-setup r1]
		button "Clear Face" [clear-face r1]
		button "Reset Face" [reset-face r1]
		button "Get Face" [probe get-face r1]
	]
	panel [
		below
		h3 "Custom Setup"
		r2: radio-selector setup custom-selection
		button 150 "Set Choice 1 with key" [set-face r2 'ketchup]
		button 150 "Set Choice 1 with value" [set-face r2 "Ketchup"]			; also works with value instead of key
		button 150 "Set Choice 2" [set-face r2 'mustard]
		button 150 "Set Choice 3" [set-face r2 'pickles]
		button 150 "Set First" [set-face r2 first get-face-setup r2]
		button 150 "Set Last" [set-face r2 last get-face-setup r2]
		button 150 "Set Invalid" [set-face r2 'non-existent]
		button 150 "Get Choices" [probe get-face-setup r2]
		button 150 "Set Current as Default" [															; this doesn't update the face
			set-face-default r2 get-face r2
		]
		button 150 "Get Default" [probe get-face-default r2]
		button 150 "Clear Face" [clear-face r2]
		button 150 "Reset Face" [reset-face r2]														; will pick the first choice or default
		button 150 "Get Face" [probe get-face r2]
	]
]