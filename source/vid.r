REBOL [
	Title:  "REBOL/View: Visual Interface Dialect"
	Author: "Carl Sassenrath"
	Rights: "Copyright 2000 REBOL Technologies. All rights reserved."
	; You are free to use, modify, and distribute this software with any
	; REBOL Technologies products as long as the above header, copyright,
	; and this comment remain intact. This software is provided "as is"
	; and without warranties of any kind. In no event shall the owners or
	; contributors be liable for any damages of any kind, even if advised
	; of the possibility of such damage. See license for more information.

	; Please help us to improve this software by contributing changes and
	; fixes via http://www.rebol.com/feedback.html - Thanks!
]

find-key-face: func [
	"Search faces to determine if keycode applies."
	face [object!] keycode [char! word!] /local w f result
][
	either all [
		w: in face 'keycode
		w: get w
		any [keycode = w  all [block? w find w keycode]]
	][face][
		w: in face 'pane
		either block? w: get w [
			;!!! There is a bug in foreach! a Break/return here does not return the correct result!
			result: none
			foreach f w [if all [object? f f: find-key-face f keycode][result: f break]]
			result
		][
			if object? :w [find-key-face w keycode]
		]
	]
]

do-face: func [face value] [ ; (needs to work for functions and blocks)
	do get in face 'action face either value [value][get-face face]
]

do-face-alt: func [face value] [
	do get in face 'alt-action face either value [value][get-face face]
]

; remove the original VID screen face event function
remove system/view/screen-face/feel/event-funcs

; replace the original VID screenface event function with this one
;insert-event-func func [face event /local fac] [
;	; Global event detection function.
;	; This is the body of a function that is called with a FACE and an EVENT.
;	; It returns a NONE if it handles the event, otherwise it returns the event.
;
;	; If a focal face, such as a text field, has been modified and then loses focus,
;	; its action should be invoked, and it should be unfocused (to prevent looping).
;	if all [
;		system/view/focal-face
;		event/type = 'down
;		; !!! This next line is a hack, because we really need to know what face the event
;		; is directed toward.  We need a way to get that info, but it's not available here.
;		not within? event/offset win-offset? system/view/focal-face system/view/focal-face/size
;		system/view/focal-face/dirty?
;	][
;		fac: system/view/focal-face
;		; this is run on SET-FACE sometimes, which is wrong
;		
;		unfocus
;		if flag-face? fac on-unfocus [
;			do-face fac none
;			fac/dirty?: none
;		]
;	]
;	event
;]

