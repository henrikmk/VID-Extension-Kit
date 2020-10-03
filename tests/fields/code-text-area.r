REBOL [
	Title: "CODE-TEXT-AREA Test"
	Short: "CODE-TEXT-AREA Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - 2020 - HMK Design"
	Filename: %code-text-area.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 03-Oct-2020
	Date: 03-Oct-2020
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test CODE-TEXT-AREA in relation to TEXT-BODY.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug
print ""

text1: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."

text2: "Test"

view make-window [
	across
	t: code-text-area text1
	right-panel [
		b1: button "Text 1" [set-face t text1]
		b2: button "Text 2" [set-face t text2]
		b3: button "Get Text" [probe get-face t]
		b4: button "Get Text Body" [probe t/text-body]
	]
]