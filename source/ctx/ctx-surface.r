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

ctx-surface: context [

; catalogue of per-face surfaces
surfaces: []

; surface block for a face
surface-block: make block! 10

; a single surface object that is applied to a single draw body
surface: make object! [
	parent:
	draw:
	template:
	colors:
	font:
	para:
	margin:
		none
]

; creates a new surface or updates an existing one
set 'make-surface func [name data] [
	name: to-word name
	either find surfaces name [
		change next find surfaces name data
	][
		append surfaces name
		append surfaces data
	]
]

; sets the skin of the face by applying skin information to the DRAW-BODY
set 'set-surface func [face /local parent] [
	unless all [word? face/surface object? face/draw-body] [return false]
	clear surface-block
	parent: face/surface
	until [
		parse find surfaces to-set-word parent [
			set-word!
			set parent opt word!
			set block block! (insert surface-block block)
		]
		none? parent
	]
	face/surface: copy/deep surface-block
	ctx-draw/set-draw-body face
]

]