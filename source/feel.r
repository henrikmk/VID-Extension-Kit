REBOL [
	Title:  "REBOL/View: Visual Interface Dialect - Feelings"
	Author: "Carl Sassenrath"
	Rights: "Copyright 2000-2005 REBOL Technologies. All rights reserved."
	License: {
		Users can freely modify and publish this code under the condition that it is
		executed only with languages from REBOL Technologies, and user must include this
		header as is. All changes may be freely included by other users in their software
		(even commercial uses) as long as they abide by these conditions.
	}
	; You are free to use, modify, and distribute this software with any
	; REBOL Technologies products as long as the above header, copyright,
	; and this comment remain intact. This software is provided "as is"
	; and without warranties of any kind. In no event shall the owners or
	; contributors be liable for any damages of any kind, even if advised
	; of the possibility of such damage. See license for more information.

	; Please help us to improve this software by contributing changes and
	; fixes via http://www.rebol.com/feedback.html - Thanks!
]

svvf: system/view/vid/vid-feel: context [

	; state: for buttons that act on UP
	; data: user state for button

	sensor: make face/feel [
		cue: blink: none
		engage: func [face action event][
			face/event: action
			switch action [
				time [unless face/state [face/blinker: not face/blinker act-face face event 'on-time]]
				down [face/state: on]
				alt-down [face/state: on]
				up   [if face/state [do-face face face/text act-face face event 'on-click] face/state: off]
				alt-up [if face/state [do-face-alt face face/text act-face face event 'on-alt-click] face/state: off]
				over [face/state: on]
				away [face/state: off]
			]
			; state and event is used here to manage state of button, but we do not set draw-body here
			cue face action
			show face
		]
	]

	hot: make sensor [
		over: func [face action event][
			face/event: pick [over away] action
			show face
			;if all [face/font face/font/colors][
			;	face/font/color: pick face/font/colors not action
			;	show face
			;	face/font/color: first face/font/colors
			;]
		]
;		cue: func [face action][
;			if all [face/font face/font/colors][face/font/color: pick face/font/colors not face/state]
;		]
	]

	hot-area: make hot [
		over: func [face action event][
			if face/colors [
				face/color: pick face/colors not action
				show face
				face/color: first face/colors
			]
		]
		cue: none
	]

	reset-related-faces: func [face][
		if face/related [
			foreach item face/parent-face/pane [
				if all [
					item/related
					item/related = face/related
					item/data
				][
					;item/data: false
					clear-face item
					show item
				]
			]
		]
	]

	check: make sensor [
		over: none
		redraw: func [face act pos][
			act: pick face/images (to integer! face/data) + either face/hover [5] [1 + (2 * to integer! face/state)]
			set-image either face/pane [face/pane][face] act
		]
		engage: func [face action event][
			if action = 'down [
				reset-related-faces face
				do-face face face/data: not face/data
				act-face face event 'on-click
				show face
			]
		]
	]

	check-radio: make face/feel [
		redraw: func [face act pos][
			act: pick face/images (to integer! face/data) + either face/hover [5][
				1 + (2 * to integer! face/state)
			]
			set-image either face/pane [face/pane][face] act
		]
		over: func [face over offset][
			face/hover: over
			show face
			face/hover: off
		]
		engage: func [face action event][
			switch action [
				down [face/state: on]
				alt-down [face/state: on]
				up [
					if face/state [
						face/state: off
						reset-related-faces face
						do-face face face/data: not face/data
						act-face face event 'on-click
					]
				]
				alt-up [
					if face/state [
						do-face-alt face face/text
						act-face face event 'on-alt-click
					]
					face/state: off
				]
				over [face/state: on]
				away [face/state: off]
			]
			;cue face action
			show face
		]
	]

	led: make sensor [
		over: none
		redraw: func [face act pos][face/color: either face/data [face/colors/1][face/colors/2]]
		engage: func [face action event][
			if any [action = 'time all [action = 'down get in face 'action]][do-face face face/data: not face/data]
			show face
		]
	]

	button: make hot [
		redraw: func [face act pos] [
			if act = 'draw [
				ctx-draw/set-draw-body face
			]
		]
		cue: none
	]

	;btn: make button [
	;	over: func [face act evt][
	;		remove/part find face/effect 'mix 2
	;		if act [
	;			evt: any [find face/effect 'extend tail face/effect]
	;			insert evt reduce ['mix face/images/3]
	;		]
	;		all [face/show? show face]
	;	]
	;	engage: func [face action event][
	;		remove/part find face/effect 'mix 2
	;		switch action [
	;			down		[face/state: on]
	;			alt-down	[face/state: on]
	;			up			[if face/state [do-face face face/text act-face face event 'on-click] face/state: off]
	;			alt-up		[if face/state [do-face-alt face face/text act-face face event 'on-alt-click] face/state: off]
	;			over		[face/state: on]
	;			away		[face/state: off]
	;		]
	;		cue face action
	;		all [face/show? show face]
	;	]
	;]

	icon: make hot [
		redraw: func [face act pos /local state] [
			if face/pane/edge [face/pane/edge/effect: pick [ibevel bevel] face/state]
		]
		cue: none
	]

	subicon: make hot [
		over: func [f a e] [f/parent-face/feel/over f/parent-face a e]
		engage: func [f a e] [f/parent-face/feel/engage f/parent-face a e]
		redraw: func [f a c] [f/parent-face/feel/redraw f/parent-face a c]
	]

	toggle: make button [
		engage: func [face action event][
			face/event: action
			if find [down alt-down] action [
				if face/related [
					foreach item face/parent-face/pane [
						if all [
							any [all [in face 'keep face/keep] face <> item]
							flag-face? item toggle
							item/related
							item/related = face/related
							item/data
						][
							item/data: item/state: false
							show item
						]
					]
				]
				face/data: face/state: not face/state
				either action = 'down [
					do-face face face/data
					act-face face event 'on-click
				][
					do-face-alt face face/data
					act-face face event 'on-alt-click
				]
				show face
			]
		]
	]

	state: make button [
		engage: func [face action event][
			if find [down alt-down] action [
				face/state: on
				face/states: head face/states
				face/data: select face/states face/data
				if none? face/data [face/data: pick face/states not to-logic face/virgin]
				face/states: find face/states face/data
				either action = 'down [
					do-face face face/data
					act-face face event 'on-click
				][
					do-face-alt face face/data
					act-face face event 'on-alt-click
				]
				show face
			]
			if find [up alt-up] action [
				face/state: off
			]
		]
	]

	;tog: make btn [
	;	engage: get in toggle 'engage
	;]

	rotary: make hot [
		redraw: func [face act pos] [
			; not working
			face/text: face/data/2
			if face/edge [face/edge/effect: pick [ibezel bezel] face/state]
			if face/colors [face/color: any [pick face/colors index? face/data face/color]]
			if face/effects [face/effect: pick face/effects not face/state]
		]
		next-face: func [face][
			face/data: either tail? skip face/data 2 [head face/data] [skip face/data 2]
		]
		back-face: func [face][
			face/data: either head? face/data [skip tail face/data -2] [skip face/data -2]
		]
		engage: func [face action event /local do-it down-it][
			do-it: [if face/state [do-face face face/data/1] face/state: off]
			down-it: [unless face/state [next-face face] face/state: on]
			switch action [
				down down-it
				up do-it
				alt-down [
					unless face/state [back-face face] face/state: on
					act-face face event 'on-click ; not sure about this
				]
				alt-up do-it
				over down-it
				away [if face/state [back-face face] face/state: off]
			]
			show face
		]
	]

	choice: make hot [
		;engage: func [face action event][
		;	if action = 'down [
		;		; needs to support a different data format
		;		; so the list should be drawn here using the different data format
		;		; which is word string word string
		;		; alternatively, we need a different function for this
		;		; we need to change the choose function
		;		; the choose function should be different in that a real window should pop up here
		;		; generate the layout with a pop-menu style
        ;
		;		choose/style/window extract/index face/data 2 2 func [face parent][
		;			; do this differently
		;			parent/data: find parent/texts face/text
		;			do-face parent parent/text: face/text
		;			act-face face event 'on-click
		;		] face
		;		; this has to be screen-face instead and with other options here
		;		; if I use screen-face now, the face will be displayed as a root window
		;		; the offset will however be relative to the screen and not the face
		;		; so that offset must be set in the 'choose function
		;		; it also means the face we are passing is probably not correct, or even necessary to pass
		;		; it's also only used once, but that means we have to work on the design of the 'choose function
		;		 face/parent-face
		;	]
		;	show face
		;]
		engage: func [face action event] [
			if action = 'down [
				; [x] - generate the poplist during init.
				; [x] - or re-show it, if it already exists. doing that during init.
				; [x] - LIST is used
				; [x] - LIST pixel height is 24
				; [ ] - different schemes can be used to do a win32 and OSX style choice list
				; [x] - perform select
				; [x] - filter out the words
				; [x] - close menu-face on select
				; [x] - fix setup to not form content for list somehow
				; [x] - set-face choice face on select
				; [x] - perform align of choice-face
				; [x] - perform resize of choice-face, if needed and possible
				; [ ] - face/setup needs to store in data
				; [x] - show correct text in popup button
				; [x] - color for hovering
				; [ ] - mouse push nudge to get the right item as a supplement to scrolling
				; [ ] - visible arrow for out of bounds parts
				; [x] - keyface control for menu-face to control the list internally, but this is specific to list
				; [ ] - keyface control allows moving the list
				; [ ] - keyface control to open the list
				; [ ] - move function to standardized setup
				; [x] - start selection on the opened selection rather than the first selection, but this is specific to list
				; [ ] - size is 4x4 too far out, when the height is set to 100x20
				face/open-choice-face face
			]
		]
	]

	choice-iterator: make face/feel [
		over: func [face state] [
			face/selected: all [face/selectable state]
			show face
		]
		engage: func [face act event] [
			if event/type = 'down [
				if all [face/selected face/selectable] [
					do-face face face/pane-parent
					act-face face event 'on-click
				]
				hide-popup
			]
			show face
		]
	]

;-- New slider and scroller code:

	drag-off: func [bar drag val /local bmax ax][
		val: val - bar/clip
		bmax: bar/size - drag/size - (2 * bar/edge/size) - (2 * bar/clip)
		val: max 0x0 min val bmax
		ax: bar/axis
		drag/offset: val/:ax + bar/clip/:ax * 0x1
		if ax = 'x [drag/offset: reverse drag/offset]
		if positive? bmax/:ax [bar/data: val/:ax / bmax/:ax]
		do-face bar none
	]

	drag-action: func [face action event] [
		if find [over away] action [
			drag-off face/parent-face face face/offset + event/offset - face/data
			show face
		]
		if find [down alt-down] action [face/data: event/offset]
	]

	drag-release-action: func [face action event] [
		if find [up alt-up] action [
			face/parent-face/redrag face/parent-face/ratio
			show face/parent-face ; parent for drag position as well
		]
	]

	drag: make face/feel [
		engage: :drag-action
	]

	scroller-drag: make drag [
		engage: func [face action event][
			drag-action face action event
			drag-release-action face action event
		]
	]

	slide: make face/feel [
		redraw: func [face act pos][
			face/data: max 0 min 1 face/data
			if face/data <> face/state [
				pos: face/size - face/pane/1/size - (2 * face/edge/size) - (2 * face/clip)
				either face/size/x > face/size/y [face/pane/1/offset/x: face/data * pos/x + face/clip/x][
					face/pane/1/offset/y: face/data * pos/y + face/clip/y]
				face/state: face/data
				; RAMBO #3407
				if act = 'draw [show face/pane/1]
			]
		]
		engage: func [face action event][
			if action = 'down [
				drag-off face face/pane/1 event/offset - (face/pane/1/size / 2)
				act-face face event 'on-click
				show face
			]
		]
	]

	set 'scroll-drag func [
		"Move the scroller drag bar"
		face	"the scroller to modify"
		/back	"move backward"
		/page	"move each time by one page"
	][
		any [
			all [back page move-drag face/pane/2 face/page]
			all [back move-drag face/pane/2 face/step]
			all [page move-drag face/pane/3 face/page]
			move-drag face/pane/3 face/step
		]
	]

	move-drag: func [face val][
		face/parent-face/data: min 1 max 0 face/parent-face/data + (face/dir * val)
		do-face face/parent-face none
		show face/parent-face
	]

	scroll: make slide [
		engage: func [f act evt /local tmp][
			if act = 'down [
				tmp: f/axis
				do-face pick reduce [f/pane/3 f/pane/2] evt/offset/:tmp > f/pane/1/offset/:tmp f/page
			]
		]
	]

	scroll-button: make button [
		engage: func [f act evt][
			switch act [
				down	[f/state: on do-face f f/parent-face/step f/rate: 4]
				up		[f/state: flag: no f/rate: none]
				time	[either flag [either f/rate <> f/parent-face/speed [f/rate: f/parent-face/speed][do-face f f/parent-face/step]][flag: on exit]]
				over	[f/state: on if flag [f/rate: f/parent-face/speed]]
				away	[f/state: no f/rate: none]; set-col f 2]
			]
			cue f act
			show f
		]
		flag: no
	]

;-------- Balancer and Resizer

	balancer: make face/feel [
		old-offset: none
		; limit the movement of the face
		real-face?: func [face new-face] [
			all [
				object? face
				object? new-face
				face <> new-face
				any [
					not in new-face 'style
					new-face/style <> 'highlight
				]
			]
		]
		lower-limit: func [face pos /local bf] [
			; restrict left panel edge or left back face edge
			pos: max 0x0 pos
			bf: back-face face
			if real-face? face bf [pos: max pos bf/offset] ; this causes trouble
			pos
		]
		upper-limit: func [face pos /local nf] [
			; restrict right panel edge or right next face edge
			pos: min face/parent-face/size pos
			nf: next-face face
			if real-face? face nf [pos: min pos nf/size + nf/offset - face/size]
			pos
		]
		engage: func [face act event /local axis tmp] [
			axis: face/axis
			case [
				act = 'down [
					old-offset: face/offset
				]
				; pose limit on offset
				find [away over up] act [
					tmp: face/offset + event/offset
					tmp: lower-limit face tmp
					tmp: upper-limit face tmp
					if tmp/:axis = face/offset/:axis [exit]
					face/offset/:axis: tmp/:axis
					face/before face face/offset - old-offset ; perform resize/move before this face
					face/after face face/offset - old-offset ; perform resize/move after this face
					old-offset: face/offset
					set-tab-face get in root-face face 'tab-face
					do-face face none
					act-face face event 'on-click
				]
			]
			show face/parent-face
		]
	]

	resizer: make balancer [
		; pass upper limit through with only parent-face size as restriction
		upper-limit: func [face pos] [
			min face/parent-face/size - face/size pos
		]
	]

;------- Window Management

	window-manage: make face/feel [
		focus-ring-faces: none
		;-- For window bar dragging
		drag-action: func [face event old-offset /local diff] [
			if face/parent-face/original-size [exit]
			diff: face/parent-face/offset
			face/parent-face/offset: face/parent-face/offset + event/offset - old-offset
			face/parent-face/offset/y:
				min
					(face/parent-face/parent-face/size/y - face/size/y - second edge-size face/parent-face)
					max 0 face/parent-face/offset/y
			diff: face/parent-face/offset - diff
			show face/parent-face
			;-- move focus ring
			if face/tab-face [
				foreach fc focus-ring-faces [
					fc/offset: fc/offset + diff
				]
				show focus-ring-faces
			]
		]
		engage: func [face action event] [
			switch action [
				down [
					; [ ] - click to make active
					; [ ] - when active, others go inactive, possibly through disable
					; [ ] - activate drag
					old-offset: event/offset ; [!] - seems not local?
					face/action face get-face face
					;-- if tab face is inside this face, move it along
					face/tab-face: get-tab-face face
					either all [face/tab-face within-face? face/tab-face face/parent-face] [
						focus-ring-faces: get in root-face face 'focus-ring-faces
					][
						face/tab-face: none
					]
				]
				up [
					face/tab-face: none
				]
			]
			if find [over away] action [
				drag-action face event old-offset
			]
		]
	]

	window-resizer: make window-manage [
		;-- For window corner resizing
		drag-action: func [face event old-offset /local diff fpp new-size] [
			fpp: face/parent-face/parent-face
			if face/parent-face/parent-face/original-size [exit]
			new-size: max 100x100 fpp/size + event/offset - old-offset
			if new-size <> fpp/size [
				resize/no-springs/no-show fpp new-size fpp/offset
			]
			show fpp/parent-face
			;-- move focus ring
			;if face/tab-face [
			;	foreach fc face/parent-face/focus-ring-faces [
			;		fc/offset: fc/offset + diff
			;	]
			;	show face/parent-face/focus-ring-faces
			;]
		]
	]

;-------

	progress: make face/feel [
		redraw: func [face act pos][
			face/data: max 0 min 1 face/data
			if face/data <> face/state [
				either face/size/x > face/size/y [
					face/pane/size/x: max 1 face/data * face/size/x
				][
					face/pane/size/y: max 1 face/data * face/size/y
					face/pane/offset: face/size - face/pane/size
				]
				face/state: face/data
				; RAMBO #3407
				if act = 'draw [show face/pane]
			]
		]
	]

	dropdown: make face/feel [
		over: redraw: detect: none
		engage: func [face action event][
			switch action [
				down [face/state: on act-face face event 'on-click]
				up [if face/state [face/show-dropdown] face/state: off]
				over [face/state: on]
				away [face/state: off]
			]
			show face
		]
	]

]

;-- Standard Accessor Functions

setup-face: func [
	"Sets up a face construct"
	face
	value
	/no-show "Do not show change yet"
	/local access show?
][
	if all [
		access: get in face 'access
		in access 'setup-face*
	][
		access/setup-face* face value
		act-face face none 'on-setup
	]
	any [no-show show face]
	face
]

set-face: func [
	"Sets the primary value of a face. Returns face object (for show)."
	face
	value
	/no-show "Do not show change yet"
	/local access
][
	if all [
		access: get in face 'access
		in access 'set-face*
	][
		access/set-face* face value
		act-face face none 'on-set
	]
	any [no-show show face]
	face
]

get-face: func [
	"Returns the primary value of a face."
	face [object!]
	/local access
][
	if all [
		access: get in face 'access
		in access 'get-face*
	][
		access/get-face* face
	]
]

clear-face: func [
	"Clears the primary value of a face."
	face
	/no-show "Do not show change yet"
	/local access
][
	if all [
		access: get in face 'access
		in access 'clear-face*
	][
		access/clear-face* face
		act-face face none 'on-clear
	]
	any [no-show show face]
	face
]

reset-face: func [
	"Resets the primary value of a face."
	face
	/no-show "Do not show change yet"
	/local access
][
	if all [
		access: get in face 'access
		in access 'reset-face*
	][
		access/reset-face* face
		act-face face none 'on-reset
	]
	any [no-show show face]
	face
]

search-face: func [
	"Searches the contents of a face for a value."
	face
	value
	/no-show "Do not show change yet"
	/local access
][
	if all [
		access: get in face 'access
		in access 'search-face*
	][
		access/search-face* face value
		act-face face none 'on-search
	]
	any [no-show show face]
	face
]

attach-face: func [
	"Attaches the first face to the second, specifying what to do and when."
	from-face "Face to act with"
	to-face "Face to act on"
	what [word!] "What to act with"
	when [word! block!] "When to act"
] [
	what ; word, a facet of the from-face
	when ; on-*
	from-face ; the face we want to act with
	to-face ; the face we want to act on

	get in from-face what
	; problems:
		; accessors use various arguments, so we'd have to formalize this process.
]

scroll-face: func [
	"Scrolls a face according to scroll values."
	face
	x-value [number! none!] "Value between 0 and 1"
	y-value [number! none!] "Value between 0 and 1"
	/step "x and y values are multiples of face step size instead of absolutes"
	; the step size should not be a multiple of the scroller size, but rather the scroller proportions
	; the scroller proportions are calculated by the face that we are supposed to scroll
	; so we need a formal arrangement like that between the scroller and the scroll face, which I think we already have parts of
	/no-show "Do not show changes yet."
	/local access show? scroll
] [
	; this is too complex and get-offset* is not used
	if all [
		access: get in face 'access
		in access 'scroll-face*
	] [
		if all [
			step
			in access 'get-offset*
		] [
			if all [x-value not zero? x-value] [
				x-value:
					max 0 min 1
						(face/scroll/step-unit face) *
						x-value +
						access/get-offset* face 'x
			]
			if all [y-value not zero? y-value] [
				y-value:
					max 0 min 1
						(face/scroll/step-unit face) *
						y-value +
						access/get-offset* face 'y
			]
		]
		set/any 'show? access/scroll-face* face x-value y-value
		act-face face none 'on-scroll
		if value? 'show? [no-show: not show?]
	]
	any [no-show show face]
	face
]

resize-face: func [
	"Resize a face."
	face
	size [number! pair!]
	/x "Resize only width"
	/y "Resize only height"
	/no-show "Do not show change yet"
	/local access
][
	if all [
		access: get in face 'access
		in access 'resize-face*
	][
		access/resize-face* face size x y
		act-face face none 'on-resize
	]
	any [no-show show face]
	face
]

move-face: func [
	"Move a face."
	face
	offset [number! pair!]
	size
	/scale "Keeps the lower right corner at the original position"
	/no-show "Do not show change yet"
] [
	face/offset: face/offset + offset
	if scale [
		resize/no-show face face/size face/size - offset
	]
	any [no-show show face]
	face
]

set 'enable-face func [
	"Enables a face or a panel of faces with TABBED flag."
	face
	/no-show "Do not show change yet."
	/local flags
] [
	either any [
		flag-face? face panel
		flag-face? face compound
	] [
		deflag-face face disabled
		if flag-face? face detabbed [
			deflag-face face detabbed
			flag-face face tabbed
		]
		traverse-face face [enable-face/no-show face]
	][
		; [ ] - fix font problem due to not being able to refresh this face if a previous one was disabled, and this one stayed enabled
		if flag-face? face disabled [
			deflag-face face disabled
			if flag-face? face detabbed [
				deflag-face face detabbed
				flag-face face tabbed
			]
			restore-feel face
			restore-font face
			either all [
				in face 'access
				in face/access 'enable-face*
			] [
				face/access/enable-face* face
			][
;				if flag-face? face disabled [
					remove/part
						find/reverse
							tail face/effect
							first disabled-effect
						length? disabled-effect
;				]
			]
		]
	]
	any [no-show show face]
]

enable-face: func [
	"Enables a face or a panel of faces with DISABLED flag."
	face
	/no-show "Do not show change yet."
	/local flags
] [
	; [ ] - fix font problem due to not being able to refresh this face if a previous one was disabled, and this one stayed enabled
	if flag-face? face disabled [
		deflag-face face disabled
		if flag-face? face detabbed [
			deflag-face face detabbed
			flag-face face tabbed
		]
		restore-feel face
		restore-font face
		either all [
			in face 'access
			in face/access 'enable-face*
		] [
			face/access/enable-face* face
		][
;			if flag-face? face disabled [
				remove/part
					find/reverse
						tail face/effect
						first disabled-effect
					length? disabled-effect
;			]
		]
		act-face face none 'on-enable
	]
	if any [
		flag-face? face panel
		flag-face? face compound
	] [
		traverse-face face [enable-face/no-show face]
	]
	any [no-show show face]
]

disable-face: func [
	"Disables a face or a panel of faces with ACTION flag."
	face [object!]
	/no-show "Do not show change yet."
] [
	if same? face get-tab-face face [
		validate-face face
		unfocus face
		; [!] - if the face is disabled, where do we move the tab face to?
	]
	;-- Disable current face
	if all [
		not flag-face? face disabled
		flag-face? face action
	] [
		if flag-face? face tabbed [
			deflag-face face tabbed
			flag-face face detabbed
		]
		flag-face face disabled
;			unless in face 'saved-feel [print dump-obj face]
		save-feel face make face/feel [over: engage: detect: none] ; don't touch redraw
		save-font face make face/font []
		either all [
			in face 'access
			in face/access 'disable-face*
		] [
			face/access/disable-face* face
		][
			either block? face/effect [
				append face/effect copy disabled-effect
			][
				face/effect: copy disabled-effect
			]
		]
		act-face face none 'on-disable
	]
	;-- Disable any faces in panes
	if any [
		flag-face? face panel
		flag-face? face compound
	] [
		traverse-face face [disable-face/no-show face] ; does traverse-face fail on an empty panel?
	]
	any [no-show show face]
]

;-- Actor Functions:

insert-actor-func: func [face actor fn] [
	if in face 'actors [
		if none? get in face/actors actor [
			face/actors/:actor: make block! []
		]
		insert/only tail face/actors/:actor :fn
	]
]

remove-actor-func: func [face actor fn /local act] [
	if in face 'actors [
		any [
			none? act: get in face/actors actor
			remove find act :fn
		]
	]
]

act-face: func [[catch] face event actor] [
	unless in face 'actors [
		throw make error! join "Actors do not exist for " describe-face face
	]
	unless find first face/actors actor [
		throw make error! reform ["Actor" actor "not found"]
	]
	if find ctx-vid-debug/debug 'actor [
		print ["Face:" describe-face face]
		print ["Actor:" actor]
	]
	;-- run through the block here for each actor function
	if block? get in face/actors actor [
		foreach act get in face/actors actor [
			act face get-face face event actor ; face, value, event and actor
		]
	]
	;do get in get in face 'actors actor face get-face face event actor ; face, value, event and actor
]

