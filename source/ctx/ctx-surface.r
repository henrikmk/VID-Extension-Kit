REBOL [
	Title: "VID Extension Kit SURFACE Core"
	Short: "VID Extension Kit SURFACE Core"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %ctx-surface.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-May-2010
	Date: 09-May-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		SURFACE context for applying surfaces to a draw-body
	}
	History: []
	Keywords: []
]

; consider inheritage as NONEs will currently override any info, so this means that all words must be stated for a surface

ctx-surface: context [

; catalogue of per-face surfaces
surfaces: []

; a single surface object that is applied to a single draw body
surface: make object! [
	draw:
	template:
	state:
	colors:
	font:
	para:
	margin:
		none
]

; creates a new surface or updates an existing one
set 'make-surface func [name data /parent parent-name /local new-surface] [
	name: to-word name
	case [
		block? data [data: make object! data]
		none? data [data: make object! []]
	]
	if parent [
		parent: select surfaces parent-name
		data: make parent data
	]
	new-surface:
		either current: find surfaces name [
			first back change next current make second current data
		][
			repend surfaces [name make surface data]
			last surfaces
		]
	foreach word words-of new-surface [
		if find [font para colors] word [
			any [
				not block? get in new-surface word
				parse get in new-surface word [any [some word! [val: block! (change val make object! first val) | object!]]]
				set in new-surface word make object! get in new-surface word
			]
		]
	]
]

; sets the skin of the face by applying skin information to the DRAW-BODY
set 'set-surface func [face name /with data] [
	if object? face/draw-body [
		surface: select surfaces name
		if surface [
			face/draw-body/surface: make surface []
			ctx-draw/set-draw-body face
		]
	]
]

]