REBOL [
	Title:  "REBOL/View: Text Edit Core"
	Version: 2.7.6
	Rights: "Copyright REBOL Technologies 2008. All rights reserved."
	Home: http://www.rebol.com
	Date: 14-Mar-2008

	; You are free to use, modify, and distribute this file as long as the
	; above header, copyright, and this entire comment remains intact.
	; This software is provided "as is" without warranties of any kind.
	; In no event shall REBOL Technologies or source contributors be liable
	; for any damages of any kind, even if advised of the possibility of such
	; damage. See license for more information.

	; Please help us to improve this software by contributing changes and
	; fixes. See http://www.rebol.com/support.html for details.
]

ctx-text: [

	view*: system/view ; legacy

	;-- Highlighting

;-- Text highlight functions (but, do not reshow the face):

	hilight-text: func [face begin end][
		highlight-start: begin
		highlight-end: end
	]

	hilight-all: func [face][
		either empty? face/text [unlight-text][
			highlight-start: head face/text
			highlight-end: tail face/text
		]
	]

	unlight-text: does [
		highlight-start: highlight-end: none
	]

	hilight?: does [
		all [
			object? focal-face
			string? highlight-start
			string? highlight-end
			not zero? offset? highlight-end highlight-start
		]
	]

	hilight-range?: has [start end] [
		start: highlight-start
		end: highlight-end
		if negative? offset? start end [start: end end: highlight-start]
		reduce [start end]
	]

	store-hilight: func [face] [
		face/text-body/caret: caret
		face/text-body/highlight-start: highlight-start
		face/text-body/highlight-end: highlight-end
	]

	get-hilight: func [face] [
		highlight-start: face/text-body/highlight-start
		highlight-end: face/text-body/highlight-end
		caret: face/text-body/caret
	]

	clear-hilight: func [face] [
		face/text-body/highlight-start: face/text-body/highlight-end: none
	]

	left-hilight?: does [lesser? index? highlight-start index? highlight-end]

	left-hilight: does [
		either left-hilight? [highlight-start][highlight-end]
	]

	right-hilight: does [
		either left-hilight? [highlight-end][highlight-start]
	]

;-- Text focus functions:

	text-edit-face?: func [face] [
		any [
			flag-face? face 'text-edit
			flag-face? face 'full-text-edit
		]
	]

; does not yet have /no-save, but would have to be done in a different way
	set 'focus func [
		"Focuses key events on a specific face."
		face
		/keep "Reinstate caret position and selection"
		/no-show "Do not show change yet."
		/local root
	][
		unfocus/new face
		any [face return face]
		case [
			;-- if face is TEXT-INPUT, set as focal-face
			text-edit-face? face [
				focal-face: face
			]
			;-- if compound face, look for the first TEXT-INPUT face inside it
			flag-face? face 'compound [
				traverse-face face [
					all [
						text-edit-face? face
						focal-face: face
						break
					]
				]
			]
		]
		;-- If face has text editing
		if focal-face [
			unless string? focal-face/text [
				; [!] - note that it's directly setting text here, which may be a bad idea
				focal-face/text: either focal-face/text [form focal-face/text][copy ""]
				focal-face/line-list: none
			]
			; [!] - forcibly KEEP here on all fields
			either any [keep flag-face? focal-face keep] [
				; still places caret at end here for fields during KEEP
				get-hilight focal-face
			][
				unless caret [caret: tail focal-face/text]
			]
			if none? focal-face/line-list [
				if focal-face/para [focal-face/para/scroll: 0x0]
				caret: tail focal-face/text
			]
			if flag-face? focal-face field [hilight-all focal-face]
			svvf/set-face-state focal-face none
		]
		set in root-face face 'focal-face focal-face
		act-face face none 'on-focus
		any [no-show show face]
		set-tab-face face
	]

	set 'unfocus func [
		"Removes the current key event focus."
		/new new-face "New face being unfocused."
		/local root tmp-face
	][
		tmp-face: focal-face
		focal-face: none
		; problem here with a face that won't unfocus in build2.r
		if tmp-face [
			validate-face tmp-face
			;-- remove the focal face only if the root-face is the same
			if root: root-face tmp-face [
				if any [
					none? new-face
					equal? root root-face new-face
				] [
					set in root 'focal-face none
				]
			]
			; probably just KEEP always
			store-hilight tmp-face
			;either flag-face? tmp-face keep [
			;	store-hilight tmp-face
			;][
			;	clear-hilight tmp-face
			;]
		]
		caret: none
		unlight-text
		if tmp-face [
			svvf/set-face-state tmp-face none
			show tmp-face
			act-face tmp-face none 'on-unfocus
		]
		tmp-face
	]

