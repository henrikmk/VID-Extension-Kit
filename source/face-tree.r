REBOL [
	Title:  "REBOL/View: Face Tree Functions"
	Author: ["Brian Hawley" "Henrik Mikael Kristensen"]
	Rights: "Copyright 2000 REBOL Technologies. All rights reserved."
	Note:   {Improvements to this code are welcome, but all changes preserve the above copyright.}
	Purpose: {
		Various functions to maintain and investigate a face tree.
	}
	; You are free to use, modify, and distribute this software with any
	; REBOL Technologies products as long as the above header, copyright,
	; and this comment remain intact. This software is provided "as is"
	; and without warranties of any kind. In no event shall the owners or
	; contributors be liable for any damages of any kind, even if advised
	; of the possibility of such damage. See license for more information.

	; Please help us to improve this software by contributing changes and
	; fixes via http://www.rebol.com/feedback.html - Thanks!

	; Changes in this file are contributed by Henrik Mikael Kristensen.
	; Changes and fixes to this file can be contributed to Github at:
	; https://github.com/henrikmk/VID-Extension-Kit
]

set-parent-faces: func [
	{Sets parent-face correctly for all sub-faces in a face.}
	face
	/parent pf
] [
	;print join "->" describe-face face
	if parent [
		face/parent-face: pf
		face/level: pf/level + 1
	]
	case [
		function? get in face 'pane []
		all [in face 'panes block? face/panes] [
			foreach [w p] face/panes [
				either object? p [
					set-parent-faces/parent p face
				][
					foreach fc p [
						set-parent-faces/parent fc face
					]
				]
			]
		]
		block? face/pane [
			foreach fc face/pane [
				set-parent-faces/parent fc face
			]
		]
		object? face/pane [
			set-parent-faces/parent face/pane face
		]
	]
]

click-face: func [
	"Simulate a mouse click"
	face
	/alt
	/local down up
] [
	alt: to-logic alt
	down: pick [alt-down down] alt
	up: pick [alt-up up] alt
	; this causes loops in certain functions it seems
	if all [in face 'feel face/feel in face/feel 'engage] [
		face/feel/engage face down none
		face/feel/engage face up none
	]
]

; ---------- Face Navigation

; is a duplicate of FIND-WINDOW
root-face: func [
	{Finds the root face for a given face.}
	face
] [
	while [
		all [
			face
			face/parent-face
			in face 'style
			face/style <> 'window
		]
	] [
		face: face/parent-face
	]
	face
]

find-face: func [
	"Returns the pane in which a face exists at the given index."
	[catch]
	face
	/panes idx
	/local f fpp
] [
	fp: face/parent-face
	fpp:
		either panes [
			pick get in fp 'panes idx
		][
			get in fp 'pane
		]
	case [
		'window = attempt [get in face 'style] [
			; this is not good enough
			f: find system/view/screen-face/pane face
			if none? f [
				err-face: face
				throw make error! reform [
					"Window"
					describe-face face
					"does not belong to screen-face."
				]
			]
		]
		iterated-face? fp [
			f: face
		]
		block? fpp [
			; can't find the face here somehow
			f: find fr: fpp face
			if none? f [
				err-face: face
				throw make error! reform [
					"Face"
					describe-face face
					"has incorrect parent-face."
				]
			]
		]
		object? fpp [
			f: face
		]
		none? fpp [
			err-face: face
			throw make error! reform [
				"Parent-face for face"
				describe-face face
				"has no pane."
			]
		]
	]
	f
]

next-pane-face: func [
	"Returns the next face in a pane."
	[catch]
	face [object!]
] [
	
]

