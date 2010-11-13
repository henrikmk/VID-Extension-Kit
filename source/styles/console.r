REBOL [
	Title: "VID Console Style"
	Short: "VID Console Style"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %vid-console.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 08-May-2010
	Date: 08-May-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		General purpose console with a field and history.
	}
	History: []
	Keywords: []
]

; swap two positions in the layout, possibly.

stylize/master [

CONSOLE: COMPOUND with [
	history: none
	init: [
		history: make block! 1000
		pane: layout/tight [
			; dynamically sized list here? possibly
			; also reverse scroll direction
			box fill 1x0
			field fill 1x0
				on-return [
					
				]
				on-key [
					
				]
		]
	]
]

]