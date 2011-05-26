REBOL [
	Title: "DRAWING Test"
	Short: "DRAWING Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %drawing.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-Jun-2010
	Date: 26-Jun-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test the DRAWING style
	}
	History: []
	Keywords: []
]

; arrow-down problem here

do %../../build/include.r

clear ctx-vid-debug/debug

img: to-image layout/tight [box 20x20 white edge [size: 2x2 color: red]]

make-surface/parent 'draw-test [
	font:	[align: 'right]
	draw:	[
		up [
			pen none
			fill-pen black
			translate 10x10
			rotate -90
			triangle -5x-5 3x3 -5x12
		]
		down [
			pen none
			fill-pen black
			translate 10x10
			triangle -5x-5 3x3 -5x12
		]
		left [
			pen none
			fill-pen black
			translate 10x10
			rotate -180
			triangle -5x-5 3x3 -5x12
		]
		right [
			pen none
			fill-pen black
			translate 10x10
			rotate 90
			triangle -5x-5 3x3 -5x12
		]
	]
] 'frame

stylize/master [
	; test button to test states and different styles
	DRAW-BUTTON: STATE-BUTTON with [
		states: [up down left right]
		surface: 'draw-test
	] [
		; action sets draw body
		set-draw-body face
	]
]

view make-window [
	d: drawing with [append init [draw-body/margin: 3x3 draw-body/draw-image: img]] [
		pen none
		fill-pen blue
		box outer/1 outer/5 5
		fill-pen yellow
		box inner/1 inner/5 3
		image image-outer/1 draw-image
		image image-outer/2 draw-image
		image image-outer/3 draw-image
		image image-outer/4 draw-image
		image image-outer/5 draw-image
		image image-outer/6 draw-image
		image image-outer/7 draw-image
		image image-outer/8 draw-image
	]
	draw-button spring [top]
	draw-button spring [top]
	draw-button spring [top]
]