svv: system/view/vid: context [

verbose: off
warn: off
resizing?: false

word-limits: none

image-stock:
vid-feel:
icon-image:
radio.bmp:
radio-on.bmp: none

text-body: context [
	; change with SET-TEXT-BODY. read anywhere.
	size:				0x0		; pixel size of all text (pair)
	line-height:		0		; pixel height of text (integer)
	area:				0x0		; pixel size of usable text area inside face (pair)
	paras:				0		; total number of paragraphs (integer)
	para:				0		; current unwrapped text line (integer)
	para-start:			0		; unwrapped text start of line (integer)
	para-end:			0		; unwrapped text end of line (integer)
	line:				0		; current wrapped text line (integer)
	line-start:			0		; wrapped text start of line (integer)
	line-end:			0		; wrapped text end of line (integer)
	lines:				0		; number of visible wrapped lines (integer)
	v-ratio:			0.0		; ratio of visible vertical text versus total vertical text (decimal)
	h-ratio:			0.0		; ratio of visible horizontal text versus total horizontal text (decimal)
	v-scroll:			0.0		; vertical scroll position of text between 0 and 1 (decimal)
	h-scroll:			0.0		; horizontal scroll position of text between 0 and 1 (decimal)

	; changed only on UNFOCUS with faces with KEEP flag. read only on FOCUS.
	caret:				none	; caret index in text (none or string)
	highlight-start:	none	; highlight start index in text, from system/view (none or string)
	highlight-end:		none	; highlight end index in text, from system/view (none or string)
]

vid-face: make face [ ; root definition
	state: 'off				; state of button
	states:					; multiple states in order
	virgin:					; whether the first state in the STATES block can only be invoked once by the user
	touch:					; current state of UI feedback, such as LMB pressed, dragging, etc.
	see:					; results of UI feedback, such as focused, unfocused, disabled, etc.
	setup:					; face setup for constructs
	access:					; face value access functions (object)
	style:					; style used to define face
	action:					; action to take on pick (soon to be deprecated)
	alt-action:				; the other mouse button (soon to be deprecated)
	facets:					; face attributes to be parsed
	related:				; relational tags
	words:					; special keywords actions
	colors:					; alternate face colors
	texts:					; alternate text
	images:					; alternate images
	draw-image:				; standard image used in DRAW block
	file:					; media file
	var:					; variable used to hold face
	keycode:				; shortcut key
	reset:					; reset to original value
	styles:					; styles used in the pane
	init:					; what to do after the face is made
	multi:					; multiple facet handers
	blinker:				; state of the blink
	min-size:				; minimum size of face
	max-size:				; maximum size of face
	real-size:				; size of the face including negative size
	pane-size:				; size of layout pane
	dirty?:					; indicates that text has been changed
	help:					; optional help string
	user-data: none			; unused user data storage
	size: none				; size must be none to allow autosizing
	surface: none			; the name of the surface to use for the draw body
	event: none				; the word of the event used to set draw body
	text-body: none			; object with info about positions of the text
	draw-body: none			; object with info about draw blocks in the face
	flags: []				; option flags
	font: make font [align: 'left];style: none color: white align: 'left valign: 'top shadow: 1x1 colors: vid-colors/font-color]
	edge: make edge [size: 0x0]		; face edge
	doc: none				; auto-doc
	options:				; face options for popup
	saved-feel:				; temporary storage for face feel
	saved-font:				; temporary storage for face font object
	saved-para:				; temporary storage for face para
	saved-flags:			; temporary storage for face flags
	old-value: none			; last value in DATA
	default: none			; default value of face
	origin: 0x0				; origin in relation to parent face for fill and alignment
	win-offset: 0x0		; offset in relation to the window the face exists in. if face is window, offset is window offset.
	tags: none				; meta tags for face style
	fill: 0x0				; vertical and horizontal fill of face
	spring: [right bottom]	; spring resize and positioning information for face
	align: none				; align information for face
	fixed-aspect: false		; fixed aspect for face size
	aspect-ratio: 0.0		; aspect ratio used for fixed aspect for face size adjustments
	level: 0				; face depth level (window = 0)
	pos: none				; position in a list or grid [pair! or integer!]
	valid: none				; result of validation
	actors: none			; actors object
	tab-face?: none			; whether this face is a tab-face
	tab-face: none			; tab face inside this face
	focal-face: none		; focal face inside this face
	tool-tip: none			; tool tip layout for this face
]

state-flags: [font para edge]

vid-face/doc: make object! [
	info: "base face style"
	string:
	image:
	logic:
	integer:
	pair:
	tuple:
	file:
	url:
	decimal:
	time:
	block:
	keywords:
		none
]

vid-face/actors: make object! [
	on-setup:
	on-key:
	on-tab:
	on-return:
	on-click:
	on-alt-click:
	on-set:
	on-clear:
	on-reset:
	on-escape:
	on-focus:
	on-unfocus:
	on-scroll:
	on-resize:
	on-align:
	on-time:
	on-search:
	on-validate:
	on-init-validate:
	on-change:
	on-enable:
	on-disable:
	on-freeze:
	on-thaw:
		none
]

set 'set-font func [aface 'word val] [ ; deals with none font and cloning the font
	if none? aface/font [aface/font: vid-face/font]
	unless flag-face? aface font [aface/font: make aface/font [] flag-face aface font]
	either word = 'style [
		either none? val [aface/font/style: none][
			if none? aface/font/style [aface/font/style: copy []]
			if word? aface/font/style [aface/font/style: reduce [aface/font/style]]
			aface/font/style: union aface/font/style reduce [val]
		]
	][set in aface/font word val]
]

