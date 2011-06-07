REBOL [
	Title: "VID Image"
	Short: "VID Image"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2008 - HMK Design"
	Filename: %image.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 27-Dec-2008
	Date: 27-Dec-2008
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Variants of IMAGE.
	}
	History: []
	Keywords: []
]

stylize/master [
	; Base image style
	IMAGE: FACE with [
		size: color: image: none
		surface: none
		feel: svvf/sensor
		access: ctx-access/image
		effect: [fit]
;		edge: [size: 0x0 color: black]
;		font: [size: 16 align: 'center valign: 'middle style: 'bold shadow: 2x2]
		doc: [
			info:	"Base style for images"
			image:	"loaded image data"
			string:	"text on top of image"
			pair:	"width and height of text area"
			tuple:	"colorize the image"
			file:	"load as image data"
			url:	"load as image data"
			block:	["execute when clicked" "execute when alt-clicked"]
		]
		init: [
			; need to figure out how to pass the image to the draw-body as it is not part of the surface object
			; [s] - same problem here
			if image? image [
				if none? size [size: image/size]
				if size/y < 0 [size/y: size/x * image/size/y / image/size/x  effect: insert copy effect 'fit]
				if color [effect: join effect ['colorize color]]
			]
			if none? size [size: 100x100]
		]
	]

	BACKDROP: IMAGE with [
		access: none
		doc: [info: "image scaled to fill pane" pair: block: none]; fill 1x1 ; [ ] - need an origin 0x0 here
		;init: append copy init [size: pane-size]
	]

	BACKTILE: BACKDROP
		doc [info: "Image tiled to fill pane"]
		effect [tile-view]

	; Standard REBOL logo bar
	LOGO-BAR: IMAGE with [
		update: does [
			self/pane/1/offset/y: self/size/y - 100
			self/pane/2/size/y: self/size/y - 99
			self
		]
		resize: func [siz /x /y] [
			either any [x y] [
				if x [size/x: siz]
				if y [size/y: siz]
			][size: siz]
			update
		]
		logo-vert: [
			size 24x100 origin 0x0
			image logo.gif 100x100 effect [rotate 270]
		]
		init: [
			pane: reduce [
				make system/view/vid/vid-face [offset: 0x199 image: to-image layout logo-vert size: 24x100 edge: none]
				make system/view/vid/vid-face [size: 24x200 effect: [gradient 0x1 50.70.140 0.0.0] edge: none]
			]
			if none? size [size: 24x300]
			update self
		]
	]

	; Base image animation style
	ANIM: IMAGE with [
		frames: copy []
		rate: 1
		feel: make feel [
			engage: func [face action event][
				if action = 'time [
					if empty? face/frames [exit]
					; [s] - will be a problem with surface
					face/draw-body/draw-image: first face/frames
					if tail? face/frames: next face/frames [
						face/frames: head face/frames
					]
					show face
				]
			]
		]
		words: [
			frames [append new/frames second args next args]
			rate   [new/rate: second args next args]
		]
		init: [
			if image? image [
				if none? size [size: image/size]
				if size/y < 0 [size/y: size/x * image/size/y / image/size/x effect: insert copy effect 'fit]
				if color [effect: join effect ['colorize color]]
			]
			if none? size [size: 100x100]
			forall frames [change frames load-image first frames]
			frames: head frames
			image: all [not empty? frames first frames]
		]
	]

	; Image style that contains multiple images
	IMAGES: IMAGE with [
		images: make block! []
		access: make object! [
			set-face*: func [face image] [
				if none? image [
					face/data: none
					set-image face false
				]
				if any [
					logic? image
					integer? image
				] [
					face/data: image
					set-image face pick face/images image
				]
				if word? image [
					all [
						face/data: image
						set-image face select face/images image
					]
				]
				show face
				image
			]
			get-face*: func [face] [face/data]
		]
		init: [
			if none? size [size: 100x100]
			unless empty? images [
				access/set-face* self data
			]
		]
	]
]