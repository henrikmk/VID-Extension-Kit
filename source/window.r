REBOL [
	Title: "VID Window Functions"
	Short: "VID Window Functions"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %window.r
	Version: 0.0.2
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Jan-2009
	Date: 31-Mar-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Simple functions for creating resizable windows and panes.
	}
	History: []
	Keywords: []
]

; creates a layout face
make-window: func [pane /options opts] [
	if object? pane [
		if find ctx-vid-debug/debug 'face [dump-face pane]
		return pane
	]
	layout/parent
		pane
		make
			get-style 'resizable-window
			[
				color: ctx-colors/colors/window-background-color
				feel: make object! [
					redraw: none
					detect: get in system/view/window-feel 'detect
					engage: none
					over: none
				]
				options: any [
					all [opts unique append copy options opts]
					options
				]
				valid: make object! [
					action: ; perform an overall validation action here?
					result: none
					required: false
				]
			]
]

; determines if the given window is a VID window with tab-face
vid-window?: func [face /local fc fcr] [
	fc: root-face face
	all [
		in fc 'style
		fc/style = 'window
		fc/pane
		block? fc/pane
		4 <= length? fc/pane
		in fc 'focus-ring-faces
		fcr: fc/focus-ring-faces
		fcr/1/style = 'highlight
		fcr/1/style = fcr/2/style
		fcr/2/style = fcr/3/style
		fcr/3/style = fcr/4/style
	]
]

; determines if a window is open and returns it
window-open?: func [face /local win] [
	; must be the same object, for this to work
	win: find system/view/screen-face/pane face
	if win [first win]
]

; performs a method on the window, such as activate, maximize, etc.
do-window: func [face changes /local word win] [
	if win: window-open? face [
		set in first win 'changes changes
		foreach word changes [
			word: select [
				text		on-text
				minimize	on-minimize
				maximize	on-maximize
				activate	on-activate
				offset		on-offset
				restore		on-restore
			] word
			if word [act-face face none word]
		]
		show win
		true
	]
]

; activates a window
activate-window: func [face] [
	do-window face [activate]
	; perform ON-DEACTIVATE actor for all other windows in screen-face
	foreach window system/view/screen-face/pane [
		act-face window none 'on-deactivate
	]
]

; maximizes a window
maximize-window: func [face] [do-window face [maximize]]

; displays a face as a window and manages the face in the window list
; unused
display-window: func [face title /event fnc] [
	unless activate-window face [
		view/new/title center-face face title
		if fnc [insert-event-func fnc]
	]
]

; Gets the root face for a given face where the root face contains a given word
; [!] - unused
get-parent: func [face word /local pf] [
	unless pf: face/parent-face [return if in face :word [face]]
	until [
		any [
			all [in pf :word get in pf :word]
			none? pf/parent-face
			pf: pf/parent-face
		]
	]
	if in pf :word [pf]
]

; ---------- Pane Functions

make-pane: func [pane /local res] [
	get in make either object? pane [pane][layout/tight pane] [color: none] 'pane
]

; [!] - unused
set-pane: func [face lo /no-show] [
	face/pane: lo
	unless no-show [show face]
]

; [!] - unused
clear-pane: func [face] [clear face/pane]

popup?: func [window] [
	found? find system/view/pop-list window
]

; ---------- Window and Pop Face Feel Functions

; Standard function for sensing hotkeys in a window
key-sense: func [face event] [
	if face: find-key-face face event/key [
		; this might be buggy as it gets into problems with the nav key functions
		if get in face 'action [do-face face event/key]
		none
	]
]

