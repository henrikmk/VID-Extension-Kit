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
	DRAGGER: FACE 16x16 with [
		text: none
		font: none
		para: none
		offset: 0x0
		feel: svvf/drag
		surface: 'frame
	]
	SLIDER: FACE 100.100.100 16x200 with [
		feel:		svvf/slide
		font:		none
		para:		none
		text:		none
		surface:	'recessed
		step:		0.02	; scrolling granularity (for btns, keys, wheels)
		ratio:				; total size / view size (proportional draggers)
		page:				; paging size (for btns, keys, wheels) ; !!! should use Ratio
		axis:		none	; word used to indicate X or Y major axis
		data:		0		; the value of the slider/scroller
		clip:		0x0		; accounts for arrow boxes in scrollers
		dragger:	none	; face for dragger
		access:		ctx-access/data-number
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
					event: none
				]
				event
			]
		]
		init: [
			pane: layout/tight [dragger]
			pane: pane/pane
			dragger: pane/1
			axis: pick [y x] size/y >= size/x
			redrag 0.1
		]
		redrag: func [val /local tmp][
			probe 'redrag
			; clip the ratio to proper range (save for possible resize)
			ratio: min 1 max 0 val
			; compute page step size
			page: any [all [ratio = 1 0] ratio / (1 - ratio)]
			; compute full size of bar
			dragger/size: val: size - (2 * edge/size) - (2 * clip * pick [0x1 1x0] axis = 'y)
			; compute size of dragger
			tmp: val/:axis * ratio
			; don't let dragger get smaller than 10 pixels
			if tmp < 10 [page: either val/:axis = tmp: 10 [1][tmp / (val/:axis - tmp)]]
			probe 'dragger
			either axis = 'y [probe dragger/size/y: tmp][dragger/size/x: tmp]
			resize-draw-body dragger
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
		scroll-face:	none
		surface:		'base
		down-arrow:		none
		up-arrow:		none
		size:			20x100
		speed:			20				; controls the scrolling speed in steps/sec.
		edge:			[size: 0x0]
		feel:			svvf/scroll
		reset:			does [data: 0]
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
					set-face face max 0 min 1 val + pick steps found? find [left up] event/key
					do-face face none
					event: none
				]
				event
			]
			resize-face*: func [face size x y /local axis tmp] [
				face/axis: pick [y x] size/y >= size/x
				axis: face/axis
				; move all resize code in here, so we can use springs instead
				; dragger is not present in h mode. it's hidden beneath the scroller area
				tmp: pick [y x] axis = 'x		; get opposite of axis
				face/clip: face/up-arrow/size: face/down-arrow/size: size/:tmp - (2 * face/edge/size/:tmp) * 1x1
				face/down-arrow/offset: size/:axis - face/down-arrow/size/:axis - (2 * face/edge/size/:axis) * 0x1
				if tmp: axis = 'x [face/down-arrow/offset: reverse face/down-arrow/offset]
				set-face/no-show face/up-arrow pick [left up] tmp
				set-face/no-show face/down-arrow pick [right down] tmp
				resize-draw-body face/up-arrow
				resize-draw-body face/down-arrow
				face/redrag any [face/ratio 0.1]
			]
		]
		action: func [face value] [
			act-face face none 'on-scroll
		]
		init: [
			axis: pick [y x] size/y >= size/x
			pane: layout/tight [
				arrow with [dir: -1 action: get in svvf 'move-drag feel: make svvf/scroll-button []]
				dragger with [feel: svvf/scroller-drag]
				arrow with [dir: 1 action: get in svvf 'move-drag feel: make svvf/scroll-button []]
			]
			pane: pane/pane
			set [up-arrow dragger down-arrow] pane
			; [ ] - can be bothersome in cases where the scroller is not embedded inside a panel, but must still be limited in size
			if none? spring [spring: make block! 4]
			; this would perform a lot better if we had a static grid to layout in
			if axis = 'x [spring: [top]] ; seems to be very specific
			spring: unique spring
;			access/resize-face* self size none none
		]
	]

]