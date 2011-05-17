base: [
	margin:		2x2
]
frame: base [
	template:	[
		pen none
		fill-pen black
		box outer/1 outer/5 2
		fill-pen linear inner/1 inner/1/y inner/5/y 90 1 1 220.220.220 200.200.200 180.180.180
		box inner/1 inner/5 1
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
	draw:		[
		inactive [
			
		]
		active [
			
		]
	]
]