base: [
	margin 2x2
	font [shadow: none valign: 'middle size: 12 align: 'left]
	para [origin: 4x2 wrap?: on]
]
box: base [
	font [shadow: 2x2 size: 16 align: 'center color: white style: 'bold]
]
text: base [
	font state [
		released [color: black]
		disabled [color: 140.140.140]
	]
]
form-text: text [
	colors [
		border: ctx-colors/colors/line-color
		background: snow
	]
	template [
		anti-alias off
		pen none
		fill-pen colors/border
		box outer/1 outer/5
		fill-pen colors/background
		box inner/1 inner/5
	]
]
frame: base [
	colors state [
		released away drag-away [
			background: any [color 200.200.200]
			shine: background + 40
			shadow: background - 60
		]
		pressed drag-over [
			background: any [all [color color / 2] 100.150.100]
			shine: background - 40
			shadow: background + 60
		]
		over [
			background: any [all [color color + 10] 210.210.210]
			shine: background + 40
			shadow: background - 60
		]
		disabled [
			background: 200.200.200
			shine: background + 20
			shadow: background - 30
		]
	]
	template [
		anti-alias off
		pen none
		fill-pen colors/shine
		polygon outer/1 outer/3 inner/3 inner/7 outer/7 outer/1
		fill-pen colors/shadow
		polygon outer/3 outer/5 outer/7 inner/7 inner/3 outer/3
		fill-pen colors/background
		box inner/1 inner/5 1
	]
	font state [
		released away drag-away [color: black]
		over [color: blue]
		pressed drag-over [color: white]
		disabled [color: 140.140.140]
	]
]
recessed: frame [
	template [
		anti-alias off
		pen none
		fill-pen colors/shadow
		polygon outer/1 outer/3 inner/3 inner/7 outer/7 outer/1
		fill-pen colors/shine
		polygon outer/3 outer/5 outer/7 inner/7 inner/3 outer/3
		fill-pen colors/background
		box inner/1 inner/5 1
	]
]
button: frame [
	font [align: 'center style: 'bold]
]
highlight-button: frame [
	font state [
		init [color: white align: 'center style: 'bold shadow: 1x1]
		released away drag-away [shadow: 1x1 color: white]
		over [color: white]
		pressed drag-over [color: 200.200.200]
		disabled [shadow: 0x0 color: 140.140.140]
	]
]
info: recessed [
]
dummy: recessed [
	draw-image (load-stock 'blocked)
	draw [
		pen none
		fill-pen draw-image
		box inner/1 inner/5
	]
]
field: info [
	colors state [
		focused [
			shine: 240.240.240
			background: ctx-colors/colors/field-select-color
			shadow: 140.140.140
		]
		unfocused [
			shine: 240.240.240
			background: ctx-colors/colors/field-color
			shadow: 140.140.140
		]
		disabled [
			shine: 220.220.220
			background: 210.210.210
			shadow: 160.160.160
		]
	]
]
area: field [
	font [valign: 'top]
	para [wrap?: true]
]
code: field [
	font [name: "courier"]
]
toggle: button [
	colors state [
		disabled state [
			on [value: 0.200.0]
			off [value: 80.80.80]
		]
		focused unfocused state [
			on [value: green]
			off [value: black]
		]
	]
	draw [
		anti-alias off
		pen none
		fill-pen colors/shine
		triangle 12x2 2x12 2x2
		fill-pen colors/shadow
		triangle 11x2 2x11 2x2
		fill-pen colors/value
		triangle 10x2 2x10 2x2
	]
]
right-icon: frame [
	draw [image image-inner/4 draw-image]
	font [align: 'left style: 'bold]
	para [origin: 4x2]
]
choice: right-icon [
	draw-image (load-stock 'arrow-pop)
]
sort: right-icon [
	draw-image state [
		no-sort []
		ascending (load-stock 'arrow-up)
		descending (load-stock 'arrow-down)
	]
]
image: base [
	draw [
		image image-center draw-image
	]
]
check: image [
	draw-image state [
		off state [
			released away drag-away (load-stock 'check-off-up)
			over (load-stock 'check-off-over)
			pressed drag-over (load-stock 'check-off-down)
		]
		on state [
			released away drag-away (load-stock 'check-on-up)
			over (load-stock 'check-on-over)
			pressed drag-over (load-stock 'check-on-down)
		]
	]
]
; some problems here, but might be in the feel object for radio
radio: image [
	draw-image state [
		off state [
			released away drag-away (load-stock 'radio-off-up)
			over (load-stock 'radio-off-over)
			pressed drag-over (load-stock 'radio-off-down)
		]
		on state [
			released away drag-away (load-stock 'radio-on-up)
			over (load-stock 'radio-on-over)
			pressed drag-over (load-stock 'radio-on-down)
		]
	]
]
glyph: frame [
	colors state [
		released away drag-away [
			value: ctx-colors/colors/glyph-color
		]
		pressed drag-over [
			value: white
		]
		over [
			value: blue
		]
		disabled [
			value: saturate ctx-colors/colors/glyph-color 50
		]
	]
]
arrow: glyph [
	draw [
		anti-alias on
		pen none
		fill-pen colors/value
		translate center
		rotate direction
		triangle 0x-5 5x5 -5x5
	]
]
sort-reset: glyph [
	draw [
		anti-alias off
		pen none
		fill-pen colors/value
		translate center
		polygon 5x0 0x-5 -5x0 0x5
	]
]
check-line: check [
	; provide disabled bitmap somehow or put an alpha box over it
	draw [image image-outer/1 draw-image]
	para [origin: 26x2]
	font state [
		released away drag-away [align: 'left style: none color: black]
		over [color: blue]
		pressed drag-over [color: white]
		disabled [color: 140.140.140]
	]
]
radio-line: radio [
	draw [image image-outer/1 draw-image]
	para [origin: 26x2]
	font state [
		released away drag-away [align: 'left style: none color: black]
		over [color: blue]
		pressed drag-over [color: white]
		disabled [color: 140.140.140]
	]
]
tab: button [
	colors state [
		on state [
			released away drag-away [
				shine: 240.240.240
				background: 210.210.210
				shadow: 140.140.140
			]
			pressed drag-over [
				shine: 140.140.140
				background: 100.100.100
				shadow: 240.240.240
			]
			over [
				shine: 250.250.250
				background: 220.220.220
				shadow: 150.150.150
			]
			disabled [
				shine: 220.220.220
				background: 200.200.200
				shadow: 160.160.160
			]
		]
		off state [
			released away drag-away [
				shine: 240.240.240
				background: 160.160.160
				shadow: 140.140.140
			]
			pressed drag-over [
				shine: 140.140.140
				background: 100.100.100
				shadow: 240.240.240
			]
			over [
				shine: 250.250.250
				background: 170.170.170
				shadow: 150.150.150
			]
			disabled [
				shine: 220.220.220
				background: 160.160.160
				shadow: 160.160.160
			]
		]
	]
	template state [
		on [
			anti-alias off
			pen none
			fill-pen colors/shine
			box outer/7 (inner/1 + 0x3)
			box (outer/1 + 4x0) (inner/3 - 2x0)
			fill-pen colors/shadow
			box outer/5 (inner/3 + 0x3)
			; Background
			fill-pen colors/background
			shape [
				move (inner/7 + 0x2)
				line (inner/1 + 0x3)
				line (inner/1 + 3x0)
				line (inner/3 - 3x0)
				line (inner/3 + 0x3)
				line (inner/5 + 0x2)
			]
			fill-pen (colors/shine + 10)
			shape [
				move 0x5
				'line 5x-5
				'line 1x1
				'line -4x4
			]
			fill-pen (second interpolate colors/shine colors/shadow 3)
			shape [
				move outer/3
				'move 0x5
				'line -5x-5
				'line 0x1
				'line 4x4
			]
		]
		off [
			anti-alias off
			pen none
			fill-pen colors/shine
			box (outer/7 - 0x2) (inner/1 + 0x5)
			box (outer/1 + 4x2) (inner/3 - 2x-2)
			fill-pen colors/shadow
			box (outer/5 - 0x2) (inner/3 + 0x5)
			fill-pen colors/background
			shape [
				move inner/7
				line (inner/1 + 0x5)
				line (inner/1 + 3x2)
				line (inner/3 - 3x-2)
				line (inner/3 + 0x4)
				line inner/5
			]
			fill-pen (colors/shine + 10)
			shape [
				move 0x7
				'line 5x-5
				'line 1x1
				'line -4x4
			]
			fill-pen (second interpolate colors/shine colors/shadow 3)
			shape [
				move (outer/3 + 0x2)
				'move 0x5
				'line -5x-5
				'line 0x1
				'line 4x4
			]
		]
	]
]