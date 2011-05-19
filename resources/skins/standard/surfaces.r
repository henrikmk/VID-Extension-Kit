base: [
	margin: 2x2
]
frame: base [
	colors: (
		up alt-up [
			shine: 240.240.240
			background: 200.200.200
			shadow: 140.140.140
		]
		down alt-down [
			shine: 140.140.140
			background: 100.100.100
			shadow: 240.240.240
		]
		; need some kind of drag event
	)
	template: [
		anti-alias off
		pen none
		fill-pen colors/shine
		polygon outer/1 outer/3 inner/3 inner/7 outer/7 outer/1
		fill-pen colors/shadow
		polygon outer/3 outer/5 outer/7 inner/7 inner/3 outer/3
		fill-pen colors/background
		box inner/1 inner/5 1
	]
	font: (
		up alt-up away [color: black]
		over [color: blue]
		down alt-down [color: white]
	)
]
toggle: frame [
	colors: (
		on [action: green]
		off [action: black]
	)
	draw: [
		anti-alias off
		pen none
		fill-pen colors/shine
		triangle 12x2 2x12 2x2
		fill-pen colors/shadow
		triangle 11x2 2x11 2x2
		fill-pen colors/action
		triangle 10x2 2x10 2x2
	]
]
right-icon: frame [
	draw:		[image image-inner/4 draw-image]
	font:		[align: 'left]
	para:		[origin: 4x2]
]
choice: right-icon [
	draw-image:	load-stock 'arrow-pop
]
tab: base [
	draw: (
		inactive [
			
		]
		active [
			
		]
	)
]