REBOL [
	Title: "Super Styles"
	Short: "Super Styles"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %vid-super-styles.r
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
		Super Styles, which consists of complex panels.
	}
	History: []
	Keywords: []
]

stylize/master [

LAYOUT-COLOR: COMPOUND [
	style rgb-slider gradient-slider spring [bottom] 200x20 [
		face/parent-face/set-rgb-value face/parent-face face/channel value
		if value? 'call-back [call-back face/parent-face/data]
	]
	style fl field integer font-size 11 30x20 spring [left bottom] [
		set-face back-face face get-face face
		do-face back-face face none
	]
	style lbl label 75x20
	across
	lbl "Red"		rgb-slider	setup [0.0.0 127.0.0 255.0.0]		with [channel: 'r] fl return
	lbl "Green"		rgb-slider	setup [0.0.0 0.127.0 0.255.0]		with [channel: 'g] fl return
	lbl "Blue"		rgb-slider	setup [0.0.0 0.0.127 0.0.255]		with [channel: 'b] fl return
	lbl "Alpha"		rgb-slider	setup [0.0.0 0.0.0.127 0.0.0.255]	with [channel: 'a] fl
] with [
	; set RGB value from RGB slider
	set-rgb-value: func [face word value /local idx] [
		; set data value
		idx: index? find [r g b a] word value
		face/data/:idx: value
		; set text label
		idx: idx - 1 * 3 + 3
		set-face face/sliders/:idx value
	]
	; set slider from value
	set-slider: func [face value] [
		set-face/no-show face value
		set-face/no-show next-face face value
	]
	data: 0.0.0.0
	access: make access [
		set-face*: func [face value] [
			any [tuple? value exit]
			face/data: add 0.0.0.0 value
			foreach [idx chn] [2 1 5 2 8 3 11 4] [
				set-slider face/sliders/:idx face/data/:chn
			]
		]
		get-face*: func [face] [
			to-tuple reduce [
				get-face face/sliders/2
				get-face face/sliders/5
				get-face face/sliders/8
				get-face face/sliders/11
			]
		]
		clear-face*: func [face] [
			set-face* face 0.0.0
		]
	]
	sliders: none
	append init [
		sliders: self/pane
		set-face self data
	]
]

LAYOUT-DATE: COMPOUND [
	across
	arrow left [
		val: get-face face/parent-face
		val/month: val/month - 1
		set-face face/parent-face val
	]
	arrow right align [right] spring [left bottom] [
		val: get-face face/parent-face
		val/month: val/month + 1
		set-face face/parent-face val
	]
	text bold fill 1x0 center align [left right] spring [bottom]
	return
	date-nav-month
		spring [left right]
		on-scroll [set-face face/parent-face/pane/3 get-face face]
		on-key [set-face face/parent-face/pane/3 get-face face]
		on-click [set-face face/parent-face/pane/3 get-face face]
] with [
	access: make access [
		set-face*: func [face value] [
			if date? value [
				face/data: value
				set-face face/pane/3 form value
				set-face face/pane/4 value
			]
		]
		get-face*: func [face] [
			get-face face/pane/4
		]
	]
]

LAYOUT-USER: PANEL [
	across
	label "User Name" field return
	label "Password" field hide
]

LAYOUT-PASS: PANEL [
	across
	label "Password" field hide
]

LAYOUT-LISTS: COMPOUND [
	data-list 300x200
] with [
	access: make access [
		set-face*: func [face value] [
			if block? value [
				set-face/no-show face/pane/1 value
			]
		]
		get-face*: func [face] [
			; when returning items, they are formed
			; this is a thing with list. it returns the selected ones correctly
			; but it does not return the input data, which get-face in data-list probably should
			
			get-face face/pane/1 ; might need adjustment, because we want to return the selected entry
		]
	]
]

LAYOUT-LIST: LAYOUT-LISTS [
	data-list 300x200 with [select-mode: 'mutex]
]

LAYOUT-DIR: COMPOUND [
	; navigation crumb
	; list for directory
	; should be a full file list
	data-list 200x200
]

LAYOUT-DOWNLOAD: COMPOUND [
	; progress bar for a single file
	; text field for indicating name of file
	text 300 center
	progress fill 1x0
]

LAYOUT-DOWNLOADS: COMPOUND [
	; progress bar for total number of files
	; progress bar for a single file
	; text field for indicating name of file
	text 300 center
	progress fill 1x0
	text 300 center
	progress fill 1x0
]

LAYOUT-VALUE: PANEL [
	label "Enter Value" return
	field
]

LAYOUT-TEXT: PANEL [
	label "Enter Text" return
	text-area
]

LAYOUT-RENAME: PANEL [
	across
	label "Old Name" info return
	label "New Name" field return
]

LAYOUT-EMAIL: COMPOUND [
	across
	label "To" field validate [not empty? get-face face] required valid-indicator return
	label "Subject" field validate [not empty? get-face face] required valid-indicator return
	label "Text Body" text-area return
]

LAYOUT-MESSAGE: COMPOUND [
	across
	label "To" field validate [not empty? get-face face] required valid-indicator return
	label "Text Body" text-area return
]

LAYOUT-FIND: COMPOUND [
	across
	label "Search for" field return
	label "" check-line "Case Sensitive" return
]

LAYOUT-REPLACE: COMPOUND [
	across
	label "Search for" field return
	label "Replace with" field return
	label "" check-line "Case Sensitive" return
]

LAYOUT-INLINE-FIND: COMPOUND [
	right-panel [
		across label 70 "Search for"
		field 150 on-key [search-face face/parent-face/searched-face get-face face]
		text 100 "No results"
		space 0
		arrow 24x24 up [back-result face/parent-face]
		arrow down 24x24 [next-result face/parent-face]
	] return
] with [
	searched-face: none	; the face which this layout is communicating results to
	next-result: func [face /local results] [
		results: face/searched-face/results
		any [result exit]
		face/searched-face/results: either tail? next results [head results][next results]
		; redisplay search result
	]
	prev-result: func [face /local results] [
		results: face/searched-face/results
		any [results exit]
		face/searched-face/results: either head? results [back tail results][back results]
		; redisplay search result
	]
	get-result: func [face value] [
		; submit search query to search-face and have it return the result in a block
		search-face face/searched-face value
	]
	;init: [
	;	; some faces will support a new SEARCH-FACE accessor, which triggers search behavior for any face that supports search
	;	; [ ] - tie with searched face
	;	;searched-face: something
	;	;result: searched-face/result
	;]
]

LAYOUT-QUESTION: COMPOUND [
	across
	frame spring [right] 75x75 [
		image help.gif align [center] spring [left right top bottom]
	]
	panel fill 1x1 [body 200 fill 1x1 spring none]
] with [
	access: make access [
		set-face*: func [face value] [
			set-face find-style face 'body value
		]
	]
]

LAYOUT-ALERT: LAYOUT-QUESTION [
	across
	frame spring [right] 75x75 [
		image exclamation.gif align [center] spring [left right top bottom]
	]
	panel fill 1x1 [body 200x75 font-size 14 bold spring none]
]

LAYOUT-WARNING: LAYOUT-QUESTION [
	warning-frame [
		origin 4
		across
		frame spring [right] 75x75 [
			image exclamation.gif align [center] spring [left right top bottom]
		]
		panel fill 1x1 [body 200x75 font-size 14 bold spring none]
	]
]

LAYOUT-NOTIFY: LAYOUT-QUESTION [
	across
	frame spring [right] 75x75 [
		image info.gif align [center] spring [left right top bottom]
	]
	panel fill 1x1 [body 200x75 bold spring none]
]

LAYOUT-ABOUT: PANEL [
	across
	frame 300x200 [
		vh2 white 300 center spring [left right bottom]
		v-scroll-panel fill 1x1 [body -1x0 fill 1x1 center]
	]
] with [
	vh2: body: v-panel: none
	append init [
		header: system/script/header
		vh2: find-style self 'vh2
		v-panel: find-style self 'v-scroll-panel
		body: find-style self 'body
		set-face/no-show vh2 header/title
		set-face/no-show body trim to-string reduce [
			"Version: " header/version newline
			"Copyright: " header/copyright newline
			"License: " trim header/license newline
			"Date: " header/date newline
			"Author: " header/author/1 newline
			newline
			trim reverse trim reverse header/purpose
		]
	]
]

]