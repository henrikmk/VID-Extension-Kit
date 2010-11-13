REBOL [
	Title: "VID Search Faces"
	Short: "VID Search Faces"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-search.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 03-Feb-2009
	Date: 03-Feb-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {}
	History: []
	Keywords: []
]

stylize/master [
	SEARCH-FIELD: COMPOUND with [
		content: [
			across space 0
			field 150 spring none on-key [get in face 'action]
			button 24x24 "X" [
				context [
					f: face/parent-face/pane/1
					clear-face f
					do-face f none
				]
			]
			
		]
	]
	;search-field: panel [
	;	across space 0
	;	field 150 with [spring: none list-view: none columns: none] key-action [
	;		context [
	;			lv: get face/parent-face/list-view ; should not work like this
	;			; !!! - perform filtering on specific columns here
	;			; but how do we do that with out setting that up and tearing it down all
	;			; the time?
	;			; we need something far more flexible. i.e. an action on the field
	;			; that is managed differently
	;		]
	;	]
	;button 24x24 "X" [
	;	context [
	;		f: face/parent-face/pane/1
	;		clear-face f
	;		do-face f none
	;	]
	;]
	;] with [
	;	spring: [horizontal]
	;	list-view: none
	;]
	; not going to happen here
	;filter-words: selector with [list-view: none] [
	;	context [
	;		lv: get face/parent-face/list-view
	;	]
	;	print get-face face
	;]
]