;-- Copy and delete functions:

	copy-selected-text: func [face /local start end] [
		if all [
			hilight?
			not flag-face? face hide
		][
			set [start end] hilight-range?
			attempt [write clipboard:// copy/part start end]
			true
		] ; else return false
	]

	copy-text: func [face] [
		; I don't like this function, as it will copy everything to the clipboard, when nothing is selected.
		unless copy-selected-text face [ ; copy all if none selected (!!! should be line)
			hilight-all face
			copy-selected-text face
		] ; else return false
	]

	delete-selected-text: func [/local face start end] [
		if hilight? [
			face: focal-face
			set [start end] hilight-range?
			if flag-face? face hide [remove/part at face/text index? start index? end]
			remove/part start end
			caret: start
			face/line-list: none
			unlight-text
			true
		] ; else return false
	]

	clear-text: func [face] [
		; [!] - note that this does not affect face/data
		caret: head clear face/text
		unlight-text
		face/line-list: none
	]

;-- Cursor movement:

	view*/vid/word-limits: use [cs][
		cs: charset " ^-^/^m/[](){}^""
		reduce [cs complement cs]
	]

	next-word: func [str /local s ns] [
		set [s ns] vid/word-limits
		any [all [s: find str s find s ns] tail str]
	]

	back-word: func [str /local s ns] [
		set [s ns] vid/word-limits
		any [all [ns: find/reverse back str ns ns: find/reverse ns s next ns] head str]
	]

	end-of-line: func [str /local nstr] [ ;returns at newline
		either nstr: find str newline [nstr][tail str]
	]

	beg-of-line: func [str /local nstr] [ ;returns just after newline
		either nstr: find/reverse str newline [next nstr][head str]
	]

;-- Line

	tab-size: 4

	tab-offset?: func [pos-start pos-end /local offset tabs] [
		tabs: 0
		repeat i offset: offset? pos-start pos-end [
			if #"^-" = pick pos-start i [
				tabs: tabs + 1
			]
		]
		tabs * tab-size + offset - tabs
	]

	line-height: func [face /local l-info] [
		; at start of an empty line, the line height is zero
		either zero? line-info/size/y [
			; create artificial new line zero
			insert head caret #"X"
			textinfo face l-info: make line-info [] 0 head caret
			remove head caret
			l-info/size/y
		][
			line-info/size/y
		]
	]

;-- Text Body Management:

	set-text-body: func [face caret /local ft lines font para edge] [
		any [face/font return none]
		any [ft: face/text-body return none]
		unless all [face/text caret] [return ft/lines: none] ; really? seems too simple
		lines: parse/all face/text "^/"
		textinfo face line-info caret ; we are writing line-info twice when using edit-text and set-text-body
		any [line-info/size return none]
		para: face/para
		font: face/font
		edge: face/edge

		; pixel dimensions
		ft/size:					size-text face ; size of all text
		ft/line-height:				line-height face
		ft/area:					face/size - (any [attempt [edge/size * 2] 0]) - para/origin - para/margin

		; unwrapped text dimensions by characters
		ft/paras:					length? lines
		ft/para:					ft/paras - length? parse/all caret "^/"
		ft/para-start:				index? beg-of-line caret
		ft/para-end:				index? end-of-line caret

		; wrapped text dimensions by characters
		ft/lines:					round ft/size/y / ft/line-height
		ft/line:					1 + round line-info/offset/y - para/scroll/y / ft/line-height
		ft/line-start:				index? line-info/start
		ft/line-end:				ft/line-start + line-info/num-chars

		; corrections for View bugs
		if empty? face/text			[para/scroll: 0x0]
		if ft/line = 1				[para/scroll/y: 0]
		if line-info/start = caret	[para/scroll/x: 0]

		; clamping of para/scroll
		para/scroll/y:				max min 0 ft/area/y - ft/size/y min 0 para/scroll/y
		para/scroll/x:				max min 0 ft/area/x - ft/size/x min 0 para/scroll/x

		; scroll position
		ft/v-scroll:				abs para/scroll/y / max 1 ft/size/y - ft/area/y
		ft/h-scroll:				abs para/scroll/x / max 1 ft/size/x - ft/area/x ; not entirely correct 0.959459459459459

		; ratios of text area
		ft/v-ratio: 				min 1 ft/area/y / max 1 ft/size/y
		ft/h-ratio: 				min 1 ft/area/x / max 1 ft/size/x
		ft
	]

