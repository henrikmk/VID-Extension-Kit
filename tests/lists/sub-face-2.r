REBOL [
	Title: "SUB-FACE Test"
	Short: "SUB-FACE Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %sub-face.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 29-May-2011
	Date: 29-May-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test SUB-FACE in DATA-LIST.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

list-data: []

images: reduce [
	help.gif
	exclamation.gif
	info.gif
	logo.gif
	stop.gif
	arrow-down.png
	arrow-up.png
	arrow-left.png
	arrow-right.png
]

loop 25 [
	append/only
		list-data
		reduce [
			pick images random length? images
			pick images random length? images
			pick images random length? images
		]
]

view make-window [
	h3 "SUB-FACE Test"
	bar
	l-data: data-list 324x500 data list-data setup [
		header-face [across button "Images" fill 1x0 spring [bottom]]
		sub-face [
			across space 2
			list-image-cell 100x100
			list-image-cell 100x100
			list-image-cell 100x100
		]
	]
]