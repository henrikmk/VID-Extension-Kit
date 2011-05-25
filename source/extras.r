REBOL [
	Title: "VID Extras"
	Short: "VID Extras"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %extras.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 16-Jul-2009
	Date: 16-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Extra functions that usually belong in R2 forward but are necessary to use the VID Extension kit
	}
	History: []
	Keywords: []
]

; format

format: func [
	"Format a string according to the format dialect."
	rules {A block in the format dialect. E.g. [10 -10 #"-" 4]}
	values
	/pad p
	/local out val rule
][
	p: any [p #" "]
	unless block? :rules [rules: reduce [:rules]]
	unless block? :values [values: reduce [:values]]
	val: 0
	foreach item rules [
		if word? :item [item: get item]
		val: val + switch/default type?/word :item [
			integer! [abs item]
			string! [length? item]
			char! [1]
		] [0]
	]
	out: make string! val
	insert/dup out p val
	foreach rule rules [
		if word? :rule [rule: get rule]
		switch type?/word :rule [
			integer! [
				pad: rule
				val: form first+ values
				clear at val 1 + abs rule
				if negative? rule [
					pad: rule + length? val
					if negative? pad [out: skip out negate pad]
					pad: length? val
				]
				change out :val
				out: skip out pad
			]
			string! [out: change out rule]
			char! [out: change out rule]
		]
	]
	unless tail? values [append out values]
	head out
]

; SIZE-TEXT that takes edges, margin and origin into account
face-size-text: func [face] [
	face/font/offset +
	(any [all [face/edge face/edge/size * 2] 0]) +
	(any [all [face/para face/para/origin] 0]) +
	(any [all [face/para face/para/margin] 0]) +
	size-text face
]

; determine horizontal or vertical size of face from its text, if face/size/:dir = -1 (doesn't make sense to do both)
face-size-from-text: func [face dir /local sz] [
	any [dir return face/size]
	any [face/font return face/size]
	if face/size/:dir = -1 [
		face/size/:dir: 1000
		sz: face-size-text face
		face/size/:dir: sz/:dir
	]
	face/size
]

; interpolate between two colors
interpolate: func [color1 color2 length /local step] [
	blk: make block! length
	color1: color1 + 0.0.0.0
	color2: color2 + 0.0.0.0
	diff: reduce [
		color2/1 - color1/1
		color2/2 - color1/2
		color2/3 - color1/3
		color2/4 - color1/4
	]
	append blk color1
	; linear interpolate between colors
	; negative is showing the diff properly
	length: length - 1
	repeat i length - 1 [
		append blk to-tuple reduce [
			to-integer diff/1 / length * i + color1/1
			to-integer diff/2 / length * i + color1/2
			to-integer diff/3 / length * i + color1/3
			to-integer diff/4 / length * i + color1/4
		]
	]
	append blk color2
]
; put this somewhere as a VID draw function
; sets an image via DRAW instead of FACE/IMAGE. Assumes an IMAGE-DRAW-BLOCK. Takes text adjustment into account.
; obsolete
;set-image: func [face image] [
;	unless block? face/effect [face/effect: copy/deep [draw [image 0x0 none]]]
;	pos: 0x0
;	if all [face/size face/text image face/font/align <> 'right] [
;		pos: face/size - image/size - any [all [face/edge face/edge/size * 2] 0x0]
;	]
;	face/effect/draw/2: pos ; set position
;	face/effect/draw/3: face/draw-image: image ; set image
;]