;-- Character handling:

	keymap: [   ; a small table, so does not benefit from hashing
		#"^(back)" back-char
		#"^(tab)"  tab-char
		#"^(del)"  del-char
		#"^M" enter
		#"^A" all-text
		#"^C" copy-text
		#"^X" cut-text
		#"^V" paste-text
		#"^T" clear-tail
		#"^(esc)" escape
	]

	base-keys: make bitset! #{01000000FFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
	nav-keys: make bitset! ["^-"]
	ctrl-keys: union nav-keys make bitset! [#"^H" #"^M" #"^~" #" "]
	integer-keys: make bitset! [#"0" - #"9"]
	sign-key: make bitset! [#"-" #"+"]
	decimal-keys: make bitset! [#"0" - #"9" #"." #","]
	tuple-keys: make bitset! [#"0" - #"9" #"."]

	keys-to-insert: func [face /local base] [
		base: case [
			flag-face? face integer [integer-keys]
			flag-face? face decimal [decimal-keys]
			true [base-keys]
		]
		if flag-face? face sign [base: union base sign-key]
;		if flag-face? face full-text-edit [base: union base nav-keys]
		base
	]

	content-to-insert: func [face key] [
		case [
			flag-face? face decimal [
				;-- allow only one decimal point
				any [
					all [
						key <> #"."
						key <> #","
					]
					all [
						not find any [face/text ""] #"."
						not find any [face/text ""] #","
					]
				]
			]
			true [true]
		]
	]

	insert-char: func [face char][
		delete-selected-text
		; For password spoofed text (***), the above may put caret on wrong face.
		; Check, and restore proper caret, otherwise we lose a character.
		unless same? head face/text head caret [caret: at face/text index? caret]
		dirty-face face
		; The caret may be off the end, so just append if it is.
		if error? try [caret: insert caret char][append caret char]
	]

	caret-highlight: func [event] [
		; Deal with cursor movement when cancelling a highlight
		switch/default event/key [
			left [left-hilight]
			right [right-hilight]
			up [left-hilight]
			down [right-hilight]
		][
			caret
		]
	]

	auto-tab-move: func [face event caret? new-face caret-pos] [
		; Deal with cursor movement, when using auto-tab faces
		if flag-face? face auto-tab [
			if caret? [
				act-face face event 'on-tab
				focus/no-show new-face
				caret: caret-pos
				return true
			]
		]
	]

	move: func [event ctrl-move-to move-to hilight-func] [
		; Deal with cursor movement, including special shift and control cases.
		; MacOSX does not capture event/shift and event/control at the same time
		either event/shift [
			any [highlight-start highlight-start: caret]
			caret: either event/control ctrl-move-to move-to
			either caret = highlight-start [unlight-text][highlight-end: caret]
		][
			either hilight? [
				caret: hilight-func
				unlight-text
			][
				caret: either event/control ctrl-move-to move-to
			]
		]
	]

	move-y: func [face delta /local pos tmp tmp2][
		; Move up or down a number of lines.
		; ROMANO: Do you think there is a better way? This is going to
		; take a lot of CPU time.
		tmp: offset-to-caret face delta + pos: caret-to-offset face caret
		tmp2: caret-to-offset face tmp
		either tmp2/y <> pos/y [tmp][caret]
	]

	edit-text: func [
		face event action
		/local key liney swap-text tmp tmp2 page-up page-down face-size face-edge
	][
		key: event/key

		;-- Compute edge and face sizes (less the edge):
		face-size: face/size - face-edge: either face/edge [2 * face/edge/size][0x0]

		;-- Fields with HIDE swap text with the /data field:
		; deprecated. we want a dedicated password field and this function is too buggy.
		; what it does is equate face/text with face/data and further depends on it, which is not useful
		; in the case for GET-FACE for the field
		; the swap-text function is then used in 4 different places. it swaps face/text and face/data.a
		if flag-face? face hide swap-text: [
			tmp: face/text
			face/text: face/data
			face/data: tmp
			caret: either error? try [index? caret] [
				tail face/text
			][
				at face/text index? caret
			]
		]

		;-- Fetch the vertical line:
		textinfo face line-info 0
		liney: line-info/size/y

		;-- Most keys insert into the text, others convert to words:
		if all [char? key content-to-insert face key] [
			either find keys-to-insert face key [
				either all [
					not hilight?
					in face 'max-length
					integer? get in face 'max-length
					face/max-length > -1
				] [
					either flag-face? face auto-tab [
						if all [
							not hilight?
							face/max-length < index? caret
						] [
							act-face face event 'on-tab
							focus face: find-style face face/style
							caret: head caret
						]
						insert-char face key
					][
						if face/max-length > length? face/text [
							insert-char face key
						]
					]
				][
					; manage here to avoid multiple decimal points
					; but needs to be done before this, as we can ask this question multiple times
					; there can be a content based filter for this, like we have the key filter
					insert-char face key
				]
			] [
				; map key for the rest of the function
				key: either all [
					block? face/keycode
					; Does it require the CTRL-key pressed?
					; (E.g. prevents mixup between TAB key and CTRL-I.)
					tmp: find face/keycode key
					either tmp/2 = 'control [event/control] [true]
				] [
					if flag-face? face hide swap-text
					action face key
					none
				] [
					select keymap key
				]
			]
		]

		;-- Key action handling:
		if word? key [ ;probe key

			page-up: [move-y face face-size - liney - liney * 0x-1]
			page-down: [move-y face face-size - liney * 0x1]

			; Most frequent keys are first:
			do select [
				back-char [
					if all [flag-face? face auto-tab not hilight? head? caret] [
						focus/no-show find-style/reverse face face/style
						unlight-text
						caret: tail caret
					]
					if all [not delete-selected-text not head? caret][
						either event/control [
							tmp: caret
							remove/part caret: back-word tmp tmp
						][
							remove caret: back caret
						]
					]
					dirty-face face
				]
				del-char [
					if all [not delete-selected-text not tail? caret][
						either event/control [
							remove/part caret next-word caret
						][
							remove caret
						]
					]
					dirty-face face
				]
				left [
					any [
						auto-tab-move
							face
							event
							head? caret
							find-style/reverse face face/style
							tail caret
						move event [back-word caret] [back caret] :left-hilight
					]
				]
				right [
					any [
						auto-tab-move
							face
							event
							tail? caret
							find-style face face/style
							head caret
						move event [next-word caret] [next caret] :right-hilight
					]
				]
				up [move event page-up [move-y face liney * 0x-1] :left-hilight]
				down [move event page-down [move-y face liney * 0x1] :right-hilight]
				page-up [move event [head caret] page-up :left-hilight]
				page-down [move event [tail caret] page-down :right-hilight]
				home [move event [head caret][beg-of-line caret] :left-hilight]
				end [move event [tail caret][end-of-line caret] :right-hilight]
				enter [
					either flag-face? face return [
						if flag-face? face hide swap-text
						act-face face event 'on-return
						if empty? face/text [clear-face face]
					] [
						insert-char face newline
					]
				]
				copy-text [copy-text face unlight-text] ; why unlight?
				cut-text [copy-text face delete-selected-text dirty-face face]
				paste-text [
					delete-selected-text
					face/line-list: none
					dirty-face face
					caret: insert caret read clipboard://
				]
				clear-tail [
					remove/part caret end-of-line caret
					dirty-face face
				]
				all-text [hilight-all face]
				tab-char [
					case [
						;-- Full text edit face
						any [
							flag-face? face full-text-edit
							flag-face? compound-face? face full-text-edit
						] [
							either event/control [ ; can't capture control here, so this doesn't work
								;-- Tab navigate
								act-face face event 'on-tab
								if empty? face/text [clear-face face]
							][
								insert-char face tab
							]
						]
						;-- Regular tabbed face
						any [
							flag-face? face tabbed
							flag-face? compound-face? face tabbed
						] [
							;-- Tab navigate
							act-face face event 'on-tab
							if empty? face/text [clear-face face]
						]
						;-- Any other condition
						true [
							;-- Insert Tab on any other condition
							insert-char face tab ; really?
						]
					]
				]
				escape [
					;-- we don't unset the tab face here
					if flag-face? face hide swap-text
					act-face face event 'on-escape
					unfocus
				]
			] key
		]

		;-- Scroll the face?
		if face: focal-face [
			if flag-face? face hide [
				unlight-text
				insert/dup clear face/data "*" length? face/text
				do swap-text
			]
			tmp: any [caret-to-offset face caret  caret-to-offset face caret: tail face/text]
			tmp: tmp - (face-edge / 2)
			tmp2: face/para/scroll
			;-- Scroll right if off left side, or up if off bottom:
			all [tmp/x < 0 tmp2/x < 0 face/para/scroll/x: tmp2/x - tmp/x]
			all [tmp/y < 0 tmp2/y < 0 face/para/scroll/y: tmp2/y - tmp/y]
			;-- Scroll left if off right side, or down if off top:
			action: face-size - tmp - face/para/margin
			if action/x < 5 [face/para/scroll/x: tmp2/x + action/x - 5]
			if action/y < liney [face/para/scroll/y: tmp2/y + action/y - liney]
			set-text-body face caret
			act-face face event 'on-key
			show face
		]
	]

	;-- Feel used for active text:
	edit: make face/feel [

		redraw: func [face act pos][
			if all [not svv/resizing? act = 'draw] [
				set-draw-body face
			]
		]

		engage: func [face act event][
			switch act [
				down [
					either equal? face focal-face [unlight-text][focus/no-show face]
					unless flag-face? face keep [
						caret: offset-to-caret face event/offset
					]
					show face
					act-face face event 'on-click
					set-text-body face caret
					svvf/set-face-state face none
				]
				over [
					if not-equal? caret offset-to-caret face event/offset [
						unless highlight-start [highlight-start: caret]
						highlight-end: caret: offset-to-caret face event/offset
						show face
					]
				]
				key [
					edit-text face event get in face 'action
				]
			]
		]
	]

	;-- Feel used for non-active text (still allow selection and copy)
	swipe: make face/feel [
		engage: func [face act event][
			switch act [
				down [
					either equal? face focal-face [unlight-text][focus/no-show face]
					unless flag-face? face keep [
						caret: offset-to-caret face event/offset
					]
					show face
					set-text-body face caret
					svvf/set-face-state face none
					face/action face get-face face
				]
				up [
					if highlight-start = highlight-end [unfocus]
				]
				over [
					if not-equal? caret offset-to-caret face event/offset [
						unless highlight-start [highlight-start: caret]
						highlight-end: caret: offset-to-caret face event/offset
						show face
					]
				]
				key [
					if 'copy-text = select keymap event/key [
						copy-text face unlight-text
					]
				]
			]
		]
	]

]

; Note: ctx-text was once a full external module. Now it is bound in View context
; to reduce PATH references.
ctx-text: context bind ctx-text system/view
foreach word [hilight-text hilight-all unlight-text][
	set word get in ctx-text word
]
