REBOL [
	Title:  "REBOL/View: Text Edit Core"
	Author: "Carl Sassenrath"
	Rights: "Copyright 2000 REBOL Technologies. All rights reserved."
	Note:   {Improvements to this code are welcome, but all changes preserve the above copyright.}
	Thanks: {Romano Paolo Tenca (Jan-2004) for fixes and cleanup in 'Edit-Text.}
	; You are free to use, modify, and distribute this software with any
	; REBOL Technologies products as long as the above header, copyright,
	; and this comment remain intact. This software is provided "as is"
	; and without warranties of any kind. In no event shall the owners or
	; contributors be liable for any damages of any kind, even if advised
	; of the possibility of such damage. See license for more information.

	; Please help us to improve this software by contributing changes and
	; fixes via http://www.rebol.com/feedback.html - Thanks!
]

;-- REMINDERS:
	; CTRL-BS should not = CTRL-DEL. Bug in C code?
	; What functions should be exported?
	; Should text option fields have more granularity? e.g. flags = 'field does a lot
	; Add auto-focus to show/detection
	; Docs: keys, flags, field vs area default behavior

ctx-text: [

	view*: system/view ; legacy

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

;-- Text focus functions:

	set 'focus func [
		"Focuses key events on a specific face."
		face 
		/no-show
		/local tmp-face
	][
		unfocus
		if not face [exit]
		focal-face: face
		if not string? face/text [
			face/text: either face/text [form face/text][copy ""]
			face/line-list: none
		]
		if not caret [caret: tail face/text]
		if none? face/line-list [
			if face/para [face/para/scroll: 0x0]
			caret: tail face/text
		]
		if flag-face? face field [hilight-all face]
		if not no-show [show face]
	]

	set 'unfocus func [
		"Removes the current key event focus."
		/local tmp-face
	][
		; (Clears related globals, even if no focal-face.)
		tmp-face: focal-face
		focal-face: none
		caret: none
		unlight-text
		if tmp-face [show tmp-face]
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
		if not copy-selected-text face [ ; copy all if none selected (!!! should be line)
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

;-- Text Field Functions:

	set 'clear-fields func [
		"Clear all text fields faces of a layout."
		panel [object!]
	][
		if not all [in panel 'type panel/type = 'face] [exit]
		unfocus
		foreach face panel/pane [
			if all [series? face/text flag-face? face field] [
				clear face/text
				face/line-list: none
			]
		]
	]

; obsolete
	next-field: func [face /local item][
		all [
			item: find face/parent-face/pane face
			while [
				if tail? item: next item [item: head item]
				face <> first item
			][
				if all [object? item/1 flag-face? item/1 tabbed][return item/1]
			]
		]
		none
	]

; obsolete
	back-field: func [face /local item][
		all	[
			item: find face/parent-face/pane face
			while [face <> first item: back item][
				if all [object? item/1 flag-face? item/1 tabbed][return item/1]
				if head? item [item: tail item]
			]
		]
		none
	]

;-- Character handling:

	keys-to-insert: complement charset [#"^A" - #"^(1F)" #"^(DEL)"]

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
	]

	insert-char: func [face char][
		delete-selected-text
		; For password spoofed text (***), the above may put caret on wrong face.
		; Check, and restore proper caret, otherwise we lose a character.
		if not same? head face/text head caret [caret: at face/text index? caret]
		face/dirty?: true
		; The caret may be off the end, so just append if it is.
		if error? try [caret: insert caret char][append caret char]
	]

	move: func [event ctrl plain] [
		; Deal with cursor movement, including special shift and control cases.
		either event/shift [any [highlight-start highlight-start: caret]][unlight-text]
		caret: either event/control ctrl plain
		if event/shift [either caret = highlight-start [unlight-text][highlight-end: caret]]
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
		; deprecated. we want a dedicated password field with limited functionality and this function is too buggy.
		if flag-face? face hide swap-text: [
			tmp: face/text
			face/text: face/data
			face/data: tmp
			caret: either error? try [index? caret] [tail face/text] [
				at face/text index? caret
			]
		]

		;-- Fetch the vertical line:
		textinfo face line-info 0
		liney: line-info/size/y

		;-- Most keys insert into the text, others convert to words:
		if char? key [
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
							; perhaps we need to alter this, as ctx-format is not ambitious enough
							; it should work as a general string processor
							; but for now this is the only way to handle it
							; perhaps also it should be renamed from FORMAT to PROCESS
							; so we can properly bind it
							act-face face 'on-tab event
							set-focus-ring focus face: find-style face face/style
							caret: head caret
						]
						insert-char face key
					][
						if face/max-length > length? face/text [
							insert-char face key
						]
					]
				][
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

		;if char? key [
		;	either find keys-to-insert key [insert-char face key][
		;		key: either all [
		;			block? face/keycode
		;			; Does it require the CTRL-key pressed?
		;			; (E.g. prevents mixup between TAB key and CTRL-I.)
		;			tmp: find face/keycode key
		;			either tmp/2 = 'control [event/control][true]
		;		][
		;			if flag-face? face hide swap-text
		;			action face key
		;			none
		;		][
		;			select keymap key
		;		]
		;	]
		;]

		;-- Key action handling:
		if word? key [ ;probe key

			page-up: [move-y face face-size - liney - liney * 0x-1]
			page-down: [move-y face face-size - liney * 0x1]

			; Most frequent keys are first:
			do select [
				back-char [
					if all [not delete-selected-text not head? caret][
						either event/control [
							tmp: caret
							remove/part caret: back-word tmp tmp
						][
							remove caret: back caret
						]
					]
					face/dirty?: true
				]
				del-char [
					if all [not delete-selected-text not tail? caret][
						either event/control [
							remove/part caret next-word caret
						][
							remove caret
						]
					]
					face/dirty?: true
				]
				left [move event [back-word caret][back caret]]
				right [move event [next-word caret][next caret]]
				up [move event page-up [move-y face liney * 0x-1]]
				down [move event page-down [move-y face liney * 0x1]]
				page-up [move event [head caret] page-up]
				page-down [move event [tail caret] page-down]
				home [move event [head caret][beg-of-line caret]]
				end [move event [tail caret][end-of-line caret]]
				enter [
					if flag-face? face return [
						if flag-face? face hide swap-text
						if flag-face? face tabbed [focus next-field face]
						action face face/data
						exit
					]
					insert-char face newline
				]
				copy-text [copy-text face unlight-text]
				cut-text [copy-text face delete-selected-text face/dirty?: true]
				paste-text [
					delete-selected-text
					face/line-list: none
					face/dirty?: true
					caret: insert caret read clipboard://
				]
				clear-tail [
					remove/part caret end-of-line caret
					face/dirty?: true
				]
				all-text [hilight-all face]
				tab-char [
					if flag-face? face tabbed [
						either in face 'refocus [face/refocus event/shift][
							tmp2: either event/shift [back-field face][next-field face]
							if flag-face? face hide swap-text
							if not event/shift [action face face/data] ; remove action on back-tab
							focus tmp2
						]
						exit
					]
					insert-char face tab
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
			show face
		]
	]

	;-- Feel used for active text:
	edit: make face/feel [

		redraw: func [face act pos][
			if all [in face 'colors block? face/colors] [
				face/color: pick face/colors face <> focal-face
			]
		]

		engage: func [face act event][
			switch act [
				down [
					either equal? face focal-face [unlight-text][focus/no-show face]
					caret: offset-to-caret face event/offset
					show face
				]
				over [
					if not-equal? caret offset-to-caret face event/offset [
						if not highlight-start [highlight-start: caret]
						highlight-end: caret: offset-to-caret face event/offset
						show face
					]
				]
				key [edit-text face event get in face 'action]
			]
		]
	]

	;-- Feel used for non-active text (still allow selection and copy)
	swipe: make face/feel [

		engage: func [face act event][
			switch act [
				down [
					either equal? face focal-face [unlight-text][set-focus-ring focus/no-show face]
					caret: offset-to-caret face event/offset
					show face
					face/action face face/text
				]
				up [
					if highlight-start = highlight-end [unfocus] ; wrong
				]
				over [
					if not-equal? caret offset-to-caret face event/offset [
						if not highlight-start [highlight-start: caret]
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
