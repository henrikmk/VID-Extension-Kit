REBOL [
	Title: "VID Extension Kit Face DRAW Core"
	Short: "VID Extension Kit Face DRAW Core"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %ctx-draw.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-May-2010
	Date: 09-May-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		DRAW context for faces
	}
	History: []
	Keywords: []
]

; experimental DRAW context. this commandeers DRAW and therefore DRAW approach must be changed.

ctx-draw: context [

; [x] - method to set DRAW block for an effect
; [x] - method to change state, possibly from face/state or face/data
; [!] - method to bind DRAW blocks on layout, possibly after init, and do this only once
; [x] - never restate the DRAW blocks
; [!] - test with some face to do this
; [ ] - figure out when to use SET-DRAW-BODY, possibly through FEEL
; [ ] - apply template to a DRAW block
; [x] - need way to set margin easily. possibly the same as setting color and skin information
;       we need to do this currently by appending to init
; [ ] - use color information in draw body as well
; [x] - use draw body as a skin
; [x] - allow loading of skin at include time
; [?] - allow loading of skin at build time
; [ ] - find a way to use states to switch between images instead of draw blocks
; [x] - use set-draw-body during or after init automatically
; [ ] - bind FACE/EFFECT block to DRAW-BODY for current draw block
; [ ] - allow flexing 

; determines the draw body from the state of the face
set-draw-body: func [face /local new-draw-blk state] [
	; Find the correct state
	state: case [
		in face 'states [face/states/1]
		in face 'state [face/state]
		true [face/data]
	]
	; Find new draw block
	new-draw-blk:
		case [
			none? face/draw-body/draw [
				none
			]
			parse face/draw-body/draw [any [word! block!]] [
				select face/draw-body/draw state
			]
			block? face/draw-body/draw [
				face/draw-body/draw
			]
		]
	; Establish effect block
	unless block? face/effect [
		face/effect: reduce ['draw none 'draw none]
	]
	parse face/effect [thru 'draw template-blk: [none! | block!] thru 'draw draw-blk: [none! | block!]]
	; Apply template
	if face/draw-body/template [
		change/only template-blk face/draw-body/template
	]
	; Apply draw block
	if new-draw-blk [
		change/only draw-blk new-draw-blk
	]
	; Apply font and para changes
	foreach type [font para] [
		if get in face/draw-body type [
			foreach [word value] get in face/draw-body type [
				set in get in face type word value
			]
		]
	]
]

; binds draw body vertices to drawing. do this every time the FACE/DRAW-BODY/DRAW block changes
bind-draw-body: func [face] [
	if face/draw-body/template [
		bind face/draw-body/template face/draw-body
	]
	if face/draw-body/draw [
		bind face/draw-body/draw face/draw-body
	]
]

; resizes all vertices in the DRAW body
resize-draw-body: func [face /local fd fdo fdi] [
	any [fd: face/draw-body return none]
	fdo: fd/outer
	fdi: fd/inner
	; Determine outer positions
	fd/center: face/size - 1 / 2
	insert clear fdo reduce [
		0x0										; top left
		fd/center * 1x0 - 0x1					; top center
		face/size * 1x0							; top right
		face/size - (fd/center * 0x1)			; center right
		face/size								; bottom right
		face/size - (fd/center * 1x0)			; bottom center
		face/size * 0x1							; bottom left
		fd/center * 0x1							; center left
	]
	; Determine inner positions
	insert clear fdi reduce [
		fd/margin								; top left
		fdo/2 + (fd/margin * 0x1)				; top center
		fdo/3 + (fd/margin * -1x1)				; top right
		fdo/4 - (fd/margin * 1x0)				; center right
		fdo/5 - fd/margin						; bottom right
		fdo/6 - (fd/margin * 0x1)				; bottom center
		fdo/7 + (fd/margin * 1x-1)				; bottom left
		fdo/8 + (fd/margin * 1x0)				; center left
	]
	; Determine image positions
	fdd: fd/draw-image
	fdds: either image? fdd [fdd/size][0x0]
	insert clear fd/image-outer reduce [
		fdo/1									; top left
		fdo/2 - (fdds * 1x0 / 2) + 1			; top center
		fdo/3 - (fdds * 1x0)					; top right
		fdo/4 - fdds + (fdds / 2 * 0x1) - 0x1	; center right
		fdo/5 - fdds							; bottom right
		fdo/6 - fdds + (fdds / 2 * 1x0) - 1x0	; bottom center
		fdo/7 - (fdds * 0x1)					; bottom left
		fdo/8 - (fdds * 0x1 / 2) + 0x1			; left center
	]
	insert clear fd/image-inner reduce [
		fdi/1									; top left
		fdi/2 - (fdds * 1x0 / 2) + 1			; top center
		fdi/3 - (fdds * 1x0)					; top right
		fdi/4 - fdds + (fdds / 2 * 0x1) - 0x1	; center right
		fdi/5 - fdds							; bottom right
		fdi/6 - fdds + (fdds / 2 * 1x0) - 1x0	; bottom center
		fdi/7 - (fdds * 0x1)					; bottom left
		fdi/8 - (fdds * 0x1 / 2) + 0x1			; left center
	]
	fd/image-center: either image? fdd [face/size - 1 - fdd/size / 2][fd/center]
	; go through all vertices for spring information
	face/draw-body/vertices
]

]