next-face: func [
	"Returns the face after this one in the pane."
	[catch]
	face [object!]
	/deep "Traverse deeply into subpanes."
	/panes idx "Traverse all panes in a panel."
	/local f fp fpi root-face val
] [
	idx: any [idx 2] ; first pane
	f: false
	if face/parent-face [
		f:
			either panes [
				find-face/panes face idx
			][
				find-face face ; if there is an error, it will be slightly harder to find now
			]
	]
	either deep [
		either iterated-face? face [ ; an iterated face does not have multiple panes
			fp: iterated-pane face
			if fp [return fp]
		][
			; find the first face in the next pane
			either all [panes in face 'panes] [
				fpi: face/panes/:idx
				if all [block? fpi not empty? fpi] [return fpi/1]
				if object? fpi [return fpi]
			][
				; this fails if the face does not have the 'iterated flag
				if all [block? face/pane not empty? face/pane] [return face/pane/1]
				if object? face/pane [return face/pane]
			]
		]
		if any [object? f tail? next f] [
			fp: face
			root-face: none
			return until [
				until [
					fp: fp/parent-face
					any [
						all [none? fp/parent-face root-face: fp]
						block? get in fp/parent-face 'pane
					]
				]
				any [
					root-face
					either panes [next-face/deep/panes fp idx + 2][next-face fp]
				]
			]
		]
		second f
	][
		either object? f [
			f
		][
			unless tail? next f [second f]
		]
	]
]

get-tip-face: func [
	{Returns the last face in the innermost pane of a face.}
	face
	/local fp fpp tip-face
] [
	; this is not working for iterated face. the result is none for entry 1 instead of a face.
	if iterated-face? face [return get-tip-face iterated-pane face]
	if object? face/pane [return get-tip-face face/pane]
	if none? face/pane [return face]
	if all [block? face/pane empty? face/pane] [return face]
	fp: last face/pane
	tip-face: none
	until [
		fpp: get in fp 'pane
		case [
			object? :fpp [fp: :fpp]
			all [block? :fpp not empty? :fpp] [fp: last :fpp]
;			iterated-face? :fpp [fp: iterated-pane :fpp] ; may not work
			true [tip-face: fp] ; watch for iterated faces
		]
		tip-face
	]
]

back-face: func [
	{Returns the face before this one in the pane.}
	[catch]
	face
	/deep
	/local f fpp
] [
	f: false
	either face/parent-face [
		f: find-face face
	][
		; alternative method here, which is softer on the need for a parent-face
		return get-tip-face face
		;either all [in face 'style face/style = 'window] [
		;	return get-tip-face face
		;][
		;	err-face: face
		;	throw make error! reform [
		;		"Face"
		;		describe-face face
		;		"has no parent-face"
		;	]
		;]
	]
	either deep [
		; [!] - need to make sure this will work with objects as panes
		if object? f [return face/parent-face]
		if head? f [return face/parent-face]
		if get in first back f 'pane [return get-tip-face first back f]
		first back f
	][
		either object? f [f][first back f]
	]
]

traverse-face: func [
	"Traverses a pane for a face deeply and lets you perform a function on each face."
	face [object!]
	action
	/local func-act last-face
] [
	unless get in face 'pane [exit]
	if all [block? face/pane empty? face/pane] [exit]
	last-face: get-tip-face face
	func-act: func [face] action
	until [
		face: next-face/deep face
		func-act face
		same? last-face face
	]
]

ascend-face: func [
	"Ascends through parent faces and performs an action on each parent. Stops when action returns FALSE."
	face [object!]
	action
	/local func-act res
] [
	func-act: func [face] action
	while [all [not res face/parent-face]] [
		res: func-act face/parent-face
		face: face/parent-face
	]
]

over-face: func [
	"Returns the face the mouse is currently hovering over."
	face [object!] "The face we are checking where the mouse is hovering."
	offset [pair!] "The current mouse offset in relation to the face."
	/local fc
] [
	fc: face
	until [
		face: back-face/deep face
		any [
			all [
				face/style <> 'highlight
				face/size <> 0x0
				face/show?
				inside? offset face/win-offset
				inside? face/win-offset + face/size offset
			]
			fc = face
		]
	]
	face
]

; ---------- Face Searching

within-face?: func [
	"Returns whether a face exists inside the pane of another face."
	child [object!]
	parent [object!]
	/local result
] [
	result: false
	traverse-face parent [result: any [result face = child]]
	to-logic result
]