; Main detect function for window and pop-face feel
detect-func: func [face event /local cf] [
	case [
		word? event []
		; Too CPU intensive due to a bug in event handling for DETECT
		event/type = 'time [
			all [
				face/then
				face/tool-tip-show-delay < difference now/precise face/then
				face/then: now/precise
				set-tool-tip mouse-over-face event/offset ; View bug: event/offset is 0x0 in OSX
				; on-time actor here, but could be costly
			]
		]
		event/type = 'inactive [
			if ctx-menu/menu-face = find-window event/face [
				hide-menu-face
			]
		]
		event/type = 'close [
			if all [
				get-opener-face
				same? find-window get-opener-face find-window event/face
			] [
				hide-menu-face
			]
		]
		event/type = 'move [
			mouse-over-face: over-face face face/win-offset + event/offset
			face/then: now/precise
			; find a way to do a delayed hide
			;all [
			;	face/tool-tip-hide-delay < difference now/precise face/then
			;]
			unset-tool-tip get-tool-tip face
		]
		;event/type = 'down [
		;	;-- if we are not over the menu face, then we need to close the menu-face
		;	cf: event/face/menu-face
		;	if cf/pane [
		;		unless within? event/offset win-offset? cf cf/size [
		;			hide-menu-face event/face
		;		]
		;	]
		;]
		;-- handle scroll wheel for the face we are over
		find [scroll-page scroll-line] event/type [
			all [
				cf: mouse-over-face ; This is global, which we don't want
				until [
					any [
						flag-face? cf scrollable
						none? cf: cf/parent-face
					]
				]
				if all [cf not flag-face? cf disabled] [
					scroll-face/step cf event/offset/x event/offset/y
				]
			]
		]
		; does not occur for pop-face, it seems
		event/type = 'key [
			key-sense face event
			ctx-key-nav/nav-event: event
		]
	]
]

; ---------- Main Feel Objects

; new feel object for INFORMs to handle multiple event-funcs, like normal windows
system/view/popface-feel: make object! [
	mouse-over-face: none
	redraw: none
	detect: func [face event] [
		; [!] - detect is only working if you click the background and nothing else
		; possibly engage is not allowing pass through
		foreach evt-func event-funcs [
			unless event? evt-func: evt-func face event [
				return either evt-func [event] [none]
			]
		]
		event
	]
	over: none
	engage: none
	event-funcs: reduce [
		;func [face event] bind [
		;	detect-func face event
		;	event
		;] ctx-key-nav
	]
	close-events: [close]
	inside?: func [face event] [face = event/face]
	process-outside-event: func [event] [
		either event/type = 'resize [event] [none]
	]
	pop-detect: func [face event] [
		either inside? face event [
			either find close-events event/type [
				hide-popup none
			] [
				detect-func face event
				event
			]
		] [
			process-outside-event event
		]
	]
]

; Patched WAKE-EVENT to handle keyboard navigation after other events.
system/view/wake-event: func [port] bind bind [
	event: pick port 1
	if none? event [
		if debug [print "Event port awoke, but no event was present."]
		return false
	]
	either pop-face [
		;-- INFORM window
		if in pop-face/feel 'pop-detect [event: pop-face/feel/pop-detect pop-face event]
		do event
		if nav-event [key-navigate nav-event]
		found? all [
			pop-face <> pick pop-list length? pop-list
			(pop-face: pick pop-list length? pop-list true)
		]
	] [
		;-- VIEW window
		do event
		if nav-event [key-navigate nav-event]
		empty? screen-face/pane
	]
] in system/view 'self ctx-key-nav

; Window FEEL with keyboard navigation
system/view/window-feel: make object! [
	mouse-over-face: none
	cf: none
	redraw: none
	detect: func [face event] bind [ ; face is window face
		detect-func face event
		event
	] ctx-key-nav
	over: none
	engage: none
]

; ---------- Window Display Functions