set 'set-para func [aface 'word val] [
	; it appears that this is not used in vid in the same way as font
	if none? aface/para [aface/para: vid-face/para]
	probe describe-face aface
	unless flag-face? aface para [probe 'para-issue aface/para: make aface/para [] flag-face aface para]
	set in aface/para word val
]

set 'set-edge func [aface 'word val] [
	if none? aface/edge [aface/edge: vid-face/edge]
	unless flag-face? aface edge [aface/edge: make aface/edge [] flag-face aface edge]
	set in aface/edge word val
]

set 'set-valid func [aface 'word val] [
	if none? aface/valid [aface/valid: make object! [action: result: none required: false]]
	if word = 'action [aface/valid/action: func [face] val exit]
	set in aface/valid word val
]

set 'set-tool-tip-face func [aface 'word val] [
	if none? aface/tool-tip [aface/tool-tip: val] ; directly pass block or string here
]

vid-face/multi: context [ ; default multifacet handlers
	text: func [face blk] [
		if pick blk 1 [
			face/text: first blk
			face/texts: copy blk
		]
	]
	size: func [face blk] [
		if pick blk 1 [
			if pair? first blk [face/real-size: none face/size: first blk]
			if integer? first blk [
				if none? face/size [face/real-size: none face/size: -1x-1]
				face/size/x: first blk
			]
		]
	]
	file: func [face blk] [
		if pick blk 1 [
			set-image face load-image face/file: first blk
			if pick blk 2 [
				face/colors: reduce [face/draw-image]
				foreach i next blk [
					append face/colors load-image i
				]
			]
		]
	]
	image: func [face blk] [
		if pick blk 1 [
			set-image face first blk
			if pick blk 2 [face/images: copy blk]
		]
	]
	color: func [face blk] [
		if pick blk 1 [
			either flag-face? face text [
				set-font face color first blk
				if pick blk 2 [face/color: second blk]
			][
				face/color: first blk
			]
			if pick blk 2 [face/colors: copy blk]
		]
	]
	block: func [face blk] [
		if pick blk 1 [
			face/action: func [face value] pick blk 1
			if pick blk 2 [face/alt-action: func [face value] pick blk 2]
		]
	]
]

set 'BLANK-FACE make vid-face [
	edge: font: para: feel: image: color: text: effect: none
	doc: make doc [info: "empty style (transparent, minimized)"]
]

vid-words: []  ; initialized on first evaluation of layout
vid-styles: reduce ['face vid-face 'blank-face blank-face]

track: func [blk] [if verbose [print blk]]
error: func [msg spot] [print [msg either series? :spot [mold copy/part :spot 6][:spot]]]
warning: func [blk] [print blk]