find-relative-face: func [
	"Returns the next face from specific criteria relative to this one."
	[catch]
	face
	criteria
	/reverse "Search backwards"
	/local f same result
] [
	; [ ] - find a way to skip iterated faces.
	f: face
	until [
		face: either reverse [
			back-face/deep face ; does this ever return none?
		][
			next-face/deep face ; all holes seem plugged now
		]
		unless object? face [
			err-face: face
			throw make error! "Found face is not an object."
		]
		any [
			face = f ; if loop hits the face itself, stop looping
			either error? set/any 'result try [do bind criteria 'f] [
				;probe disarm result
				throw make error! "FIND-RELATIVE-FACE error"
			][
				result
			]
		]
	]
	;-- Only return face if face is different from the start face
	if any [
		face <> f
;		face = get-tab-face face ; this has cases where this won't work, because this makes it not a pure search for a specific style
	] [
		face
	]
]

find-style: func [
	"Finds a face with a particular style relative to this face."
	face
	style
	/reverse
	/local blk
] [
	; compress this a little more
	blk: compose/deep [all [in face 'style face/style = (to-lit-word style)]]
	either reverse [
		find-relative-face/reverse face blk
	][
		find-relative-face face blk
	]
]

; determines if the given face is correctly set for iteration
iterated-face?: func [[catch] face] [
	if none? face [
		throw make error! "Iterated face does not exist."
	]
	if flag-face? face iterated [
		if none? get in face 'pane [
			throw make error! reform [
				"Iterated face" describe-face face "has no pane function."
			]
		]
		true
	]
]

; determines if the given face exists inside a compound face
compound-face?: func [face] [
	compound-face: face
	ascend-face face [
		all [
			flag-face? face 'compound
			compound-face: face
		]
	]
	compound-face
]

; determines if the face or one of its parents are not being shown or has a size on at least one side of zero
visible-face?: func [face] [
	while [all [face/show? face/parent-face]] [
		face: face/parent-face
	]
	face/show?
]

; evaluates the first face in an iterated pane
iterated-pane: func [face] [face/pane face 1]

; returns the first block encountered for a face pane, when it might consist of an object
get-pane: func [face] [
	either object? face/pane [
		face/pane/pane
	][
		face/pane
	]
]

; ---------- Focusing

focus-default-input: func [
	"Focuses the first INPUT face with DEFAULT flag set."
	face
	/local input-face
] [
	traverse-face face [
		all [
			not flag-face? face disabled
			flag-face? face default
			flag-face? face input
			flag-face? face tabbed
			input-face: face
			break
		]
	]
	if input-face [
		set-tab-face focus input-face
	]
	input-face
]

focus-first-input: func [
	"Focuses the first TABBED INPUT face in a face."
	face
	/local input-face
] [
	traverse-face face [
		all [
			not flag-face? face disabled
			flag-face? face input
			flag-face? face tabbed
			input-face: face
			break
		]
	]
	if input-face [
		set-tab-face focus input-face
	]
	input-face
]

focus-first-false: func [
	"Focuses the first FALSE button"
	face
] [
	input-face: find-flag face close-false
	if input-face [
		set-tab-face focus input-face
	]
	input-face
]

; ---------- Face Flags

flag-face: func [
	"Sets a flag in a VID face."
	face [object!]
	'flag
][
	unless in face 'flags [exit]
	if none? face/flags [
		face/flags: copy [flags] ; really?
	]
	unless find face/flags 'flags [
		face/flags: copy face/flags insert face/flags 'flags
	]
	unless find face/flags flag [
		append face/flags flag
	]
]

flag-face?: func [
	"Checks a flag in a VID face."
	face [object!] 'flag
][
	all [
		in face 'flags
		face/flags
		find face/flags flag
	]
]

find-flag: func [
	"Finds a face with a particular flag relative to this face."
	face
	'flag
	/reverse
	/local blk
] [
	blk: compose [flag-face? face (flag)]
	either reverse [
		find-relative-face/reverse face blk
	][
		find-relative-face face blk
	]
]

