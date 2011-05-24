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
; [ ] - figure out when to use SET-DRAW-BODY, possibly through FEEL
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
; [ ] - determine states using set-draw-body with the FEEL object and frames using SET-DRAW-BODY
; [ ] - alter BUTTON to use this new scheme
; [ ] - figure out how to pass event to SET-DRAW-BODY, as FACE/STATE, FACE/STATES and FACE/DATA are normally used
; [ ] - keep states inside events mapping
; [ ] - bind during SET-SURFACE instead of inside SET-DRAW-BODY, as it is less intense
; [x] - support multiple words per block. a problem is that it may be possible to confuse DRAW blocks with state blocks
; [x] - extend objects in draw body if they are already defined instead of replacing them
; [x] - return value in GET-SURFACE-FACET both on event and on face state
; [ ] - more solid indication of initial state
; [x] - debug output of event and state
b: v: none

; Surface parse rules
word-rule: none

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
get-surface-facet: func [face facet state touch /local end-rule depth touch-word state-word out] [
	facet: to-lit-word facet			; always a word
	touch-word: to-lit-word touch		; always a word
	state-word: to-lit-word state		; always a word
	out: none							; output value
	depth: 0
	end-rule: []
	; we may no longer need the default, as the default is now specified with set-face-state
	first-state-rule:	[first-state: (touch-word: to-lit-word either word? touch [touch][first-state/1])]
	value-rule:			[set value any-type! (set-facet-value facet value out)]
	word-rule:			[[thru state-word | thru touch-word] any [state-rule | word! | value-rule break]]
	depth-rule:			[(if 2 = depth: depth + 1 [end-rule: [to end]])]
	state-rule:			['state into [first-state-rule depth-rule any [word-rule | state-rule | skip]] end-rule]
	facet-rule:			[thru facet [state-rule (end-rule: [])| value-rule]]
	parse face/surface [any facet-rule]
	out
]

; determines the draw body from face surface, the data state and the touch state
set-draw-body: func [face /local debug state touch value] [
	; Gather state information
	state: all [in face 'state word? face/state face/state]
	touch: all [in face 'touch word? face/touch face/touch]
	debug: find ctx-vid-debug/debug 'draw-body
	if debug [print ["State:" state "Touch:" touch]]
	foreach facet [font para margin colors draw-image template draw] [
		; Obtain value from surface facet
		if debug [print ["Facet:" facet "for:" describe-face face]]
		value: get-surface-facet face facet state touch
		; Apply surface facet to draw-body facet
		set in face/draw-body facet
			either all [object? value object? get in face/draw-body facet] [
				make get in face/draw-body facet value
			][
				value
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
]

; resizes all vertices in the DRAW body
resize-draw-body: func [face /local fd fdo fdi fdd fdds] [
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
	fd/vertices
]

]