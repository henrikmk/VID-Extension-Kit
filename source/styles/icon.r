REBOL [
	Title: "VID Icon Face"
	Short: "VID Icon Face"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-icon.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 23-Jul-2009
	Date: 23-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Icon Face
	}
	History: []
	Keywords: []
]

stylize/master [
	; Icon with text below it
	ICON: FACE 64x64 with [
		font: [size: 11 align: 'center valign: 'bottom]
		para: [wrap?: off]
		feel: svvf/icon
		saved-area: true
		hold: none
		color: none
		ps: none
		init: [
			if none? text [text: file]
			if none? image [image: svv/icon-image]
			hold: reduce [image file]
			image: file: none
			ps: size - 0x16  ; leave room for caption
			pane: make svv/vid-face [
				edge: make edge [size: 2x2 effect: 'bevel color: 128.128.128]
				es: edge/size * 2
				feel: svvf/subicon
				image: first hold
				file:  second hold
				size: ps - 4x0
				if image [either outside? size image/size + es [effect: 'fit][size: image/size + es]]
				offset: ps - size / 2
				;color: 0.0.80
			]
		]
	]
]