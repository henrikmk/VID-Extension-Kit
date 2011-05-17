base: [
	margin:		2x2
]
frame: base [
	template:	none ; draw block here?
]
right-icon: frame [
	draw:		[image image-inner/4 draw-image]
]
choice: right-icon [
	draw-image:	load-stock 'arrow-pop
]