;-- Default Accessors:

ctx-access: context [

	data: context [ ; Default accessor
		set-face*: func [face value][face/data: value]
		get-face*: func [face][face/data]
		clear-face*:
		reset-face*: func [face][set-face* face false]
	]

	data-default: make data [ ; Data with default value
		reset-face*: func [face][set-face* face face/default]
	]

	data-state: make data [ ; e.g. toggle
		set-face*: func [face value][face/data: face/state: value]
	]

	data-number: make data [ ; e.g. slider
		set-face*: func [face value][
			unless number? value [
				make error! reform [face/style "must be set to a number"]
			]
			face/data: value
		]
		clear-face*:
		reset-face*: func [face][face/data: 0]
	]

	data-find: context [
		set-face*: func [face value][
			all [series? face/data value: find head face/data value face/data: value]
		]
		get-face*: func [face][all [series? face/data face/data/1]]
		clear-face*:
		reset-face*: func [face][all [series? face/data face/data: head face/data]]
	]

	data-pick: context [
		set-face*: func [face value][
			all [in face 'picked insert clear head face/picked value]
		]
		get-face*: func [face][get in face 'picked]
		clear-face*:
		reset-face*: func [face][all [in face 'picked clear face/picked]]
	]

	text: context [
		set-face*: func [face value][
			face/text: value
			face/line-list: none
		]
		get-face*: func [face][face/text]
		clear-face*: func [face][
			if face/para [face/para/scroll: 0x0]
			if string? face/text [clear face/text]
			face/line-list: none
		]
		reset-face*: func [face][
			if face/para [face/para/scroll: 0x0]
			face/text: copy ""
			face/line-list: none
			set-face* face face/default
		]
	]

	button: context [
		disable-face*: func [face /local tmp] [
			if face/disabled-colors [
				tmp: face/colors
				face/colors: face/disabled-colors
				face/disabled-colors: tmp
				face/color: first face/colors
			]
			if face/font [
				face/font/color: face/color - 50
			]
			face/edge: make face/edge disabled-normal-edge
		]
		enable-face*: func [face /local tmp] [
			if face/disabled-colors [
				tmp: face/disabled-colors
				face/disabled-colors: face/colors
				face/colors: tmp
				face/color: first face/colors
			]
			face/edge: make face/edge normal-edge
		]
	]

	toggle: make data-state [
		disable-face*: func [face /local tmp] [
			if face/disabled-colors [
				tmp: face/colors
				face/colors: face/disabled-colors
				face/disabled-colors: tmp
				face/color: first face/colors
			]
			if face/font [
				face/font/color: face/color - 50
			]
			face/edge: make face/edge disabled-normal-edge
		]
		enable-face*: func [face /local tmp] [
			if face/disabled-colors [
				tmp: face/disabled-colors
				face/disabled-colors: face/colors
				face/colors: tmp
				face/color: first face/colors
			]
			face/edge: make face/edge normal-edge
		]
	]

	field: make text [
		get-face*: func [face][
			case [
				flag-face? face hide [face/data]
				flag-face? face integer [any [attempt [to-integer face/text] 0]]
				flag-face? face decimal [any [attempt [to-decimal face/text] 0]]
				true [face/text]
			]
		]
		set-face*: func [face value][
			if face/para [face/para/scroll: 0x0]
			face/text: all [value form value] ; conversion/copy
			either flag-face? face hide [
				face/data: all [value form value]
				face/text: all [value head insert/dup copy "" "*" length? face/data]
			][
				either any [
					flag-face? face integer
					flag-face? face decimal
				] [
					face/data:
						case [
							none? value [0]
							integer? value [value]
							decimal? value [value]
							all [series? value empty? value] [0]
							error? try [to-decimal value] [0]
							equal? to-integer value to-decimal value [to-integer value]
							true [to-decimal value]
						]
					face/text: form face/data
				][
					face/data: all [value not empty? face/text copy face/text]
				]
			]
			; this is a bit unstable
			if system/view/focal-face = face [
				ctx-text/unlight-text
				system/view/caret: at face/text index? system/view/caret
			]
			ctx-text/set-text-body face form face/text
			face/line-list: none
		]
		clear-face*: func [face][
			if face/para [face/para/scroll: 0x0] ; not sure
			if string? face/text [ctx-text/clear-text face]
			; RAMBO #3445
			if flag-face? face hide [clear face/data]
			ctx-text/set-text-body face form face/data
			face/line-list: none
		]
		scroll-face*: func [face x y /local edge para size][
			edge: any [attempt [2 * face/edge/size] 0]
			para: face/para/origin + face/para/margin
			size: negate face/text-body/size - face/size + edge + para
			if x [face/para/scroll/x: x * size/x]
			if y [face/para/scroll/y: y * size/y]
			face/para/scroll
		]
		disable-face*: func [face /local tmp] [
			; [ ] - font color does not work properly on init due to redraw and common font object
			tmp: face/colors
			face/colors: face/disabled-colors
			face/disabled-colors: tmp
			face/font/color: 80.80.80
			face/edge: make face/edge disabled-field-edge
		]
		enable-face*: func [face /local tmp] [
			tmp: face/disabled-colors
			face/disabled-colors: face/colors
			face/colors: tmp
			face/effect: none
			face/edge: make face/edge field-edge
		]
	]

	image: context [
		set-face*: func [face value][
			if any [image? value none? value][
				set-image face value
			]
		]
		get-face*: func [face][face/draw-image]
		clear-face*: func [face][set-image face none]
		reset-face*: func [face][set-face* face face/default]
	]

	compound: context [
		blk: none

		; Sets INPUT or PANEL faces
		set-panel: func [face value] [
			i: 0
			foreach f get-pane face [
				case [
					find f/flags 'input [
						unless empty? value [
							unless flag-face? face transparent [
								set-face f value/1 ; no-show later, which is faster
							]
							value: next value
						]
					]
					find f/flags 'panel [
						value: set-panel f value
					]
				]
			]
			value ; return at new index
		]
		; Sets compound to given data contents
		set-face*: func [face value][
			; If value is a block, it can be a block of [val val val ...] values
			; Only INPUT or PANEL faces are set.
			if block? get-pane face [ ; perhaps not
				if object? value [value: extract/index third value 2 2]
				if block? value [set-panel face value]
			]
		]
		get-panel: func [face /local pane] [
			foreach f get-pane face [
				case [
					find f/flags 'input [
						; blk is unknown
						append/only blk ; was repend, but won't accept blocks this way
							; this will only work on the same level, not sub-levels. this means we have to track faces inward for transparency.
							; for some reason this works in the program, but not in the test
							; this is because two transparent panels inside eachother will do something to cancel out the result, and always return none
							; which is wrong
							either flag-face? face transparent [ ; not a good name
								unless flag-face? f disabled [get-face f] ; flat block is returned
							][
								get-face f
							]
					]
					find f/flags 'panel [
						get-panel f
					]
				]
			]
		]
		get-face*: func [face /local var transparent][
			; Returns a block of [val val val ...] for all INPUT faces
			if block? get-pane face [ ; this is not a block, sometimes
				blk: make block! 6
				get-panel face
			]
			blk
		]
		clear-face*: func [face][
			if block? get-pane face [
				foreach f get-pane face [
					if any [find f/flags 'input find f/flags 'panel] [
						clear-face/no-show f
					]
				]
			]
		]
		reset-face*: func [face][
			if block? get-pane face [
				foreach f get-pane face [
					if any [find f/flags 'input find f/flags 'panel] [
						reset-face/no-show f
					]
				]
			]
		]
	]

	panel: make compound [
		blk: none

		setup-face*: func [face value /local err panel-size pane panes sizes user-size? word] [
			;-- Setup word/block pairs
			either block? value [ ; either action or setup
				if empty? value [
					insert/only insert value 'default make block! []
				]
			][ ; when no action or setup occurs
				value: reduce ['default make block! []]
			]
			face/setup: value ; should now be block of word/block pairs
			face/real-size: none
			face/panes: make block! length? value
			sizes: make block! length? value
			;-- Convert all pane layouts to face objects
			parse value [
				any [
					set word word!
					opt string!
					set pane block! (
						face/add-pane face word pane
						insert tail sizes face/panes/2/size
					)
				]
			]
			face/panes: head face/panes
			user-size?: pair? face/size
			;-- Panel-size for each panel
			panel-size: 0x0
			unless flag-face? face scrollable [
				either user-size? [
					;-- User sets size
					panel-size: face/size
					if face/edge [panel-size: panel-size - (face/edge/size * 2)]
				][
					;-- Content sets size
					foreach size sizes [
						panel-size/x: max size/x panel-size/x
						panel-size/y: max size/y panel-size/y
					]
					face/size: max any [face/size 0x0] panel-size
					if face/edge [face/size: panel-size + (face/edge/size * 2)]
				]
			]
			foreach [word pane] face/panes [pane/size: panel-size]
		]

		; Panel SET and GET functions only work on sub-faces flagged as INPUT
		; (keep in mind this may be panel recursive)
		set-find-var: func [pane var value][
			; Find input face with given VAR name and set it.
			foreach f pane [
				if all [
					find f/flags 'input
					f/var = var
					set-face f value
				][return true]
			]
			false
		]
		; Sets the panel to a given pane from SETUP
		set-panel-pane: func [[catch] face value /local p old-tab-face tab-face] [
			if all [not empty? head face/panes any-word? value] [
				; [ ] - still can't set the pane inside a panel where the pane is not selected. bug #22.
				; [ ] - also can't change tab face while the panel we are changing is hidden
				;-- Store old tab face
				tab-face: get-tab-face face ; old tab face
				if tab-face [
					; use ascend-face to set this tab-face all the way out to the root
					; although I think this is a little dirty, because we should resort to specific flags when doing this
					either within-face? tab-face face [
						old-tab-face: face/pane/tab-face: tab-face
					][
						face/pane/tab-face: none ; this crashes
					]
				]

				;-- Switch pane
				either p: find head face/panes value [
					face/pane: first next face/panes: p ; an object
				][
					throw make error! reform ["Could not find pane" value "in" describe-face face]
				]

				;-- Set new tab face
				if all [
					tab-face
					old-tab-face
				] [
					focus
						any [
							face/pane/tab-face
							find-flag face tabbed
							root-face face ; not sure about this
						]
				]
				; [ ] - this still doesn't work for hidden panes inside another panel
				; the pane is remembered, but not hidden and it will continue to work even if the panel is hidden
				; the only work around is to show the panel before changing the tab face
				true
			]
		]
		; Sets panel to given data contents or to given pane
		set-face*: func [face value][
			; If value is a word, pane is chosen
			; If value is a block, it can be a block of [val val val ...] values
			; Only INPUT or PANEL faces are set.
			; this fails now in that several subpanels are set to the same values
			if set-panel-pane face value [exit]
			if block? get-pane face [ ; perhaps not
				if object? value [value: extract/index third value 2 2]
				if block? value [set-panel face value]
			]
		]
	]
	
	tab-panel: make panel [
		set-face*: func [face value] [
			either word? value [
				set-face face/pane/2 value
				do-face face/pane/2 none
			][
				set-face/no-show face/pane/1 value
			]
		]
		get-face*: func [face] [
			get-face face/pane/2
		]
		reset-face*: func [face] [
			set-face* face face/default
		]
		setup-face*: func [face value /local action tabs panes] [
			face/setup: value
			face/real-size: none
			tabs: make block! []
			panes: make block! []
			action: get in face 'action
			unless block? face/setup [
				face/setup:
					either all [function? :action not empty? second :action] [
						second :action
					][
						make block! []
					]
			]
			use [b s t w] [
				t: none
				parse face/setup [
					any [
						set w word!
						set s string!
						opt [set t tuple!]
						[set b block! | set b word! (b: get b)] (
							repend tabs [w s t]
							append/only append panes w b
						)
					]
				]
			]
			face/pane: layout/styles/tight
				compose/only [
					space 0
					tab-selector setup (tabs) [set-face face/parent-face/pane/1 get-face face]
					pad 0x-2
					tab-panel-frame fill 1x1 setup (panes)
					; [ ] - drop down menu here later which displays invisible tabs
					; [ ] - awareness of when there are hidden tabs
					; [ ] - do not render tabs that go beyond the designated border
				]
				copy face/styles
			; [ ] - this inverts tab order, but is necessary for visual appearance
			face/tab-selector: face/pane/pane/1
			reverse face/pane/pane
			panes: none
			face/size: max any [face/size 0x0] face/pane/size
			face/pane: face/pane/pane
			set-parent-faces face
		]
	]
	

	face-construct: make data-default [
		setup-face*: func [face setup /local tab-face] [
			face/setup: setup
			tab-face: get-tab-face face
			any [none? tab-face within-face? tab-face face tab-face: none]
			unfocus ; without this, we get a crash because of orphaned faces
			face/pane: none
			any [face/setup get in face 'do-setup exit]
			clear face/lo
			face/do-setup face face/setup
			face/pane: layout/tight face/lo
			;face/pane/color: face/color ; nope
			face/real-size: none
			face/pane/real-size: none
			face/size: face/pane/size
			face/pane: face/pane/pane
			set-parent-faces face ; this doesn't work when this is called during init
			ctx-resize/align face
			if all [face/show? tab-face] [
				focus any [find-flag face tabbed root-face face]
			]
		]
	]

	selector: make face-construct [
		; sets specific selector
		set-face*: func [face value /local f v words] [
			face/data: value
			foreach f face/pane [
				set-face/no-show f false
			]
			unless value [show face exit]
			value: to-word value
			words: copy face/setup
			remove-each w words [not word? w]
			f: find words value
			if found? f [
				v: pick face/pane index? f
				set-face v true
			]
		]
		clear-face*: func [face /local i] [
			foreach f face/pane [set-face/no-show f false]
			face/data: none
		]
		reset-face*: func [face] [
			set-face face first face/setup
		]
		;key-face*: func [face event /local val] [
		;	probe event/key
		;	case [
		;		find [left up] event/key [
		;			; radio-line expects the setup to be different
		;			val: either get-face face [
		;				either event/shift [
		;					face/data
		;				][
		;					find/reverse find face/setup get-face face word!
		;				]
		;			][
		;				face/setup
		;			]
		;			if val [
		;				set-face face first val
		;				do-face face none
		;			]
		;		]
		;		find [right down] event/key [
		;			either get-face face [
		;				either event/shift [
		;					val: tail face/setup
		;					val: find/reverse val word!
		;					val: first val
		;					val <> get-face face
		;					set-face face val
		;				][
		;					all [
		;						val: find face/setup get-face face
		;						val: find next val word!
		;						val: first val
		;						val <> get-face face
		;						set-face face val ; problem with right most face in tab-selector here
		;					]
		;				]
		;			][
		;				set-face face first face/setup
		;			]
		;			do-face face none
		;		]
		;		event/key = #"^H" [ ; backspace
		;			reset-face* face
		;			do-face face none
		;		]
		;	]
		;]
	]

	multi-selector: make face-construct [
		set-selectors: func [face /local values] [
			foreach f face/pane [
				set-face/no-show f found? find face/data f/var
			]
		]
		set-face*: func [face value /local f] [
			face/data: value
			foreach f face/pane [
				set-face/no-show f false
			]
			if empty? face/data [show face exit]
			set-selectors face
		]
		key-face*: func [face event] [
			case [
				find [left up] event/key [
					; tab to previous
					tab-face: find-flag/reverse tab-face tabbed
					if tab-face [set-tab-face tab-face]
				]
				find [right down] event/key [
					; tab to next
					tab-face: find-flag tab-face tabbed
					if tab-face [set-tab-face tab-face]
				]
			]
		]
		clear-face*: func [face /local i] [
			foreach f face/pane [set-face/no-show f false]
		]
		reset-face*: func [face][
			face/data: copy face/default
			set-selectors face
		]
	]

	selector-nav: context [
		key-face*: func [face event /local tab-face] [
			case [
				find [left up] event/key [
					; tab to previous
					tab-face:
						either head? find face/parent-face/pane face [
							last face/parent-face/pane
						][
							find-flag/reverse get-tab-face face tabbed
						]
				]
				find [right down] event/key [
					; tab to next
					tab-face:
						either tail? next find face/parent-face/pane face [
							first face/parent-face/pane
						][
							find-flag get-tab-face face tabbed
						]
				]
				find [#" " #"^M"] event/key [ ; enter or space
					either event/shift [
						click-face/alt face
					][
						click-face face
					]
				]
			]
;			if tab-face [set-tab-face tab-face focus tab-face]
			if tab-face [set-tab-face tab-face]
			;set-focus-ring event/face ; not sure
		]
	]

	system/view/vid/vid-face/access: data ; default accessors
]

;do %/c/build/simple-tests/access.r
