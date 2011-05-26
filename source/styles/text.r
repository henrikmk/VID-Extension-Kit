REBOL [
	Title: "Text faces for VID"
	Short: "Text faces for VID"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %text.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Jun-2009
	Date: 02-Jun-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Various text faces for VID
	}
	History: []
	Keywords: []
]

stylize/master [
	BASE-TEXT: FACE with [
		text: "Text"
		size: image: color: none
		access: ctx-access/text
		edge: none
		flags: [text]
		font: [color: black shadow: none colors: [0.0.0 40.40.40]]
		xy: none
		doc: [
			info: "Base text style"
			string: "Text contents"
			integer: "Width of text area"
			pair: "Width and height of text area"
			tuple: ["text color" "background color"]
			block: ["execute when clicked" "execute when alt-clicked"]
		]
		init: [
			if all [not flag-face? self as-is string? text] [trim/lines text]
			if none? text [text: copy ""]
			change font/colors font/color
			if none? size [size: -1x-1]
			if size/x = -1 [
				size/x: first face-size-from-text self 'x
				; limit by parent-face size
			]
			if size/y = -1 [
				size/y: second face-size-from-text self 'y
				; limit by parent-face size
			]
		]
	]

	VTEXT: BASE-TEXT with [
		feel: ctx-text/swipe
		font: [color: black shadow: 0x0 colors: ctx-colors/colors/font-color]
		doc: [info: "Video text (light on dark)"]
		insert init [
			if :action [feel: svvf/hot saved-area: true]
		]
	]

	; Text style with string/numeric awareness
	TEXT: VTEXT
		ctx-colors/colors/body-text-color
		shadow none
		doc [info: "Document text"]
		with [
			text: "Text"
			words: compose [
				decimal (
					func [new args][
						flag-face new decimal
						args
					]
				)
				integer (
					func [new args][
						flag-face new integer
						args
					]
				)
				range (func [new args][new/range: reduce second args args: next args])
			]
			numeric: func [face] [
				any [
					flag-face? face integer
					flag-face? face decimal
				]
			]
			access: make access [
				; [!] - this is duplicated from feel and is outdated
				get-face*: func [face] [face/data]
				set-face*: func [face value] [
					if face/para [face/para/scroll: 0x0]
					either all [in face 'numeric face/numeric face] [
						face/data:
							case [
								integer? value [value]
								decimal? value [value]
								all [series? value empty? value] [0]
								error? try [to-decimal value] [0]
								equal? to-integer value to-decimal value [to-integer value]
								true [to-decimal value]
							]
						face/text: form face/data
					][
						face/text: face/data: either value [form value][copy ""]
					]
					face/line-list: none
				]
			]
		]

	; Various text styles based on TEXT and VTEXT
	BODY: TEXT "Body" with [
		spring: [bottom]
		size: -1x-1 ; automatically fill horizontally
		; reflows the text and is used during resize
		reflow: func [face /local old diff] [
			;-- Determine vertical size from reflowed text
			old: face/size
			face/size/y: -1
			sz: face-size-from-text face 'y
			face/size/y: sz/y
			if face/real-size [face/real-size: face/size]
			; the maximum x-size is the width of text or width of current face/size/x
			; [ ] - there are issues when resizing down in width, not up, so we will keep it at full width for now
			;szz: face-size-text face
			;face/real-size/x: face/size/x: min szz/x face/size/x ; doesn't work properly
			;-- Push or pull remaining faces using the difference
			; [ ] - reflow only text-faces somehow, not all sorts of faces
			; which is why I wasn't keen on this in the first place
			faces: next find face/parent-face/pane face
			if tail? faces [exit] ; nothing to push or pull
			diff: face/size - old
			foreach f faces [
				f/offset/y: f/offset/y + diff/y
				f/win-offset/y: f/win-offset/y + diff/y
			]
		]
		append init [
			insert-actor-func self 'on-resize :reflow
			insert-actor-func self 'on-set :reflow
		]
	]
	TXT: TEXT
	BANNER: VTEXT "Banner" ctx-colors/colors/title-text-color bold font-size 24 center middle shadow 3x3
		doc [info: "Video text title"]
	VH1: BANNER "Video Text" ctx-colors/colors/title-text-color font-size 20 doc [info: "Video text heading"]
	VH2: VH1 font-size 16 shadow 2x2
	VH3: VH2 font [style: [bold italic]]
	VH4: VH2 font-size 14

	LABEL: VTEXT "Label" middle bold feel none doc [info: "label for dark background"]
	VLAB: LABEL 72x24 right doc [info: "label for dark forms, right aligned"] ; seems to make little sense with that name
	LBL: TEXT "Label" bold middle feel none doc [info: "label for light background"] ; seems to make little sense with that name
	LAB: LBL 72x24 right doc [info: "label for light forms, right aligned"] ; seems to make little sense with that name

	TITLE: BODY "Title" bold font-size 24 center middle doc [info: "document title"]
	H1: BODY "Header" bold font-size 20 para [wrap?: none] doc [info: "document heading"] fill 1x0
	H2: H1 font-size 16
	H3: H2 font-size 14
	H4: H3 font-size 12
	H5: H4 font [style: [bold italic]]
	TT: TXT font-name font-fixed doc [info: "typewriter text (monospaced)"]
	CODE: TT "Code" bold doc [info: "source code text (monospaced)"]
]