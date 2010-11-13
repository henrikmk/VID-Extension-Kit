REBOL [
	Title: "VID Text Editing Context"
	Short: "VID Text Editing Context"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009 - HMK Design"
	Filename: %vid-ctx-text.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 19-May-2009
	Date: 19-May-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		VID Text Editing Context with modifications.
	}
	History: []
	Keywords: []
]

ctx-text: [

	view*: system/view ; legacy

;-- Text highlight functions (but, do not reshow the face):

	hilight-body-start: func [face begin] [
		face/text-body/highlight-start: highlight-start: begin
	]

	hilight-body-end: func [face end] [
		face/text-body/highlight-end: highlight-end: end
	]

	hilight-text-body: func [face begin end][
		hilight-body-start face begin
		hilight-body-end face end
	]

	hilight-body-all: func [face][
		either empty? face/text [unlight-text-body face][
			hilight-body-start face head face/text
			hilight-body-end face tail face/text
		]
	]

	unlight-text-body: func [face] [
		hilight-body-start face none
		hilight-body-end face none
	]

	unlight-text: func [face] [
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
		"Tab focuses a specific face. Does not set focus ring."
		face
		/no-show "Do not show change yet."
		/no-save
		/local tmp-face
	] [
		tmp-face: face
		either no-save [unfocus/no-save][unfocus]
		unless face [return none]
		unless flag-face? face tabbed [
			any [
				face: find-relative-face face [flag-face? face tabbed]
				return none
			]
		]
		set-tab-face face
		unless get-tab-face face [exit]
		if any [
			flag-face? face text-edit
			flag-face? face full-text-edit
		] [ ; if it's an editable text face
			focal-face: face
			if not string? face/text [
				face/text: either face/text [form face/text] [copy ""]
				face/line-list: none
			]
			if not caret [
				set-caret face
					either all [
						flag-face? face keep
						face/text-body/caret
					] [
						face/text-body/caret
					][
						tail face/text
					]
			]
			if none? face/line-list [
				if face/para [face/para/scroll: 0x0]
				if not flag-face? face keep [
					set-caret face tail face/text
				]
			]
			case [
				; re-create highlight
				flag-face? face keep [
					probe 'rehighlight
					hilight-text
						face
						probe face/text-body/highlight-start
						face/text-body/highlight-end
				]
				flag-face? face field [
					hilight-all face
				]
			]
		]
		ctx-act/act face none 'on-focus
		if not no-show [show face]
		face
	]

	;set 'unfocus func [
	;	"Removes the current key event focus."
	;	/local tmp-face
	;][
	;	; (Clears related globals, even if no focal-face.)
	;	tmp-face: focal-face
	;	focal-face: none
	;	caret: none
	;	unlight-text
	;	if tmp-face [show tmp-face]
	;]

	; move this into vid-ctx-text
	set 'unfocus func [
		{Removes the current key event focus.}
		/local tmp-face
		/no-save "Do not perform save-face for the face"
	] [
		tmp-face: focal-face
		focal-face: none
		if tmp-face [
			either flag-face? tmp-face keep [
				; destroy visible highlight, but keep it in the face
				set-caret tmp-face none
				unlight-text tmp-face
			][
				; destroy highlight in face
				caret: none
				unlight-text-body set 'hh tmp-face
			]
			; according to ctx-text, this should not happen here on tabbed faces
			; consider some redesigning here to ease the flow
	;		unless flag-face? tmp-face tabbed [
			; [ ] - save-face should only occur when unfocusing with the mouse
			; [ ] - save-face must not occur when unfocusing by keyboard
			; [ ] - method to detect keyboard vs. mouse in here
	;		any [no-save save-face tmp-face]
	;		]
			; we need to store the face content always on unfocus, but there seems not to be a method for that
	;		unset-focus-ring tmp-face ; this happens quite often
			show tmp-face
			ctx-act/act tmp-face none 'on-unfocus
		]
	]

