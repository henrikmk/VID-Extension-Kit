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
	color:
		none
]

; creates a new surface or updates an existing one
set 'make-surface func [name data] [
	name: to-word name
	either current: find surfaces name [
		change next current make second current data
	][
		repend surfaces [name make surface data]
	]
]

; sets the skin of the face by applying skin information to the DRAW-BODY
set 'set-surface func [face name /with data] [
	if object? face/draw-body [
		surface: select surfaces name
		if surface [
			face/draw-body: make face/draw-body surface
			ctx-draw/bind-draw-body face
			ctx-draw/set-draw-body face
		]
	]
]

]