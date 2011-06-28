REBOL [
	Title: "Resizer Test"
	Short: "Resizer Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %resizer.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 28-Jun-2011
	Date: 28-Jun-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test RESIZER.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug
print ""
view make-window [
	h3 "RESIZER Test"
	bar
	across
	box red
	resizer on-drag [probe face/offset]
	box green
	resizer on-drag [probe face/offset]
	box blue
]