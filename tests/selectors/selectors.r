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

view make-window [
	across
	label "Selector"
	selector
	return
	label "Multi Selector"
	multi-selector
	return
	label "Radio Selector"
	radio-selector
	return
	label "Check Selector"
	check-selector
	return
	label "Choice"
	choice
	return
	label "Rotary"
	rotary
	disable ; rotary does not respond to disable
	return
	label "Tab Selector"
	tab-selector return ; draw-image fail
]