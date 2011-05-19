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
	; Shape data
	case [
		block? data [data: construct data]
		none? data [data: make object! []]
	]
	; Find parent and extend current with parent
	if parent [
		parent: select surfaces parent-name
		; Add missing parent words to data
		data: construct/with body-of data parent
		foreach facet words-of parent [
			parent-facet: get in parent facet
			data-facet: get in data facet
			if paren? parent-facet [
				insert data-facet parent-facet
			]
		]
	]
	; Determine whether to update a surface or append a new one
	new-surface:
		either current: find surfaces name [
			first back change next current make second current data
		][
			repend surfaces [name make surface data]
			last surfaces
		]
	; Convert word/block pairs to word/object pairs
	change-blocks: [any [some word! [into change-blocks | change-rule]]]
	change-rule: [value: block! (change value make object! value/1) | object!]
	foreach facet words-of new-surface [
		if find [font para colors] facet [
			any [
				not paren? get in new-surface facet
				parse get in new-surface facet change-blocks
				set in new-surface facet make object! get in new-surface facet
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