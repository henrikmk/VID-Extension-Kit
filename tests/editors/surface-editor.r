REBOL [
	Title: "Surface Editor"
	Short: "Surface Editor"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %surface-editor.r
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
		Cheap surface editor. Edit the surface object of a single face.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

view make-window [
	panel [
	]
]