save-flags: func [
	"Saves the flags in SAVED-FLAGS for the face."
	face
] [
	if block? face/flags [
		face/saved-flags: copy face/flags
	]
]

restore-flags: func [
	"Restores the flags from SAVED-FLAGS for the face."
	face
] [
	if block? face/saved-flags [
		face/flags: copy face/saved-flags
	]
]

; ---------- Save Face

save-face: func [
	"Saves the content of a face being edited and which is FOCAL-FACE."
	face
	/no-show "Do not show change yet."
] [
	if all [
		access: get in face 'access
		in access 'save-face*
	] [
		access/save-face* face
	]
	unless no-show [show face]
	face
]

; ---------- Validation

ctx-validate: context [

result: true
all-result: true
val-face: none
valid: none

; method for validating a single face
; method for initing a single face
; three separate methods
; all are recursive

validate?: func [face /local valid] [all [valid: get in face 'valid object? :valid :valid]]

show-indicator: func [face] [
	val-face: next-face face ; set the valid-indicator, if any is located at the next face
	all [
		val-face
		in val-face 'style
		val-face/style = 'valid-indicator
		set-face val-face valid/result
	]
]

validate-init-face-func: func [face] [
	either flag-face? face panel [
		traverse-face face [
			validate-init-face-func face
		]
	][
		if valid: validate? face [
			valid/result:
				either flag-face? face disabled [
					'not-required
				][
					pick
						either valid/required [
							[valid required]
						][
							[valid not-required]
						]
						result: to-logic valid/action face
				]
			show-indicator face
			if 'invalid = valid/result [all-result: false]
		]
	]
	act-face face none 'on-init-validate
]

set 'validate-init-face func [
	"Initializes a face or panel for validation"
	face
] [
	all-result: true
	validate-init-face-func face
	all-result
]

validate-face-func: func [face /no-show] [
	either flag-face? face panel [
		traverse-face face [
			either no-show [
				validate-face-func/no-show face
			][
				validate-face-func face
			]
		]
	][
		if valid: validate? face [
			valid/result:
				either flag-face? face disabled [
					'not-required
				][
					if system/view/focal-face = face [do-face face none]
					pick
						either valid/required [
							[valid invalid]
						][
							[valid not-required]
						]
						result: to-logic valid/action face
				]
			any [no-show show-indicator face]
			if 'invalid = valid/result [all-result: false]
		]
	]
	act-face face none 'on-validate
]

set 'validate-face func [
	"Performs validation on a face"
	face
	/no-show "Do not show change yet."
] [
	all-result: true
	either no-show [
		validate-face-func/no-show face
	][
		validate-face-func face
	]
	all-result
]

set 'init-enablers func [
	"Sets the fields that belongs to the enablers"
	face
] [
	traverse-face face [
		all [
			in face 'style
			face/style = 'enabler
			nf: next-face face
			either get-face face [
				enable-face nf
			][
				disable-face nf
			]
		]
	]
]

]

; ---------- Feel Management

save-feel: func [
	"Saves the FEEL object for a face and places a different one in its place."
	face
	new-feel
] [
	face/saved-feel: face/feel
	face/feel: new-feel
]

restore-feel: func [
	"Restores the FEEL object stored in SAVED-FEEL for a face."
	face
] [
	if face/saved-feel [face/feel: face/saved-feel]
]

; ---------- Font Management

save-font: func [
	"Saves the common FONT object for a face and places a different one in its place."
	face
	new-font
] [
	face/saved-font: face/font
	face/font: new-font
]

restore-font: func [
	"Restores the FONT object stored in SAVED-FONT for a face."
	face
] [
	if face/saved-font [face/font: face/saved-font]
]

; ---------- Path Faces

set-face-path: func [
	"Sets the face path for a specific panel with the PANEL flag."
	[catch]
	face
	path
	/no-show "Do not show change yet."
] [
	unless flag-face? face panel [
		throw make error! "SET-FACE-PATH: Face does not have PANEL flag."
	]
	all [
		in face 'access
		in face/access 'set-face-path*
	] [
		access/set-face-path* face
	]
	unless no-show [show face]
	face
]

