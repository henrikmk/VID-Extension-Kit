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
		across
		label "Standard Field"
			field on-key [probe get-face face]
			return
		label "Integer Field"
			field integer on-key [probe get-face face] ; does not report zero on empty field.
			return
		label "Decimal Field"
			field decimal on-key [probe get-face face] ; does not behave properly like a decimal field
			return
		label "Date/Time Field"
			date-time-field on-key [probe get-face face]
			return
		label "Date Field"
			date-field on-key [probe get-face face]
			return
	]
]