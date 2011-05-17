REBOL [
	Title: "VID Extension Kit SKIN Core"
	Short: "VID Extension Kit SKIN Core"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %ctx-skin.r
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
		SKIN context for applying sets of surfaces, image stocks and colors to all draw-bodies
	}
	History: []
	Keywords: []
]

ctx-skin: context [

; list of all skins or the skin stock
skins: []

; standard skin object
skin-object: make object! [
	surfaces:
	images:
	colors:
	materials:
		none
]

; parse the skin and build images, colors and surfaces in that order
set 'make-skin func [skin [object!]] [
	;---------- Colors
	; colors are appliable for draw blocks, which means they must be ready before surfaces
	;---------- Images
	; images are appliable as draw images, which means they must be ready before surfaces
	;---------- Materials
	; materials are appliable for draw blocks, which means they must be ready before surfaces
	;---------- Surfaces
	clear ctx-surface/surfaces
	parse skin/surfaces [
		any [
			set name set-word!
			set parent-name opt word!
			set content opt block!
			(
				either parent-name [
					make-surface/parent name content parent-name
				][
					make-surface name content
				]
			)
		]
	]
]

; clears the old skin and loads a new one from the skin stock
set 'load-skin func [name] [
	make-skin select skins name
]

; reads a skin from disk and appends it to the skin stock. Input is the skin directory.
set 'read-skin func [file /local item skin] [
	skin: make skin-object []
	foreach type [colors images materials surfaces] [
		if exists? item: to-file rejoin [dirize file join type '.r] [
			set in skin type load item
		]
	]
	append skins to-word trim/with form last split-path file "/"
	append skins skin
]

]
