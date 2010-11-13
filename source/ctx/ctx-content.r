REBOL [
	Title: "VID Text Content Formatting Context"
	Short: "VID Text Content Formatting Context"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-ctx-format.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 22-May-2009
	Date: 22-May-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		VID Text Standard Formatting Functions
	}
	History: []
	Keywords: []
]

ctx-content: [

; ---------- Content Formatters

; first letter capitalization
capitalize: func [face /local t] [
	t: face/text
	forall t [
		if head? t [uppercase/part t 1]
		if find [#" " #"-"] first t [uppercase/part t 2]
	]
]

; uppercase all letters
all-caps: func [face] [
	uppercase face/text
]

; restrict to numeric range
numeric-range: func [
	face range
	/local val min-val max-val
] [
	unless any [
		flag-face? face integer
		flag-face? face decimal
	] [exit]
	; empty face text
	val: any [attempt [to-decimal face/text] 0]
	min-val: first range
	max-val: second range
	if min-val [val: max min-val val]
	if max-val [val: min max-val val]
	if flag-face? face integer [val: to-integer val]
	face/data: val
	insert clear head face/text mold val
]

; don't know how to use this yet
numeric-step: func [face event step-size] [
	
]

; pad numbers for numeric display
zero-pad: func [
	face digits
] [
	unless any [
		flag-face? face integer
		flag-face? face decimal
	] [exit]
	change head face/text system/words/format/pad reduce [negate digits] face/text "0"
]

; substitutes text with a different text based on specific sequences of key-presses

substitute: none

context [

	buffer: make string! 100

	set 'substitute func [
		face event substitutions
		/local lb lc txt
	] [
		txt: copy face/text
		either all [
			find make bitset! [#"a" - #"z" #"A" - #"Z" #"0" - #"9"] event/key
		] [
			append buffer event/key
		][
			clear buffer
		]
		foreach [word completion] :substitutions [
			if word = buffer [
				lb: length? buffer
				lc: length? completion
				txt: remove/part at txt subtract index? system/view/caret lb lb
				insert txt copy completion
				clear buffer
				change head clear face/text head txt
				caret: add index? txt lc
			]
		]
	]

]

; password hide
;hide: func [face event /local l] [
;	; as each keystroke is done, it's replaced in text with a "*"
;	l: length? face/pass
;	make object! [
;		; problem here with the joining of text and data. it seems when writing data, text is still overwritten
;		; format will not allow the separation of text and data for this single case
;		; since text is hardwired to be displayed, there needs to be a different means of separating data and text
;		; or we need an alternative place to store data that is truly separated from text
;		pass: copy face/text
;		text: head insert/dup make string! l "*" l
;	]
;]

; encrypts each keystroke
encrypt: func [face event] [
	face
	; not sure how to capture and pass keystrokes yet, because we never store the string anywhere
]

; auto-completes text from a block of text strings
auto-complete: func [face event texts /local found-text new-text start-text] [
	if find [left right up down #"^H" #"^-"] event/key [exit]
	start-text: copy/part face/text index? system/view/caret
	found-text: none
	forall texts [
		if string? texts/1 [
			if find/match texts/1 start-text [found-text: copy texts/1 break]
		]
	]
	texts: head texts
	unless found-text [exit]
	insert clear head face/text found-text
	highlight-start: system/view/caret
	highlight-end: tail highlight-start
]

; trims the start and end of the given text of spaces
trim-text: func [face] [
	; figure out how to move or place the caret here
	insert clear head face/text trim face/text
]

]

ctx-content: context bind bind ctx-content ctx-text system/view