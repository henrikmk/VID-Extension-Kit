REBOL [
	Title: "VID Scroller"
	Short: "VID Scroller"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %scroller.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 14-May-2009
	Date: 14-May-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Scroller faces for VID
	}
	History: []
	Keywords: []
]

stylize/master [
	SLIDER: FACE 100.100.100 16x200 with [
		feel:	svvf/slide
		font:	none
		para:	none
		text:	none
		step:	0.02	; scrolling granularity (for btns, keys, wheels)
		ratio:			; total size / view size (proportional draggers)
		page:			; paging size (for btns, keys, wheels) ; !!! should use Ratio
		axis:	none	; word used to indicate X or Y major axis
		data:	0		; the value of the slider/scroller
		clip:	0x0		; accounts for arrow boxes in scrollers
		access:	ctx-access/data-number
		access: make access [
			resize-face*: func [face size x y] [
				face/axis: pick [y x] size/y >= size/x
				face/redrag face/ratio
			]
			key-face*: func [face event] [
				if find [left up right down] event/key [
					set-face face add (get-face face)
						case [
							find [left up] event/key [negate face/step]
							find [right down] event/key [face/step]
						]
					do-face face none
				]
			]
		]
		flags: [input]
		dragger: make svv/vid-face [
			offset: 0x0
			color: 128.128.128
			colors: svvc/action-colors
			disabled-colors: none
			feel: svvf/drag
			style: 'dragger
			text: font: para: none
			flags: [internal action]
			edge: make edge [size: 1x1 effect: 'bevel color: 128.128.128]
		]
		init: [
			pane: reduce [make dragger [edge: make edge []]]
			if colors [color: first colors pane/1/color: second colors]
			axis: pick [y x] size/y >= size/x
			redrag 0.1
		]
		redrag: func [val /local tmp][
			state: none
			; clip the ratio to proper range (save for possible resize)
			ratio: min 1 max 0 val
			; compute page step size
			page: any [all [ratio = 1 0] ratio / (1 - ratio)]
			; compute full size of bar
			pane/1/size: val: size - (2 * edge/size) - (2 * clip * pick [0x1 1x0] axis = 'y)
			; compute size of dragger
			tmp: val/:axis * ratio
			; don't let dragger get smaller than 10 pixels
			if tmp < 10 [page: either val/:axis = tmp: 10 [1][tmp / (val/:axis - tmp)]]
			either axis = 'y [pane/1/size/y: tmp][pane/1/size/x: tmp]
		]
	]

	; slider with value between 0 and 255 and step size 1
	GRADIENT-SLIDER: SLIDER with [
		step: 1
		gradient: none
		set-gradient: func [face /local axis sz] [
			axis: face/axis
			sz: face-size face
			face/effect: compose/deep [
				draw [
					pen none
					fill-pen checker-board.png
					box 0x0 (sz)
					fill-pen linear 0x0 normal 0 (sz/:axis) 0 1 1 (face/gradient)
					box 0x0 (sz)
				]
			]
		]
		access: make access [
			setup-face*: func [face value /local axis sz] [
				face/gradient: value
				face/set-gradient face
			]
			set-face*: func [face value] [
				either block? value [
					setup-face* face value
				][
					face/data: value / 255
				]
			]
			get-face*: func [face] [
				round face/data * 255
			]
		]
		append init [
			access/setup-face* self setup
			insert-actor-func self 'on-resize :set-gradient
		]
	]

	; Standard scroll-bar
	SCROLLER: SLIDER spring [left] with [
		align: none
		; [ ] - method to redrag the scroller on redraw of scroll-face
		; [ ] - find or create an appropriately simple scrollable face
		scroll-face: none
		down-arrow: up-arrow: none
		size: 20x100
		speed: 20				; controls the scrolling speed in steps/sec.
		edge: [size: 0x0]
		feel: svvf/scroll
		reset: does [data: 0]
		resize: func [new /x /y /local tmp][
			either any [x y] [
				if x [size/x: new]
				if y [size/y: new]
			][
				size: any [new size]
			]
			tmp: pick [y x] axis = 'x		; get opposite of axis
			clip: pane/2/size: pane/3/size: size/:tmp - (2 * edge/size/:tmp) * 1x1
			pane/3/offset: size/:axis - pane/3/size/:axis - (2 * edge/size/:axis) * 0x1
			if tmp: axis = 'x [pane/3/offset: reverse pane/3/offset]
			pane/2/data: pick [left up] tmp
			pane/3/data: pick [right down] tmp
			state: pane/2/effect: pane/3/effect: none
			do pane/2/init do pane/3/init
			pane/1/offset: 0x0
			redrag any [ratio 0.1]
		]
		; [ ] - expose redrag value to calculate step size
		; for redrag, need to accept text body or ratio value
		; need this in accessor, possibly with set-face or redrag-face
		access: make access [
			key-face*: func [face event /local dir steps val] [
				; needs to be the same action as for the arrows instead of this code
;				steps: reduce [-0.1 0.1]
				val: get-face face
				if find [up down left right] event/key [
					dir: pick [-1 1] found? find [up left] event/key
					; step size is determined outside the scroller
					; 
					set-face face max 0 min 1 val + pick steps found? find [left up] event/key
					do-face face none
				]
			]
			resize-face*: func [face size x y] [
				face/axis: pick [y x] size/y >= size/x
				face/resize size
			]
		]
		action: func [face value] [
			act-face face none 'on-scroll
		]
		init: [
			pane: reduce [
				make dragger [
					edge: make edge []
					feel: svvf/scroller-drag
					access: ctx-access/button
				]
				axis: make svv/vid-styles/arrow [
					dir: -1
					edge: make edge []
;					flags: make block! []
					;color: first colors: [128.128.128 0.0.0]
					action: get in svvf 'move-drag
					feel: make svvf/scroll-button []
				]
				make axis [dir: 1 edge: make edge []]
			]
			up-arrow: pane/1
			down-arrow: pane/3
			if colors [
				color: first colors pane/1/color: second colors
				pane/2/colors: pane/3/colors: append copy at colors 2 pane/2/colors/2
			]
			axis: pick [y x] size/y >= size/x
			; [ ] - can be bothersome in cases where the scroller is not embedded inside a panel, but must still be limited in size
			if none? spring [spring: make block! 4]
			; this would perform a lot better if we had a static grid to layout in
			if axis = 'x [spring: [top]] ; seems to be very specific
			spring: unique spring
			resize size
		]
	]

]