get-face-path: func [
	"Gets the face path for a specific panel with the PANEL flag."
	[catch]
	face
] [
	unless flag-face? face panel [
		throw make error! "GET-FACE-PATH: Face does not have PANEL flag."
	]
	all [
		in face 'access
		in face/access 'get-face-path*
	] [
		face/access/get-face-path* face
	]
]

; ---------- Freeze/Thaw Faces

freeze-face: func [
	"Freezes a face or a panel of faces."
	face
	/no-show "Do not show change yet."
] [
	if same? face get-tab-face face [
		unfocus
		unset-tab-face face
	]
	either any [flag-face? face panel iterated-face? face] [
		save-flags face
		flag-face face frozen ; this is being run several times for the same face
		deflag-face face tabbed
		traverse-face face [
			freeze-face/no-show face
		]
	][
		unless flag-face? face frozen [
			save-flags face
			deflag-face face tabbed
			flag-face face frozen
			; unless in face 'saved-feel [print dump-obj face]
			save-feel face make face/feel [over: engage: detect: none] ; don't touch redraw
			act-face face none 'on-freeze
		]
	]
	unless no-show [show face]
]

thaw-face: func [
	"Thaws a face or a panel of faces."
	face
	/no-show "Do not show change yet."
] [
	either flag-face? face panel [
		restore-flags face
		traverse-face face [thaw-face/no-show face]
	][
		if flag-face? face frozen [
			restore-flags face
			restore-feel face
			act-face face none 'on-thaw
		]
	]
	unless no-show [show face]
]

; ---------- Default Face

get-default-face: func [
	"Gets the default face for a window."
	window
] [
	find-relative-face window [
		all [in face 'default face/default]
	]
]

set-default-face: func [
	"Sets a face as the default face in a window. Clears existing default face."
	face
	parent
	/local old-face
] [
	; clear existing default face
	old-face: get-default-face parent
	; clear rate feel for default face
	; set new default face
	; set default rate feel for new default face
]

; ---------- Face Change Detection

dirty-face?: func [
	"Detects if a face or any of its sub-faces are dirty."
	face
	/local result
] [
	result: false
	traverse-face face [
		all [
			flag-face? face changes
			in face 'dirty?
			result: result and face/dirty?
		]
	]
	result
]

dirty-face: func [
	"Marks a face as dirty as well as its nearest parent compound face."
	face
] [
	unless face/dirty? [
		ascend-face face [all [flag-face? face compound face/dirty?: true]]
		face/dirty?: true
	]
]

clean-face: func [
	"Cleans dirty face and all its sub-faces."
	face
] [
	traverse-face face [
		all [
			in face 'dirty?
			face/dirty?: false
		]
	]
]

; ---------- Scrolling

; adjust scrollers for a face offset and size in relation to its parent face
adjust-face-scrollers: func [
	face ; face to adjust scrollers for
	pane ; location of scroller faces
	/local fo fs fps fpsd
] [
	fo: face/offset					; scrolled face offset
	fs: face/size					; scrolled face outer size
	fps: face-size face/parent-face	; parent face inner size
	;-- Gather all scrollers in parent face, calc ratio and redrag
	foreach fc pane [
		if fc/style = 'scroller [
			fc/ratio: divide max 1 fps/(fc/axis) max 1 max fps/(fc/axis) fs/(fc/axis)
			;fc/redrag fc/ratio
			;do-face fc none
			;get-face fc
		]
	]
]

; ---------- Measuring and Positioning

; returns the size of the edge of a face if the edge exists
edge-size: func [face] [
	any [
		all [
			in face 'edge
			object? face/edge
			in face/edge 'size
			face/edge/size
		]
		0x0
	]
]

; returns the size of a face without edges
face-size: func [face] [
	face/size - (2 * edge-size face)
]

; the combined offset and size of a face
face-span: func [face] [
	face/size + face/offset
]