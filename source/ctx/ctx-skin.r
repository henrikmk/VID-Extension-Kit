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
	colors:
	images:
	materials:
	surfaces:
		none
]

; parse the skin and build images, colors and surfaces in that order
set 'make-skin func [skin [object!]] [
	;---------- Colors
	ctx-colors/colors: make object! skin/colors
	;---------- Images
	; images are appliable as draw images, which means they must be ready before surfaces
	;---------- Materials
	; materials are appliable for draw blocks, which means they must be ready before surfaces
	;---------- Surfaces
	append clear ctx-surface/surfaces skin/surfaces
]

; clears the old skin and loads a new one from the skin stock
set 'load-skin func [name] [
	make-skin select skins name
]

; reads a skin from disk or memory and appends it to the skin stock. Input is the skin directory.
set 'read-skin func [file [word! file!] /local item skin p paren-rule word] [
	skin: make skin-object []
	; Retrieve colors, images, materials and surfaces from files
	foreach type [colors images materials surfaces] [
		case [
			; Attempt to retrieve from memory
			word? file [
				word: to-word join type '.r
				set in skin type load as-string get word
				unset word
			]
			; Then attempt to load from disk
			if exists? item: to-file rejoin [dirize file join type '.r] [
				set in skin type load item
			]
		]
		; Process parenthesis blocks, except for template and draw
		switch type [
			surfaces [
				; [!] - this executes code in the skin, which is not secure
				; so the dialect should be extended with specific image loading
				paren-rule: [
					any [
						p: paren! (change p do p/1)
						| ['template | 'draw] opt 'state skip
						| into paren-rule
						| skip
					]
				]
				parse skin/surfaces paren-rule
			]
		]
	]
	; Append loaded skin to skin stock
	append skins either word? file [
		file
	][
		to-word trim/with form last split-path file "/"
	]
	append skins skin
]

]
