REBOL [
	Title: "FIELD Test"
	Short: "FIELD Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %field.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 21-Jun-2011
	Date: 21-Jun-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test various FIELD types.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug
print ""

view make-window [
	h3 "FIELD Test"
	bar
	panel [
		style s button 50 "Set" [set-face back-face face at copy random "abcdefghijk" random 10]
		style r button 50 "Reset" [reset-face back-face back-face face]
		style c button 50 "Clear" [clear-face back-face back-face back-face face]
		style g button 50 "Get" [probe get-face back-face back-face back-face back-face face]
		across
		label "Standard Field"
			field on-key [probe get-face face]
			s r c g
			return
		label "Filled Field"
			field "Test" on-key [probe get-face face]
			s r c g
			return
		label "Password Field"
			field hide on-key [probe get-face face]
			s r c g
			return
		label "Integer Field"
			field integer on-key [probe get-face face] ; does not report zero on empty field.
			s [set-face back-face face random 1000] r c g
			return
		label "Decimal Field"
			field decimal on-key [probe get-face face] ; does not behave properly like a decimal field
			s [set-face back-face face random 1000] r c g
			return
		label "Date/Time Field"
			date-time-field on-key [probe get-face face]
			s [set-face back-face face random now] r c g
			return
		label "Date Field"
			date-field on-key [probe get-face face]
			s [set-face back-face face random now] r c g
			return
	]
]