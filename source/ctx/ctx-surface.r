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
set 'set-surface func [face /local i parent paren-rule s] [
	unless all [word? face/surface object? face/draw-body] [return false]
	clear surface-block
	parent: face/surface
	; Find all parents for this surface
	until [
		s: find surfaces to-set-word parent
		any [s make error! rejoin ["Unknown surface '" parent "'"]]
		parse s [
			set-word!
			set parent opt word!
			set block block! (insert surface-block block)
		]
		none? parent
	]
	face/surface: copy/deep surface-block
	; Parse template and draw blocks for vertices
	i: 0
	face/draw-body/vertices: copy face/draw-body/points: make block! []
	paren-rule: [
		any [
			p: paren! (i: i + 1 append/only face/draw-body/vertices p/1 change/only p to-path reduce ['points i])
			| into paren-rule
			| skip
		]
	]
	parse face/surface paren-rule
	bind face/draw-body/vertices face/draw-body
	bind bind face/surface face face/draw-body
	svvf/set-face-state face none
	ctx-draw/set-draw-body/init face ; do an initial set here
]

]