facet-words: [ ; Order of these is important to the code
	edge font para doc feel ; (objects go first) - ends at feel
	align fill spring setup default ; [!] - still be careful that this doesn't break anything
	; possibly transfer on-* formatters in here
	effect effects keycode rate colors texts help user-data ;-- ends at with
	with				[args: next args]  ; only used for
	bold italic underline [set-font new style first args args]
	left center right	[set-font new align first args args]
	top middle bottom	[set-font new valign first args args]
	plain				[set-font new style none args]
	of					[new/related: second args next args]
	font-size			[set-font new size second args next args]
	font-name			[set-font new name second args next args]
	font-color			[set-font new color second args next args]
	wrap				[set-para new wrap? on args]
	no-wrap				[set-para new wrap? off args]
	required			[set-valid new required true args]
	validate			[set-valid new action second args next args] ; problem if multiple faces share the same style
	tool-tip			[set-tool-tip-face new action second args next args]
	disabled			[disable-face new args]
	as-is				[flag-face new as-is args]
	shadow				[set-font new shadow second args next args]
	frame				[set-edge new none args]
	bevel				[set-edge new 'bevel args]
	ibevel				[set-edge new 'ibevel args]
	on-setup			[set-actor new 'on-setup second args next args]
	on-key				[set-actor new 'on-key second args next args]
	on-tab				[set-actor new 'on-tab second args next args]
	on-return			[set-actor new 'on-return second args next args]
	on-click			[set-actor new 'on-click second args next args]
	on-alt-click		[set-actor new 'on-alt-click second args next args]
	on-set				[set-actor new 'on-set second args next args]
	on-clear			[set-actor new 'on-clear second args next args]
	on-reset			[set-actor new 'on-reset second args next args]
	on-escape			[set-actor new 'on-escape second args next args]
	on-focus			[set-actor new 'on-focus second args next args]
	on-unfocus			[set-actor new 'on-unfocus second args next args]
	on-scroll			[set-actor new 'on-scroll second args next args]
	on-resize			[set-actor new 'on-resize second args next args]
	on-align			[set-actor new 'on-align second args next args]
	on-time				[set-actor new 'on-time second args next args]
	on-search			[set-actor new 'on-search second args next args]
	on-validate			[set-actor new 'on-validate second args next args]
	on-init-validate	[set-actor new 'on-init-validate second args next args]
	on-change			[set-actor new 'on-change second args next args] ; not formally available for use
	on-enable			[set-actor new 'on-enable second args next args]
	on-disable			[set-actor new 'on-disable second args next args]
	on-freeze			[set-actor new 'on-freeze second args next args]
	on-thaw				[set-actor new 'on-thaw second args next args]
	; Lists
	on-insert			[set-actor new 'on-insert second args next args]
	on-delete			[set-actor new 'on-delete second args next args]
	on-edit				[set-actor new 'on-edit second args next args]
]

fw-with: find facet-words 'with
fw-feel: find facet-words 'feel
spot: facet-words
while [spot: find spot block!] [change spot func [new args] first spot] ;convert above blocks to funcs

set 'get-style func [
	"Get the style by its name."
	name [word!]
	/styles ss "Stylesheet"
][
	if none? styles [ss: vid-styles]
	select ss name
]

set 'set-style func [  ; !!! put-style?
	"Set a style by its name."
	name [word!]
	new-face [object!]
	/styles ss "Stylesheet"
	/local here
][
	if none? styles [ss: vid-styles]
	either here: find ss name [change next here new-face][repend ss [name new-face]]
]

set 'make-face func [
	"Make a face from a given style name or example face."
	style [word! object!] "A name or a face"
	/styles ss "Stylesheet"
	/clone "Copy all primary facets"
	/size wh [pair!] "Size of face"
	/spec blk [block!] "Spec block"
	/offset xy [pair!] "Offset of face"
	/keep "Keep style related data"
][
	if word? style [style: either styles [select ss style][get-style style]]
	if none? style [return none]
	spec: [parent-face: saved-area: line-list: old-offset: old-size: none]
	if blk [spec: append copy spec blk]
	style: make style spec
	if size [style/size: wh]
	if offset [style/offset: xy]
	style/flags: exclude style/flags state-flags
	if clone [
		foreach word [text effect colors texts font para edge] [
			if style/:word [
				set in style word either series? style/:word [copy style/:word][
					make style/:word []
				]
			]
		]
	]
	do bind style/init in style 'init
	unless keep [
		style/init: copy []
		style/facets: none
	]
	style
]

expand-specs: func [face specs /local here] [
	specs: copy specs
	foreach var [edge: font: para: doc:] [
		if here: find/tail specs :var [
			if here/1 <> 'none [
				insert here reduce either get in face to-word :var [
					['make to-word :var]][
					['make to-path reduce ['vid-face to-word :var]]
				]
			]
		]
	]
	specs
]

grow-facets: func [new args /local pairs texts images colors files blocks val tmp] [
	new/facets: args

	;-- Multifacet groups accepted (static values)
	pairs:  clear []
	texts:  clear []
	colors: clear []
	files:  clear []
	blocks: clear []
	images: clear []

	forall args [
		val: first args
		switch/default type?/word val [
			pair!		[append pairs val]
			integer!	[append pairs val]
			string!		[append texts val]
			tuple!		[append colors val]
			block!		[append/only blocks val]
			file!		[append files val]
			url!		[append files val]
			image!		[append images val]
			char!		[new/keycode: val]
			logic!		[new/data: val]
			;logic!		[new/data: new/state: val] ; big change
			decimal!	[new/data val]
			time!		[new/rate: val]
			word!		[
				any [
					if all [new/words tmp: find new/words :val] [
						until [function? first tmp: next tmp]	; function follows words, guaranteed
						args: do first tmp new args
					]
					if tmp: find facet-words :val [
						either 0 >= offset? tmp fw-with [ ; into non-face facets
							until [function? first tmp: next tmp]
							args: do first tmp new args
						][
							either tail? args: next args [error "Missing argument for" :val][
								set in new val either positive? offset? fw-feel tmp [
									first args
								][ ; else, it's an object (or none) such as font or para
									if first args [make any [get in new val vid-face/:val] bind/copy first args new]
								]
							]
						]
					] ; Not a style word error is not needed, the reduce would have caught it
				]
			]
		][
			error "Unrecognized parameter:" val
		]
	]

	;-- Handle multi-facets, defaults are inherited from vid-face:
	new/multi/text  new texts
	new/multi/size  new pairs
	new/multi/file  new files
	new/multi/image new images
	new/multi/color new colors
	new/multi/block new blocks
]

set 'stylize func [
	"Return a style sheet block."
	specs [block!] "A block of: new-style: old-style facets"
	/master "Add to or change master style sheet"
	/styles styls [block!] "Base on existing style sheet"
	/local new old new-face old-face args tmp
][
	styles: either master [vid-styles][copy either styles [styls][[]]]
	while [specs: find specs set-word!][
		set [new old] specs
		specs: skip specs 2
		new: to-word :new
		unless word? :old [error "Invalid style for:" new]
		unless any [
			old-face: select styles old
			old-face: select vid-styles old][error "No such style:" old]
		unless tmp: find specs set-word! [tmp: tail specs]
		args: copy/part specs tmp
		forall args [
			if any [
				find/only facet-words first args
				all [old-face/words find old-face/words first args]
			][
				change args to-lit-word first args
			]
		]
		args: reduce head args
		new-face: make old-face either tmp: select args 'with [expand-specs old-face tmp][[]]
		new-face/facets: args
		new-face/style: old
		new-face/flags: exclude new-face/flags state-flags
;		probe new
;		if get-style 'txt [probe get in get-style 'txt 'font]
		; [s] - needs draw-body present to allow grow-facets to be used in it, but we don't have draw-body, as the surface has not been
		; assigned yet and won't be until layout. therefore we have to consider that draw-body should be unimportant in certain aspects
		grow-facets new-face args
		either old: find styles new [change next old new-face][repend styles [new new-face]]
		if tmp: new-face/words [  ; convert word actions to functions
			while [tmp: find tmp block!] [
				change tmp func [new args] first tmp
			]
		]
	]
	styles
]

do-facets: func [
	"Build block of parameters (and attribute words) while not a vid word or style."
	specs words styles /local facets item
][
	facets: copy []
	while [not tail? specs] [
		item: first specs
		if set-word? :item [break]
		either word? :item [
			if any [find vid-words item find styles item][break]
			facets: insert facets either any [
				all [words find words item]
				all [find facet-words item]
			][to-lit-word item][item]
		][
			facets: insert/only facets :item
		]
		specs: next specs
	]
	reduce [specs reduce head facets]  ; note facets are evaluated here!
]

next-tab: func [tabs way where] [
	if pair? tabs [
		tabs: max 1x1 tabs ; prevent div zero
		return where / tabs * tabs + tabs * way + (where * reverse way)
	]
	if block? tabs [
		foreach t tabs [
			if integer? t [t: t * 1x1] ; block of integers is ok too
			if all [pair? t (way * t) = (way * max t where)] [
				return way * t + (where * reverse way)
			]
		]
	]
	100 * way + where
]

vid-origin: 8x8
vid-space: 4

set 'layout func [
	"Return a face with a pane built from style description dialect."
	specs [block!] "Dialect block of styles, attributes, and layouts"
	/size pane-size [pair!] "Size (width and height) of pane face"
	/offset where [pair!] "Offset of pane face"
	/parent new [object! word! block!] "Face style for pane"
	/origin pos [pair!] "Set layout origin"
	/styles list [block!] "Block of styles to use"
	/keep "Keep style related data"
	/tight "Zero offset and origin"
	/local pane way space tabs var value args new-face pos-rule val facets start vid-rules max-off guide
	def-style rtn word
][
	if tight [ ; New 1.2.30
		unless offset [offset: true where: 0x0]
		unless origin [origin: true pos: 0x0]
	]
	;-- Get parent face style for layout:
	new-face: make any [
		all [parent object? new new]
		all [parent word? new get-style new]
		vid-face
	] any [all [parent block? new new][parent: 'panel]]
	unless parent [
		new-face/offset: any [
			all [offset where]
			50x50  ; Good default for systems that put menu bar at top.
		]
	]
	new-face/size: pane-size: any [
		all [size pane-size]
		new-face/size
		system/view/screen-face/size - (2 * new-face/offset)
	]
	new-face/pane: pane: copy []
	max-off: origin: where: either origin [pos][vid-origin]
	space: vid-space way: 0x1  pos: guide: none  tabs: 100x100
	def-style: none

	;-- Search dialect for all style definitions:
	new-face/styles: styles: either styles [list][copy vid-styles]
	parse specs [some [thru 'style val:
		[set word word! (unless find styles word [insert styles reduce [word none]])
		| none (error "Expected a style name" val)]
	]]
	parse specs [some [ thru 'styles val: [
			set word word! (
				if all [value? word value: get word block? value] [
					insert styles value
				]
			) | none (error "Expected a style name" val)
		]
	]]

	;-- Standard dialect rules:
	rtn: [where: (max-off * reverse way) + (way * any [guide origin])] ; max-off: 0x0]
	vid-rules: [
		  'return (do rtn)
		| 'at [set pos pair! (where: pos) | none]
		| 'space pos-rule (space: 1x1 * pos)
		| 'pad pos-rule (
			value: either integer? pos [way * pos][pos]
			where: where + value
			max-off: max-off + value
		)
		| 'across (if way <> 1x0 [way: 1x0 do rtn])
		| 'below (if way <> 0x1 [do rtn way: 0x1])
		| 'backward (way: negate way)
;changed	| 'origin [set pos [pair! | integer!] (origin: pos * 1x1) | none] (where: origin max-off: 0x0)
		| 'origin [set pos [pair! | integer!] (origin: pos * 1x1) | none] (where: max-off: origin)
		| 'guide [set pos pair! (guide: pos do rtn) | none (guide: where)] (max-off: 0x0)
		| 'tab (where: next-tab tabs way where)
		| 'tabs [
			set value [block! | pair!] (tabs: value) |
			set value integer! (tabs: value * 1x1)
		  ]
		| 'indent pos-rule (where/x: either integer? pos [where/x + pos][pos/x])
		| 'style set def-style word!
		| 'styles set value block! ; action done earlier
		| 'size set pos pair! (pane-size: new-face/size: pos size: true)
;broken		| 'include set word word! (append pane get word)
;removed	| 'sense set value block! [new/feel/engage: func [face action event] value]
		| 'backcolor set value tuple! (new-face/color: value)
		| 'backeffect set value block! (new-face/effect: value)
		| 'do set value block! (do :value)
	]
	pos-rule: [set pos [integer! | pair! | skip (error "Expected position or size:" :pos)]]
	if empty? vid-words [ ; build list of dialect keywords on init
		foreach value vid-rules [if lit-word? :value [append vid-words to-word value]]
	]

	;-- Parse each phrase:
	while [not tail? specs] [
		forever [
			;-- Look for vid words and face style names. All others are args.
			value: first specs  specs: next specs
			if set-word? :value [var: :value break]
			unless word? :value [error "Misplaced item:" :value break]
			;-- If it's a vid word, parse its args:
			if find vid-words value [
				either value = 'style [
					facets: reduce [first specs] ; style word to define
					specs: next specs
				][
					set [specs facets] do-facets start: specs [] styles
				]
				if :var [set :var where  var: none]
				insert facets :value
				unless parse facets vid-rules [error "Invalid args:" start]
				break
			]
			;-- If it's a style, make its face:
			new: select styles value
			unless new [error "Unknown word or style:" value break]
			set [specs facets] do-facets specs new/words styles
			new: make new either val: select facets 'with [expand-specs new val][[]]
			;if :var [set :var new  new/var: bind to-word :var new  var: none] ; MOVED 1.2.30
			;-- Handle its arguments:
			new/style: value
			new/origin: origin
			; should really not be needed, but is, due to the nature of init being unable to use parent-face
			; this causes problem in BASE-TEXT
			new/pane-size: pane-size ; !!! should not be needed!
			if new/valid [new/valid: make new/valid []] ; valid object must be copied
			new/styles: styles
			new/flags: exclude new/flags state-flags
			new/text-body: make text-body []
			if new/surface [new/draw-body: make-draw-body]
			new/actors: make new/actors []
			unless flag-face? new fixed [new/offset: where]
			grow-facets new facets
			track ["Style:" new/style "Offset:" new/offset "Size:" new/size]
			either def-style [
				; newly defined styles should NOT init their faces
				change next find styles def-style new
				def-style: none
			][
				new/parent-face: none ; used to flag that child needs to be parent
				if :var [new/var: bind to-word :var :var] ; New 1.2.30
				if get in new 'init [do bind new/init in new 'init]
				if get in new 'surface [set-surface new]
				if new/parent-face [new: new/parent-face]
				if :var [set :var new var: none] ; New 1.2.30
				append pane new
				unless flag-face? new fixed [
					max-off: maximum max-off new/size + space + where
					where: way * (new/size + space) + where
				]
				if all [warn any [new/offset/x > pane-size/x new/offset/y > pane-size/y]][
					error "Face offset outside the pane:" new/style]
				track ["Style:" new/style "Offset:" new/offset "Size:" new/size]
				;-- Save memory 1.1 change: new/init: new/words: new/styles: new/facets: new/multi: none
				unless keep [
					new/init: copy []
					new/words: new/styles: new/facets: none
				]
			]
			break ;forever
		]
	]
	unless size [ ; auto resize
		foreach face pane [if flag-face? face drop [face/size: 0x0]]
		new-face/size: size: origin + second span? pane
		foreach face pane [
			if flag-face? face drop [face/size: size]
			face/pane-size: size
		]
	]
	if get in new-face 'init [
		do bind (new-face/init) in new-face 'init
		unless keep [new-face/init: none]
	]
	new-face
]

choice-face: make face [
	
	way: mway: iway: none
	iter-face: none
	item-size: none
	options: [no-title no-border]

	pane: func [face oset /num] [
		if pair? oset [return to-integer (1 + (to-integer oset/:way / item-size/:way))]
		if any [none? oset oset > length? iter-face/flat-texts] [return none]
		iter-face/text: pick iter-face/flat-texts oset
		iter-face/offset: iter-face/old-offset: mway * item-size * (oset - 1)
		iter-face/selectable: not all [iter-face/texts <> iter-face/flat-texts find iter-face/texts iter-face/text] 
		iter-face/color: switch true reduce [
			iter-face/selectable and iter-face/selected [iter-face/colors/2]
			iter-face/selectable and not iter-face/selected [iter-face/colors/1]
			not iter-face/selectable [any [iter-face/colors/3 iter-face/colors/2]]
		]
		iter-face
	]

	evt-func: func [face event /local iface over] [
		either event/type = 'down [
			iface: choice-face/pane self event/offset - choice-face/offset
			any [all [iface: choice-face/pane self iface over: 'over]
				 all [iface: choice-face/pane self 1 over: 'away]]
			iface/feel/engage iface over event
;				remove-event-func :evt-func
			none
		] [event]
	]

; evaluate this function
	set 'choose func [
		"Generates a choice selector menu, vertical or horizontal."
		choices [block!] "Block of items to display" ; change this to work with the key/value format
		function [function! none!] "Function to call on selection"
		/style styl [object!] "The style choice button" ; do we need this?
		/window winf [object!] "The parent window to appear in" ; do we need this?
		/offset xy [pair!] "Offset of choice box"
		/across "Use horizontal layout"
		/local t oset up down wsize edg
	][
;			insert-event-func :evt-func
		set [way mway iway] pick [[y 0x1 1x0][x 1x0 0x1]] none? across
		if none? window [winf: system/view/screen-face]

		; set up the iterated face
		if none? style [styl: get-style 'button]
		edg: any [all [styl/edge styl/edge/size] 0x0]
		iter-face: make styl [
			size: size - (2 * edg)
			pane-parent: styl
			window: winf
			feel: vid-feel/choice-iterator
			texts: choices
			flat-texts: []
			action: :function
			selected: false
			selectable: true
			edge: none
			if colors = vid-colors/window-background-color [colors/1: color]
			unless block? colors [colors: vid-colors/window-background-color]
			color: colors/1
		]
		item-size: iter-face/size
		either find choices block! [
			clear iter-face/flat-texts
			foreach x choices [append iter-face/flat-texts x]] [iter-face/flat-texts: choices]

		; set up the pane
		self/size: (item-size * mway * length? iter-face/flat-texts) + (item-size * iway) + (2 * (t: any [all [edge edge/size] 0x0]))
		either offset [self/offset: xy][
			oset: (either window [styl/offset][screen-offset? styl]) + (any [all [styl/edge styl/edge/size] 0x0]) - t
			; shift the pane to its start position
			t: any [find iter-face/flat-texts styl/text iter-face/flat-texts]
			up: (index? t) - 1 * item-size/:way ; pixels needed up
			down: ((subtract length? iter-face/flat-texts index? t) + 1 * item-size/:way) ; pixels needed down
			wsize: get in find-window winf 'size
			; 4's and 8s are to keep the iterator off the window edges
			self/offset: (any [
				all [up < (oset/:way - 4) down < (wsize/:way - oset/:way - 4)
					 oset - ((mway * ((index? t) - 1) * item-size/:way))] ; it fits up & down
				all [up < (oset/:way - 4) if wsize/:way > (up + down + 8) [
						edg: (to-integer ((wsize/:way - oset/:way - 4) / item-size/:way)) * item-size/:way ; pixels that'll fit below the face
						oset - ((up + down - edg) * mway)]]
				oset - (oset - 4 * mway / iter-face/size/:way * iter-face/size/:way) ; just fit the top as high as we can
			])
		]
		show-popup/window/away self winf
		do-events
	]
]


set-edge: func [face type args][
	face/edge: make face/edge [size: 2x2 effect: type color: 128.128.128]
	unless tail? args: next args [
		if tuple? first args [face/edge/color: first args]
	]
	unless tail? args: next args [
		if any [integer? first args  pair? first args] [
			face/edge/size: 1x1 * first args
		]
	]
	next args
]


set-actor: func [face type args][
	insert-actor-func face type make function! [face value event actor] bind args ctx-content
]

]
