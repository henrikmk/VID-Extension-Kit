REBOL [
	Title: "Indicators for VID"
	Short: "Indicators for VID"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-indicator.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 27-Jul-2009
	Date: 27-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Various indicators (progress, LED, etc.) for VID.
	}
	History: []
	Keywords: []
]

stylize/master [
	; Common progress bar
	PROGRESS: IMAGE 100.100.100 200x16 spring [bottom] with [
		range: [0 1]
		feel: svvf/progress
		access: ctx-access/data-number
		access: make access [
			resize-face*: func [face size x y] []
		]
		font: none
		para: none
		data: 0
		bar: make system/view/vid/vid-face [
			offset: 0x0
			color: 0.80.200
			edge: font: para: none
		]
		init: [
			if image? image [
				if none? size [size: image/size]
				if size/y < 0 [size/y: size/x * image/size/y / image/size/x effect: insert copy effect 'fit]
				if color [effect: join effect ['colorize color]]
			]
			if none? size [size: 100x100]
			pane: make bar []
			pane/size: size
			either size/x > size/y [pane/size/x: 1] [pane/size/y: 1]
			if colors [color: first colors pane/color: second colors]
		]
	]

	LED: CHECK 12x12 with [
		feel: svvf/led
		set [font para] none
		colors: reduce [green red]
	]
]