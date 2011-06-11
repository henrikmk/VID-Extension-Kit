REBOL [
	Title: "DOC style"
	Short: "DOC style"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %doc.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 22-May-2010
	Date: 22-May-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		DOC style based on make-doc
	}
	History: []
	Keywords: []
]

;temp-ctx-doc: context [
;
;	space: charset " ^-"
;	nochar: charset " ^-^/"
;	para-start: charset [#"!" - #"~"]
;
;	emit-para: funct [
;		"Emit a paragraph with minor markup."
;		out [block!] "A richtext block"
;		para "marked-up string"
;	][
;		; !!Note: load/markup is missing in current 3.0 alpha
;		; so use simple (too simple) method...
;		while [all [para not tail? para]] [
;			either spot: find para #"<" [
;				append out copy/part para spot
;				para: either end: find/tail spot #">" [
;					switch copy/part spot end [
;						"<b>" [append out 'bold]
;						"</b>" [append out [bold off]] ; bug
;						"<i>" [append out 'italic]
;						"</i>" [append out [italic off]] ; bug
;						"<em>" [append out [bold italic]]
;						"</em>" [append out [bold off italic off]] ; bug
;					]
;					end
;				][
;					next spot
;				]
;			][
;				append out copy/part para tail para
;				para: none
;			]
;		]
;		append out [newline newline]
;	]
;
;	set 'parse-doc funct [
;		"Parse the doc string input. Return rich-text output."
;		text [string!]
;	][
;		text: trim/auto detab text
;		if newline <> last text [append text newline]
;		out: make block! (length? text) / 20 + 1 ; a guess
;		emit: func [data] [repend out data]
;		s: none
;		para: make string! 20
;		; This is bad and must be changed:
;		ft: what-font? 'title
;		fb: what-font? 'base
;		fc: what-font? 'code
;		emit [
;			'font fb/font
;			'para fb/para
;			'anti-alias ft/anti-alias
; 		]
;
;		parse/all text [
;			some [
;				"###" break
;				|
;					; Heading line:
;					"===" copy s to newline skip (
;						emit [
;							'font ft/font
;							s
;							'drop ;<-richtext bug?
;							'font fb/font
;							'newline 'newline
;						]
;					)
;				|
;					; Gather and emit a paragraph:
;					some [copy s [para-start to newline] (repend para [s " "]) skip]
;						(emit-para out para clear para)
;				|
;					; Gather and emit a code block:
;					some [copy s [space thru newline] (append para s)] (
;						emit [
;							'font fc/font
;							copy para
;							'drop 1
;							'font fb/font
;							'newline 'newline
;						]
;						clear para
;					)
;				|
;					newline
;					opt [newline (emit 'newline)]
;			]
;		]
;
;		out
;	]
;]

stylize/master [
	DOC: TEXT-AREA spring none with [
		
	]
]