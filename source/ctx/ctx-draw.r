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
; [x] - test with some face to do this
; [ ] - figure out when to use set-draw-body, possibly through FEEL
; [x] - apply template to a DRAW block
; [x] - need way to set margin easily. possibly the same as setting color and skin information
;       we need to do this currently by appending to init
; [ ] - use color information in draw body as well
; [x] - use draw body as a skin
; [x] - allow loading of skin at include time
; [?] - allow loading of skin at build time
; [x] - find a way to use states to switch between images instead of draw blocks
; [x] - use set-draw-body during or after init automatically
; [ ] - bind FACE/EFFECT block to DRAW-BODY for current draw block
; [ ] - allow flexing draw between lines and no lines as the corners won't be usable for both at the same time
; [x] - create FEEL object that uses DRAW-BODY states for mouse over, up, down
; [ ] - allow over, up, down states for DRAW and substates or frames for each state. the frames are determined using the states as now.
; [ ] - determine states using set-draw-body with the FEEL object and frames using set-draw-body
; [ ] - alter BUTTON to use this new scheme
; [ ] - figure out how to pass event to set-draw-body, as FACE/STATE, FACE/STATES and FACE/DATA are normally used
; [ ] - keep states inside events mapping
; [ ] - bind during SET-SURFACE instead of inside set-draw-body, as it is less intense
; [x] - support multiple words per block. a problem is that it may be possible to confuse DRAW blocks with state blocks
; [x] - extend objects in draw body if they are already defined instead of replacing them
; [x] - return value in GET-SURFACE-FACET both on event and on face state
; [ ] - more solid indication of initial state
; [x] - debug output of event and state
b: v: none

; Surface parse rules
word-rule: none

; DRAW-BODY object
draw-body: context [
	; state
	state:				none	; Block which holds the last used states to generate this draw-body

	; draw blocks
	draw:				none	; DRAW block (none or block)
	template:			none	; DRAW block which contains the template of the face

	; fonts
	font:				none	; Font object (object)
	para:				none	; Paragraph object (object)

	; colors
	colors:				none	; object with colors from surface (object)

	; images
	draw-image:			none	; image used in DRAW block

	; sizes
	margin:				0x0		; size of the margin, i.e. distance between outer and inner limits (pair)

	; positions
	outer:				none	; the four outer corners in clock wise direction of the drawing (block)
	inner:				none	; the four inner corners in clock wise direction of the drawing (block)
	center:				0x0		; the center of the drawing (pair)
	size:				0x0		; the full size of the face (pair)
	image-outer:		none	; the four outer positions in clock wise direction of the upper left position of the image (block)
	image-inner:		none	;
	image-center:		0x0		; the position that is the upper left corner of the draw image, if centered (pair)
	vertices:			none	; points with calculation information (block of parenthesis)
	points:				none	; calcuated points with DRAW coordinates (block of pairs)
]

; creates a draw-body object
set 'make-draw-body does [
	make draw-body [
		image-inner: copy
		image-outer: copy
		inner: copy
		outer: array/initial 8 0x0
		points: copy
		vertices: make block! 100
	]
]

; returns a facet value object by state or FALSE if not found
get-facet-state: func [facet state] [
	either state [
		either in facet state [
			; Return value
			get in facet state
		][
			; When state is not found
			false
		]
	][
		; Return first facet value
		second body-of facet
	]
]

; sets the facet to a specific value or assembles an object
set-facet-value: func [facet value 'output] [
	switch/default facet [
		font para colors [
			set output make any [get output object!] value
		]
	][
		; replace value
		set output value
	]
	get output
]

; returns a value from a surface facet by state and event
get-surface-facet: func [face facet state touch see init /local end-rule depth init-word pure see-word touch-word state-word out] [
	facet: to-lit-word facet					; always a word
	touch-word: to-lit-word touch				; always a word
	state-word: to-lit-word state				; always a word
	see-word: to-lit-word see					; always a word
	init-word: either init ['init]['no-init]	; always a word
	out: none									; output value
	depth: 0
	end-rule:	[]
	value-rule:	[set value any-type! (set-facet-value facet value out) pure-rule]
	word-rule:	[[thru init-word pure: | thru state-word | thru see-word | thru touch-word] any [state-rule | word! | value-rule break]]
	depth-rule:	[(if 2 = depth: depth + 1 [end-rule: [to end]])]
	pure-rule:	[(if pure [remove/part back pure 2] pure: none)]
	state-rule:	['state into [depth-rule any [word-rule | state-rule | skip]] end-rule]
	facet-rule:	[thru facet [state-rule (end-rule: []) | pure: value-rule]]
	parse face/surface [any facet-rule]
	out
]

; determines the draw body from face surface, the data state and the touch state
set 'set-draw-body func [face /init /local debug state state-block see touch value] [
	if any [not face/draw-body empty? face/surface] [return false]
	; Gather state information
	state-block: reduce [
		state: all [in face 'state face/state]
		touch: all [in face 'touch face/touch]
		see: all [in face 'see face/see]
	]
	; Do not update, if state has not changed
	if equal? state-block face/draw-body/state [return false]
	debug: find ctx-vid-debug/debug 'draw-body
	if debug [print ["Init:" pick ["No" "Yes"] not init "State:" state "Touch:" touch "See:" see]]
	foreach facet [font para margin colors draw-image template draw] [
		; Obtain value from surface facet
		if debug [print ["Facet:" facet "for:" describe-face face]]
		value: get-surface-facet face facet state touch see init
		; Apply surface facet to draw-body facet if the value exists
		if value [
			set in face/draw-body facet
				either all [object? value object? get in face/draw-body facet] [
					make get in face/draw-body facet value
				][
					value
				]
		]
		; Apply facet value to face from surface
		switch facet [
			font para [
				if all [object? value object? get in face facet] [
					; Clone font and para objects, if they are being modified
					unless flag-face? face :facet [
						face/:facet: make face/:facet []
						flag-face face :facet
					]
					; this overwrites any changes that are done to this
					foreach word words-of value [
						set in face/:facet word value/:word
					]
				]
			]
			template [
				; Establish effect block
				unless block? face/effect [
					face/effect: reduce ['draw none 'draw none]
				]
				parse face/effect [
					thru 'draw template-blk: [none! | block!]
					thru 'draw draw-blk: [none! | block!]
				]
				; Apply template
				if value [
					change/only template-blk value
				]
			]
			draw [
				; Apply draw block
				if value [
					change/only draw-blk value
				]
			]
		]
	]
	; [!] - should be possible to update points here as well
	insert clear face/draw-body/points reduce face/draw-body/vertices
	face/draw-body/state: state-block
]

; resizes all vertices in the DRAW body
set 'resize-draw-body func [face /local fd fdo fdi fdd fdds] [
	unless all [
		fd: face/draw-body
		any [fd/template fd/draw]
	] [
		return false
	]
	fdo: fd/outer
	fdi: fd/inner
	; Determine outer positions
	fd/center: face/size / 2
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
		fdi/4 - fdds + (fdds / 2 * 0x1)			; center right
		fdi/5 - fdds							; bottom right
		fdi/6 - fdds + (fdds / 2 * 1x0) - 1x0	; bottom center
		fdi/7 - (fdds * 0x1)					; bottom left
		fdi/8 - (fdds * 0x1 / 2) + 0x1			; left center
	]
	fd/image-center: either image? fdd [face/size - fdd/size / 2][fd/center]
	insert clear fd/points reduce fd/vertices
]

]