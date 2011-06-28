REBOL [
	Title: "Balancers and Resizers"
	Short: "Balancers and Resizers"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %balance.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-Aug-2009
	Date: 09-Aug-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Internal resize and balance styles for VID
	}
	History: []
	Keywords: []
]

stylize/master [
	; resizes the element before and after the balancer
	BALANCER: FACE with [
		color: none
		surface: 'drag-frame
		size: 100x100
		axis: none ; dragging direction
		before-face: after-face: none
		before: func [face diff /local axis f new-size] [
			;-- resize the element before this one
			before-face: f: back-face face
			axis: face/axis
			if any [none? f f = face] [exit] ; nothing to resize
			new-size: any [f/real-size f/size]
			new-size/:axis: new-size/:axis + diff/:axis
			resize/no-springs/no-show f new-size f/offset
		]
		after: func [face diff /local axis f new-size] [
			; resize the element after this one
			after-face: f: next-face face
			if any [none? f f = face] [exit] ; nothing to resize
			new-size: any [f/real-size f/size]
			axis: face/axis
			new-size/:axis: new-size/:axis - diff/:axis
			f/offset/:axis: f/offset/:axis + diff/:axis
			f/win-offset/:axis: f/win-offset/:axis + diff/:axis
			resize/no-springs/no-show f new-size f/offset
		]
		feel: svvf/balancer
		bar-size: 6
		access: make access [
			resize-face*: func [face size x y /local axis f] [
				f: back-face face
				case [
					;-- vertical layout
					f/offset/x = face/offset/x [
						axis: face/axis: 'y
						face/spring: [bottom] ; this fails at resizing
					]
					;-- horizontal layout
					f/offset/y = face/offset/y [
						axis: face/axis: 'x
						face/spring: [right]
					]
				]
				face/size: f/size
				face/size/:axis: face/bar-size
				resize-draw-body face
			]
		]
		init: [
			size: to-pair bar-size
;			insert-actor-func self 'on-align :set-direction
		]
	]
	; resizes the element before and pushes or pulls all elements after resizer
	RESIZER: BALANCER with [
		after: func [face diff /local axis faces] [
			; push or pull all elements after this one
			faces: next find face/parent-face/pane face
			if tail? faces [exit] ; nothing to push
			axis: face/axis
			foreach f faces [
				f/offset/:axis: f/offset/:axis + diff/:axis
				f/win-offset/:axis: f/win-offset/:axis + diff/:axis
				; resize faces that have a horizontal or vertical spring attached
				; we don't usually have this problem in resize as it always resizes from the right corner
				; and then the resizing would cause the offset to never move
				; but here, we must specify a new offset too
				; need to get tab-face here
			]
		]
		feel: svvf/resizer
	]
]