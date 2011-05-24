base: [
	margin 2x2
]
frame: base [
	colors state [
		released away drag-away [
			shine: 240.240.240
			background: 200.200.200
			shadow: 140.140.140
		]
		pressed drag-over [
			shine: 140.140.140
			background: 100.100.100
			shadow: 240.240.240
		]
		over [
			shine: 250.250.250
			background: 210.210.210
			shadow: 150.150.150
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
	]
]
toggle: frame [
	colors state [
		on [value: green]
		off [value: black]
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
	font [align: 'left]
	para [origin: 4x2]
]
;choice: right-icon [
;	draw-image (load-stock 'arrow-pop)
;]
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
glyph: button [
	colors state [
		released away [
			value: 0.0.0
		]
		pressed drag-over [
			value: white
		]
		over [
			value: blue
		]
	]
]
arrow: glyph [
	draw [
		anti-alias on
		pen none
		fill-pen colors/value
		translate 10x10
		rotate direction
		triangle 0x-5 5x5 -5x5
	]
]
check-line: check [
	draw [image image-outer/8 draw-image]
	para [origin: 26x2] ; appears to be shared
	font state [
		released away drag-away [align: 'left style: none color: black]
		over [color: blue]
		pressed drag-over [color: white]
	]
]
radio-line: radio [
	draw [image image-outer/8 draw-image]
	para [origin: 26x2]
	font state [
		released away drag-away [align: 'left style: none color: black]
		over [color: blue]
		pressed drag-over [color: white]
	]
]