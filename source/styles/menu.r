REBOL [
	Title: "VID Menus"
	Short: "VID Menus"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %menu.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 28-Jul-2009
	Date: 28-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Pop Up Menus and Menubar styles
	}
	History: []
	Keywords: []
]

stylize/master [
	; menu bar situated at top of screen
	MENU-BAR: FACE-CONSTRUCT with [
		fill: 1x0
		size
		obj: objs: stack: menus: none
		menu-items: [
			(append/only objs make block! [])
			any [
				(append stack make object! [])
				[
					[
						'item set n string! (set-stack [name: n]) [
							any [
								'key set key block! (set-stack [shortcut: key])
								| 'action set act block! (set-stack [action: act])
								| 'submenu into menu-items (
									set-parent-stack [menu: last objs]
									remove back tail objs
								)
							]
						]
					]
					| [
						'- (set-stack [name: none])
					]
				]
				(append last objs last stack remove back tail stack)
			]
		]
		do-setup: func [items /local i] [
			emit [space 0 across]
			stack: make block! []
			menus: make block! []
			set-stack: func [vals] [
				change back tail stack make last stack vals
			]
			set-parent-stack: func [vals /local s] [
				s: back back tail stack
				change s make first s vals
				remove next s
			]
			objs: make block! []
			parse items menu-items
			objs: first objs
			i: 0
			foreach obj objs [
				i: i + 1
				if all [in obj 'menu block? obj/menu] [
					append menus compose/deep [at 0x0 menu-items with [source: [(obj/menu)]]]
				]
				emit compose/deep [
					menu-button (any [all [in obj 'name obj/name] "Untitled"]) of (to-lit-word 'menu-bar) [
						hide-popup menus
						if get-face face [
							; [ ] - build this together into a single function
							use [m] [
								m: pick menus (i)
								m/options: unique append any [m/options copy []] [no-border no-title]
								inform/title/offset m "" face/win-offset + 0x24 + get in root-face face 'offset
							]
						]
					]
				]
			]
			menus: get in layout/tight menus 'pane
			lo
		]
		data: [
			; [ ] - use optional images for each menu entry
			; [ ] - consider how to combine this for use with menu-items
			;       [ ] - convert the dialect to a set of objects as used by menu-items
			item "File" submenu [
				item "New" key [Ctrl N] action [print "New Document"]
				item "Open" key [Ctrl O] action [print "Open Document"]
				item "Close" key [Ctrl W] action [print "Close Document"]
				item "Save" key [Ctrl S] action [print "Save Document"]
				item "Save As..." key [Shift Ctrl S] action [print "Save Document As"]
				-
				item "Import" submenu [
					item "Lightwave Obj..." action [print "Import Lightwave Obj"]
					item "IFF File..." action [print "Import IFF File"]
					item "MP3..." action [print "Import MP3"]
				]
				-
				item "Quit" key [Ctrl Q] action [print "Quit"]
			]
			item "Edit" submenu [
				item "Cut" key [Ctrl X]
				item "Copy" key [Ctrl C]
				item "Paste" key [Ctrl V]
				-
				item "Select All" key [Ctrl A]
			]
			item "Window" submenu []
			item "About" submenu [
				item "About Program..."
				item "Help..." action [print "Help"]
			]
		]
		; [ ] - consider how to render items
		;       [ ] - items can be parsed
		;       [ ] - possibly use an iterated face
		;             [ ] - use a standard layout mechanism to generate the layout
		;             [ ] - faces must vary in size
		;             [ ] - render separator
		;             [ ] - use construct for the menu items
		;             [ ] - process to get items as data into the layout. then the layout is generated
		;       [x] - width is fill
		; [ ] - ease of generating win style menus
		; [ ] - ease of generating mac style menus
	]

; the menu list would be containing data as key/value pairs, but there are shortcuts too and possibly icons. this means
; there are 3 columns potentially here that we need to deal with
; so what is passed to menu items should be a block containing the necessary values
; the images might be an issue, but maybe we can build in supporting images now
; by using the cellfunc differently
; the easy way to manage this is to test this function solely for that

	MENU-TEXT: LIST-TEXT-CELL with [
		size: -1x24
		font: make font [valign: 'middle]
		feel: make feel [
			engage: func [face act event /local fp] [
				fp: face/parent-face
				probe event/offset
				probe event/type
				; [ ] - if event is move, and we move away, the face is not updated
				if event/type = 'up [
					if block? get in fp 'action [
						; [ ] - close all menus from viewing
						do func [face value] fp/action fp get-face fp
					]
				]
			]
			over: func [face act pos] [
				; it should be possible to remove selection somehow
				; but the code for it now appears to be quite difficult to make
				; still haven't found a method yet, but the closest one seems to be parent to this one
				; we can use this one and it seems to be the only one we can use
				; so we need a method here to deal with it in relation to the parent
				; over and away is not used here
				; [ ] - keep highlight when visiting a submenu
				;       [ ] - we can't by default just unset selection on away
				
				show face/parent-face/pane
			]
		]
	]
	
	MENU-IMAGE: IMAGE with [
		feel: make feel [
			engage: func [face act event /local fp] [
				fp: face/parent-face
				if event/type = 'down [
					if block? get in fp 'action [
						; [ ] - close all menus from viewing
						do func [face value] fp/action fp get-face fp
					]
				]
			]
			over: func [face act pos] [
				show face/parent-face/pane
			]
		]
	]

	; single menu list
	MENU-ITEMS: DATA-LIST with [
		size: -1x-1
		definition: reduce [
			'state make column [width: 24 cell-type: 'menu-text]
			'name make column [cell-type: 'menu-text]
			'shortcut make column [width: 60 cell-type: 'menu-text font: [align: 'left]] ; this can actually switch between two cell-types, but we might keep it at text for now
		]
		resize-column: 'name
		access: make access [
			scroll-face*:
			resize-face*: none
		]
		row: make object! [state: name: shortcut: none]
		spring:
		align:
		separatorface:
		subfunc:
		cellfunc:
		selection:		; currently selected item in the menu
		menus:			; submenu faces for this menu
		submenu:		; currently shown submenu face
		offsets: none	; cached list of offsets for each face in the menu
		feel: make feel [
			; feels are not run here because of feels in the upper layers
			detect: func [face event] [
				probe event/type
			]
			; this is also not run
			over: func [face act pos] [
				probe act
			]
		]
		panefunc: func [face id /local row fs] [
			; [ ] - unhighlight on away, but we may need the feel to do that. we can't use this face for that
			if pair? id [
				face/selection: none
				until [
					all [
						not tail? face/offsets
						id/y < first face/offsets
						face/selection: (index? face/offsets) - 1
					]
					face/offsets: next face/offsets
					any [
						face/selection
						tail? face/offsets
					]
				]
				face/offsets: head face/offsets
				; [o] - redraw the full row instead of the face we are over
				; [ ] - get rid of white color spacing between second and third item
				; [o] - display all styles properly
				; [ ] - method to redraw a submenu
				;       [ ] - method to say that the submenu should only be drawn once
				return face/selection
			]
			row: pick face/source id
			either row [
				either row/name [
					fs: face/sub-face
					fs/pos: id
					set-face/no-show fs/pane/1 if in row 'state [row/state]
					set-face/no-show fs/pane/2 row/name
					set-face/no-show fs/pane/3 if in row 'shortcut [form row/shortcut]
					; [!] - stock image here
					fs/pane/3/effect: if in row 'menu [[draw [image 40x2 load-stock arrow-right]]]
					either id = face/selection [
						fs/pane/1/color:
						fs/pane/2/color:
						fs/pane/3/color:
							ctx-colors/colors/focus-ring-color
						if all [object? face/submenu face/submenu/pos <> id] [
							; this works, now we need to display the submenu so we can undisplay it
							;print ["clearing old submenu" face/submenu/pos]
							hide-popup face/submenu
							face/submenu: none
						]
						fs/action: if in row 'action [get in row 'action]
						if in row 'menu [
							if face/submenu <> select face/menus id [
								face/submenu: select face/menus id
								; [ ] - find the submenu face using pos
								; [!] - for multiples of the same menu (using tear off), you need multiple faces
								; [ ] - method to display face/submenu in a subwindow here
								; [o] - viewing must occur without extra window button in taskbar
								; [ ] - make events work for show-popup
								; [ ] - set proper size for submenu
								; [ ] - set the position for submenu
								inform/title/offset face/submenu "" face/offset + 20x20
								;print ["displaying submenu" id]
								; [ ] - set options to no-border and no-title for the submenu
							]
						]
					][
						fs/pane/1/color:
						fs/pane/2/color:
						fs/pane/3/color:
							none
					]
				][
					fs: face/separatorface
				]
				fs/offset: fs/old-offset: as-pair 0 pick offsets id
				fs
			][
				none
			]
		]
		init: [
			if none? row [row: make object! [data: none]]
			if none? self/source [self/source: make block! []]
			make-sub-face self make-sub-face-layout row
			separatorface: make get-style 'bar [size: 2x2]
			separatorface/parent-face: self
			pane: :panefunc
			offsets: make block! length? head self/source
			append offsets 0
			use [name-face old-x x id] [
				id: x: 0
				name-face: sub-face/pane/2
				old-x: name-face/size/x
				name-face/size/x: 500
				foreach item self/source [
					id: id + 1
					name-face/text: item/name
					x: max x 50 + name-face/para/origin/x + first size-text name-face
					append offsets
						either item/name [
							sub-face/size/y
						][
							separatorface/size/y
					]
					if in item 'menu [
						menus: any [menus make block! []]
						; [o] - create list of faces for each submenu
						; [o] - consider how to initialize each face for each submenu
						insert insert tail menus
							id
							make get-style 'menu-items [
								source: item/menu
								pos: id
							]
					]
					change back tail offsets
						add last offsets pick tail offsets -2
				]
				resize/no-show sub-face sub-face/size + as-pair x - old-x 0 0x0
			]
			either none? size [
				size: 0x0
				size/x: sub-face/size/x
				size/y: 100
			][
				if pair? size [
					if size/x = -1 [
						size/x: sub-face/size/x
					]
					if size/y = -1 [
						size/y: last offsets
					]
				]
			]
			size: size + edge-size? self
			ctx-resize/do-align separatorface self
		]
		; [ ] - consider how to specify data
		; [ ] - consider how to specify shortcuts
		; [ ] - consider standard menu items
		; [x] - vertical size of list is determined by number of entries in list
		;       [x] - consider how to calculate vertical size using cell-height and number of entries in source
		;       [x] - initialize vertical size from height inside INIT
		; [ ] - horizontal size of list is determined by max-size of the biggest entry in the list
		;       [ ] - consider how to calculate horizontal max-size
		; [ ] - consider rendering images in a column
	]
]