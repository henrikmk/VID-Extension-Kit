REBOL [
	Title: "SKIN Core"
	Short: "SKIN Core"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011, 2012 - HMK Design"
	Filename: %ctx-skin.r
	Version: 0.0.2
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-May-2010
	Date: 19-feb-2012
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

; words of the skin object
types: words-of skin-object

set 'get-skin func [
	"Returns a skin object from the skin stock. Returns error! if it does not exist."
	skin [word!] "Skin name as word"
] [
	any [
		select skins skin
		throw make error! rejoin ["Skin '" skin "' does not exist."]
	]
]

set 'append-skin func [
	"Append a skin object onto another skin object."
	obj1 [object!] "The skin object to append to."
	obj2 [object!] "The skin object that is appended."
] [
	foreach type types [
		if all [obj1/:type in obj2 type] [append obj1/:type obj2/:type]
	]
]

set 'apply-skin func [
	"Applies a skin object to the user interface."
	obj [object!]
] [
	;---------- Colors
	ctx-colors/colors: make object! obj/colors
	;---------- Images
	; images are appliable as draw images, which means they must be ready before surfaces
	;---------- Materials
	; materials are appliable for draw blocks, which means they must be ready before surfaces
	;---------- Surfaces
	append clear ctx-surface/surfaces obj/surfaces
]

set 'read-skin func [
	[catch]
	"Reads skin files from directory into a skin object."
	skin [file!] "Directory or word to read from."
	/local item new-obj
] [
	new-obj: make skin-object []
	; Retrieve colors, images, materials and surfaces from files or skin object
	either exists? skin [
		foreach type types [
			if exists? item: to-file rejoin [dirize form skin join type '.r] [
				set in new-obj type load item
			]
		]
	][
		throw make error! rejoin ["Skin '" skin "' not found"]
	]
	new-obj
]

set 'parse-skin func [
	"Parses a skin object."
	obj [object!]
] [
	; Process parenthesis blocks, except for template and draw from the current processing position
	foreach type types [
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
				parse obj/surfaces paren-rule
			]
			; other types come later
		]
	]
	obj
]

set 'store-skin func [
	"Stores a skin object in the skin stock with the given word."
	skin [word!] "Name of skin"
	obj [object!] "Skin object"
] [
	either find skins skin [
		change next find skin skin obj
	][
		append append skins skin obj
	]
	obj
]

]