init-window: func [
	"Initializes a window for first display."
	[catch]
	face
	/focus focus-face
] [
	if all [
		in face 'style
		find [menu window] face/style
	] [
		err-face: none
		init-enablers face
		traverse-face face [act-face face none 'on-init-window]
		validate-init-face face
		any [
			err-face
			all [focus-face system/words/focus focus-face true]
			;-- find a default focus face here in the layout
			(probe 'focus-default-input focus-default-input face)
			(probe 'focus-first-input focus-first-input face)
			(probe 'focus-first-false focus-first-false face)
			(probe 'nothing)
		]
	]
	face
]

; VIEW with rule set
; [!] - to be patched into view-object.r
view: func [
	"Displays a window face."
	view-face [object!]
	/new "Creates a new window and returns immediately"
	/offset xy [pair!] "Offset of window on screen"
	/options opts [block! word!] "Window options [no-title no-border resize]"
	/title text [string!] "Window bar title"
	/local scr-face
] bind [
	scr-face: system/view/screen-face
	if find scr-face/pane view-face [return view-face]
	either any [new empty? scr-face/pane] [
		view-face/text: any [
			view-face/text
			all [system/script/header system/script/title]
			copy ""
		]
		new: all [not new empty? scr-face/pane]
		append scr-face/pane view-face
	] [
		change scr-face/pane view-face
	]
	if all [
		system/view/vid
		view-face/feel = system/view/vid/vid-face/feel
	] [
		view-face/feel: window-feel
	]
	if offset [view-face/offset: xy]
	if options [view-face/options: opts]
	if title [view-face/text: text]
	init-window view-face ; this breaks LAYOUT
	show scr-face
	if new [do-events]
	view-face
] system/view

; UNVIEW with rule set
; [!] - to be patched into view-object.r
unview: func [
	"Closes window views, except main view."
	/all "Close all views, including main view"
	/only face [object!] "Close a single view"
	/local pane
] bind [
	pane: head system/view/screen-face/pane
	either only [
		remove find pane face
	][
		either all [clear pane][remove back tail pane]
	]
	;-- refocus the current screen-face pane
	; should count the currently active window
	if system/words/all [not empty? pane pane/1/focal-face] [
		focus/keep pane/1/focal-face
	]
	show system/view/screen-face
] system/view

; SHOW-POPUP with rule set
; [!] - to be patched into view-object.r
set 'show-popup func [face [object!] /window window-face [object!] /away /local no-btn feelname] bind [
	if find pop-list face [exit]
	window: either window [
		; open inside an existing window
		feelname: copy "popface-feel-win"
		window-face
	][
		; open in a new window
		feelname: copy "popface-feel"
		if none? face/options [face/options: copy []]
		unless find face/options 'parent [
			repend face/options ['parent none]
		]
		system/view/screen-face
	]
	; do not overwrite if user has provided custom feel
	if any [face/feel = system/words/face/feel face/feel = window-feel] [
		no-btn: false
		if block? get in face 'pane [
			no-btn: foreach item face/pane [if get in item 'action [break/return false] true]
		]
		if away [append feelname "-away"] ; popface-feel-away. these feels already exist
		if no-btn [append feelname "-nobtn"]
		face/feel: get bind to word! feelname 'popface-feel
	]
	insert tail pop-list pop-face: face
	append window/pane face
	init-window face
	show window
] system/view

; HIDE-POPUP with rule set
; [!] - to be patched into view-object.r
hide-popup: func [/timeout /local focal-win-face win-face] bind [
	unless find pop-list pop-face [exit]
	win-face: any [pop-face/parent-face system/view/screen-face]
	remove find win-face/pane pop-face
	remove back tail pop-list
	if timeout [pop-face: pick pop-list length? pop-list]
	;-- refocus the current screen-face pane
	focal-win-face: win-face
	if all [focal-win-face = system/view/screen-face not empty? focal-win-face/pane] [
		focal-win-face: focal-win-face/pane/1
	]
	either all [focal-win-face <> system/view/screen-face focal-win-face/focal-face] [
		focus/keep focal-win-face/focal-face
	][
		unfocus
	]
	show win-face
] system/view

; INFORM with INSERT-INFORM-EVENT-FUNC refinement
; [!] - to be patched into view-funcs.r
inform: func [
	{Display an exclusive focus panel for alerts, dialogs, and requestors.}
	panel [object!]
	/offset where [pair!] "Offset of panel"
	/title ttl [string!] "Dialog window title"
	/options opts "Window display options"
	/timeout time
	/event evt-func "Event Function"
	/local sv old-focus
][
	sv: system/view
	panel/text: copy any [ttl "Dialog"]
	panel/offset: either offset [where] [sv/screen-face/size - panel/size / 2]
	panel/feel: sv/popface-feel
	if opts [panel/options: opts]
	show-popup/away panel
	if event [insert sv/popface-feel/event-funcs :evt-func] ; must be done after showing the face
	either time [if none? wait time [hide-popup/timeout]] [do-events]
	if event [remove find sv/popface-feel/event-funcs :evt-func] ; will this work with multiple informs on top of eachother?
	; it seems that events are still passed through this inform
]