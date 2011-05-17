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

do %../../build/include.r

clear ctx-vid-debug/debug

img: to-image layout/tight [box 20x20 white edge [size: 2x2 color: red]]

stylize/master [
	; test button to test states and different styles
	DRAW-BUTTON: STATE-BUTTON with [
		states: [up down left right]
		surface: 'choice
	] [
		; action sets draw body
		ctx-draw/set-draw-body face
	]
]

view make-window [
	d: drawing with [append init [draw-body/margin: 3x3 draw-body/draw-image: img]] [
		pen black
		box outer/1 outer/5 5
		box inner/1 inner/5 3
		image image-inner/1 draw-image
		image image-inner/2 draw-image
		image image-inner/3 draw-image
		image image-inner/4 draw-image
		image image-inner/5 draw-image
		image image-inner/6 draw-image
		image image-inner/7 draw-image
		image image-inner/8 draw-image
	]
	draw-button spring [top]
	draw-button spring [top]
	draw-button spring [top]
]