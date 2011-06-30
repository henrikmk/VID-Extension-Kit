REBOL [
	Title: "Selectors Test"
	Short: "Selectors Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %selectors.r
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
		Test of all SELECTOR based styles from styles/selector.r
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

stylize/master [
	disable: toggle "Disable" [either value [disable-face back-face face][enable-face back-face face]]
]

selections: [choice1 "Choice A" choice2 "Choice B" choice3 "Choice C"]

view make-window [
	across
	label "Selector"
	selector setup selections
	return
	label "Multi Selector"
	multi-selector setup selections
	return
	label "Radio Selector"
	radio-selector setup selections
	return
	label "Check Selector"
	check-selector setup selections
	return
	label "Choice"
	choice setup selections
	return
	;label "Rotary"
	;rotary ; won't work with setup
	;disable ; rotary does not respond to disable
	return
	label "Tab Selector"
	tab-selector setup selections return
]