;-- Copy and delete functions:

	copy-selected-text: func [face /local start end][
		if all [
			hilight?
			not flag-face? face hide
		][
			set [start end] hilight-range? face
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

	delete-selected-text: func [/local face start end][
		if hilight? [
			face: focal-face
			set [start end] hilight-range? face
			if flag-face? face hide [remove/part at face/text index? start index? end]
			remove/part start end
			caret: start
			face/line-list: none
			unlight-text-body
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

	set-caret: func [face caret*] [
		caret: caret*
		if object? face [face/text-body/caret: caret]
		caret
	]

;-- Line:

	tab-size: 4

	;text-body: context [
	;	head: 0x0	; start of text vs. visible start of text in field
	;	caret: 0x0	; caret position in text vs. number chars in line
	;	tail: 0x0	; end of text vs. visible end of text in field
	;	lines: 0x0	; longest line vs. number of lines in text
	;	line: 0x0	; current visible line vs. current text line
	;	size: 0x0	; pixel size of the text
	;]

	; calculates character offsets including tab size
	tab-offset?: func [pos-start pos-end /local offset tabs] [
		tabs: 0
		repeat i offset: offset? pos-start pos-end [
			if #"^-" = pick pos-start i [
				tabs: tabs + 1
			]
		]
		tabs * tab-size + offset - tabs
	]

	; [!] - consider where to use this function
	; [!] - lines can't be used to calc text height when wrap? is used, so use size-text for that
	set-text-body: func [face caret /local ft lines] [
		; face must have text body
		unless ft: face/text-body [return none]
		unless all [face/text caret] [return ft/lines: ft/caret-pos: none] ; really? seems too simple
		insert tail face/text #"^/" ; parse correct number of lines
		lines: parse/all face/text "^/"

		; text dimensions by characters
		ft/start:				index? face/text
		ft/top:					index? offset-to-caret face 4x4 ; wrong
		ft/lines:				round face/size/y - face/para/margin/y / face/font/size ; reasonable calculation of number of lines
		ft/bottom:				min length? lines ft/top + ft/lines ; end of visible text line would be 
		ft/end:					length? lines ; wrong
		ft/caret-pos:			beg-of-line caret
		ft/caret-pos:			as-pair tab-offset? ft/caret-pos caret tab-offset? ft/caret-pos end-of-line caret ; OK
		ft/line:				ft/end + 1 - length? parse/all caret "^/"
		remove back tail face/text

		; corrections for View bugs
		if empty? face/text		[face/para/scroll: 0x0]
		if ft/line = 1			[face/para/scroll/y: 0]
		if ft/caret-pos/x = 0	[face/para/scroll/x: 0]

		; pixel dimensions
		ft/size:				size-text face
		ft/area:				face/size - (any [all [object? face/edge face/edge/size/y * 2] 0]) - face/para/origin - face/para/margin

		; clamping of para/scroll
		face/para/scroll/y:		max min 0 ft/area/y - ft/size/y min 0 face/para/scroll/y
		face/para/scroll/x:		max min 0 ft/area/x - ft/size/x min 0 face/para/scroll/x

		; ratios of text area
		ft/v-ratio: 			min 1 ft/area/y / max 1 ft/size/y
		ft/h-ratio: 			min 1 ft/area/x / max 1 ft/size/x
		ft/v-scroll:			abs face/para/scroll/y / max 1 ft/size/y - ft/area/y
		ft/h-scroll:			abs face/para/scroll/x / max 1 ft/size/x - ft/area/x
		ft
	]

; need to keep a line-buffer, which stores various information on length of the text on the go
; so this stuff doesn't need to be recalculated all the time
; we can parse our way through the newlines
; and then perform a tab-offset? per newline, and the store that number in the block
; we should probably store the block in text-body somehow
; lines should be stored as that block instead of the pairs
; nof lines
; longest line
; current line


	;set-text-body: func [face caret /local ft] [
	;	any [all [face/text caret] return face/lines: face/caret: none]
	;	insert tail face/text #"^/" ; parse correct number of lines
	;	ft: face/text-body
	;	ft/head:	as-pair index? face/text index? offset-to-caret face 4x4 ; OK
	;	ft/caret:	beg-of-line caret ; OK
	;	ft/caret:	as-pair tab-offset? ft/caret caret tab-offset? ft/caret end-of-line caret ; OK
    ;
	;	; end of text in field is done by measuring the end point of the text
	;	ft/tail:	as-pair length? face/text index? offset-to-caret face as-pair 4 face/size/y - 4 ; First OK, check second for correct corner
; co;nvert values to pairs. all as integers in pairs
; ne;ed to continue with this
; th;ere are issues with non-propportional texts, so we may not be able to deliver all the info we want
    ;
	;	ft/lines:	to-pair length? parse/all face/text "^/" ; total number of lines, OK
	;	; how do we calculate the longest line quickly?
	;	; the thing is that certain information is not necessary to recalculate all the time
	;	; so this should be grouped in various things
	;	; we are not handling wrapped lines either
	;	; need also to handle line length with tabs
	;	; this is the worst one, since we need to keep a list of integers describing line length here
	;	; that list should be parsed up once, and then manipulated in small ways through editing
    ;
	;	ft/lines/1:	ft/lines/1 + 1 - length? parse/all caret "^/" ; Not OK, investigate
	;	ft/line:	to-pair ft/lines/2 + 1 ; Not OK, garbage
	;	ft/size:	size-text face ; OK, but eats memory?
	;	
	;	;face/text-pos: make object! [
	;	;	head: face/text
	;	;	start: 
	;	;	caret: 
	;	;	end: 
	;	;	tail: system/words/tail
	;	;	lines: length? parse/all face/text "^/"
	;	;	line: lines + 1 - length? parse/all caret "^/"
	;	;]
	;	;face/lines:
	;	;	as-pair
	;	;		lines + 1 - length? parse/all caret "^/"
	;	;		lines
	;	remove back tail face/text
	;]

;-- Text Field Functions:

	; may be obsolete
	set 'clear-fields func [
		"Clear all text fields faces of a layout."
		panel [object!]
	][
		if not all [in panel 'type panel/type = 'face] [exit]
		unfocus
		foreach face panel/pane [
			if all [series? face/text flag-face? face field] [
				clear-face/no-show face
			]
		]
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

	keys-to-insert: func [face /local base] [
		base: case [
			flag-face? face integer [integer-keys]
			flag-face? face decimal [decimal-keys]
			true [base-keys]
		]
		if flag-face? face sign [base: union base sign-key]
		if flag-face? face full-text-edit [base: union base nav-keys]
		base
	]

	insert-char: func [face char][
		delete-selected-text
		; For password spoofed text (***), the above may put caret on wrong face.
		; Check, and restore proper caret, otherwise we lose a character.
		if not same? head face/text head caret [set-caret face at face/text index? caret]
		face/dirty?: true
		; The caret may be off the end, so just append if it is.
		if error? try [set-caret face insert caret char][append caret char]
	]

	move: func [event ctrl plain] [
		; Deal with cursor movement, including special shift and control cases.
		either event/shift [any [highlight-start hilight-body-start focal-face caret]][unlight-text-body focal-face]
		set-caret focal-face either event/control ctrl plain
		if event/shift [either caret = highlight-start [unlight-text-body focal-face][hilight-body-end focal-face caret]]
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
		if flag-face? face hide swap-text: [
			tmp: face/text
			face/text: face/data
			face/data: tmp
			set-caret face either error? try [index? caret] [tail face/text] [
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
							ctx-act/act face event 'on-tab
;							ctx-format/format face event 'on-tab
							set-focus-ring focus face: find-style face face/style
							set-caret face head caret
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

		;-- Key action handling:
		if word? key [ ;probe key

			page-up: [move-y face face-size - liney - liney * 0x-1]
			page-down: [move-y face face-size - liney * 0x1]

			; Most frequent keys are first:
			do select [
				back-char [
					if all [flag-face? face auto-tab not hilight? head? caret] [
						set-focus-ring focus/no-show find-style/reverse face face/style
						unlight-text
						set-caret face tail caret
					]
					if all [not delete-selected-text not head? caret][
						either event/control [
							tmp: caret
							remove/part set-caret face back-word tmp tmp
						][
							remove set-caret face back caret
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
				left [
					if flag-face? face auto-tab [
						if 1 = index? caret [
							ctx-act/act face event 'on-tab
;							ctx-format/format face event 'on-tab
							set-focus-ring focus/no-show find-style/reverse face face/style
							exit
						]
					]
					move event [back-word caret][back caret]
				]
				right [
					if flag-face? face auto-tab [
						if tail? caret [
							ctx-act/act face event 'on-tab
;							ctx-format/format face event 'on-tab
							set-focus-ring focus/no-show find-style face face/style
							set-caret face head caret
							exit
						]
					]
					move event [next-word caret][next caret]
				]
				up [move event page-up [move-y face liney * 0x-1]]
				down [move event page-down [move-y face liney * 0x1]]
				page-up [move event [head caret] page-up]
				page-down [move event [tail caret] page-down]
				home [move event [head caret][beg-of-line caret]]
				end [move event [tail caret][end-of-line caret]]
				enter [
					if flag-face? face return [
						if flag-face? face hide swap-text
;						if flag-face? face tabbed [focus next-field face]
						action face face/data
						ctx-act/act face event 'on-return
;						ctx-format/format face event 'on-return
						if empty? face/text [clear-face face]
						exit
					]
					insert-char face newline
				]
				copy-text [copy-text face unlight-text face] ; why unlight?
				cut-text [copy-text face delete-selected-text face/dirty?: true]
				paste-text [
					delete-selected-text
					face/line-list: none
					face/dirty?: true
					set-caret face insert caret read clipboard://
				]
				clear-tail [
					remove/part caret end-of-line caret
					face/dirty?: true
				]
				all-text [hilight-all face]
				escape [
					ctx-act/act face event 'on-escape
;					ctx-format/format face event 'on-escape
					unfocus
				]
				tab-char [
					either all [
						flag-face? face tabbed
						not flag-face? face full-text-edit
					] [
						ctx-act/act face event 'on-tab
;						ctx-format/format face event 'on-tab
						if empty? face/text [clear-face face]
						exit
					][
						insert-char face tab
					]
				]
			] key
		]

		;-- Scroll the face?
		if face: focal-face [
			if flag-face? face hide [
				unlight-text face
				insert/dup clear face/data "*" length? face/text
				do swap-text
			]
			tmp: any [caret-to-offset face caret  caret-to-offset face set-caret face tail face/text]
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
			ctx-act/act face event 'on-key
;			ctx-format/format face event 'on-key
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
					; this is mouse only
					either equal? face focal-face [
						; already focusing
						unlight-text face
						set-caret face offset-to-caret face event/offset
					][
						; now focusing
						focus/no-show face
						set-caret face
							either flag-face? face keep [
								; at last location
								probe face/text-body/caret
							][
								; at current mouse offset
								offset-to-caret face event/offset
							]
					]
					show face
				]
				over [
					if not-equal? caret offset-to-caret face event/offset [
						if not highlight-start [highlight-start: caret]
						hilight-end face set-caret face offset-to-caret face event/offset
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
					either equal? face focal-face [unlight-text face][focus/no-show face]
					set-caret face offset-to-caret face event/offset
;					set-face-caret face caret
					show face
					face/action face face/text
				]
				up [
					if highlight-start = highlight-end [unfocus]
				]
				over [
					if not-equal? caret offset-to-caret face event/offset [
						if not highlight-start [hilight-body-start face caret]
						hilight-body-end face set-caret face offset-to-caret face event/offset
;						set-face-caret face caret
						show face
					]
				]
				key [
					if 'copy-text = select keymap event/key [
						copy-text face unlight-text face
					]
				]
			]
		]
	]
]

; Note: ctx-text was once a full external module. Now it is bound in View context
; to reduce PATH references.
ctx-text: context bind ctx-text system/view
foreach word [hilight-text-body hilight-all unlight-text-body][
	set word get in ctx-text word
]
