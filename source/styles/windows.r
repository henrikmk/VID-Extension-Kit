REBOL [
	Title: "Styles for Window Management"
	Short: "Styles for Window Management"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %windows.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 11-Jul-2010
	Date: 11-Jul-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Styles for managing windows in a simulated window management environment.
	}
	History: []
	Keywords: []
]

stylize/master [
	; button in a REBOL window that performs an action in the window manager
	WINDOW-BUTTON: BUTTON 20x24 ctx-colors/colors/action-color with [text: none] [
		face/manage: to-block face/manage
		foreach manage face/manage [
			do
				get in
					face/parent-face/parent-face/parent-face
					manage
				face/parent-face/parent-face/parent-face
				face/parent-face
		]
	]

	; window title bar
	WINDOW-TITLE: WINDOW-BUTTON "Window" ctx-colors/colors/action-color with [
		dragging: false
		old-offset: new-offset: 0x0
		access: ctx-access/text
		feel: svvf/window-manage
	]

	; window manager panel for managing multiple windows
	WINDOW-MANAGER: PANEL with [
		;-- Window Management Functions
		;-- arrange all windows in a listed arrangement
		arrange: func [face windows arrangement /no-show /local i] [
			i: 0
			foreach [size offset] arrangement [
				i: i + 1
				face/restore/no-show face windows/:i
				resize/no-springs/no-show windows/:i size offset
			]
			any [no-show show face]
		]
		;-- tiles all windows in an M by N pattern that takes up the entire window manager
		tile: func [face /only windows /no-show /local tiles width] [
			face/arrange/no-show face windows tiles
			any [no-show show face]
		]
		;-- tiles all windows in a horizontal stack
		h-tile: func [face /only windows /no-show /local offset width tiles] [
			windows: any [windows face/pane/pane]
			if empty? windows [exit]
			width: face/size/x / length? windows
			offset: as-pair negate width 0
			tiles: make block! length? windows
			repeat i length? windows [repend tiles [as-pair width face/size/y offset: as-pair offset/x + width 0]]
			face/arrange/no-show face windows tiles
			any [no-show show face]
		]
		;-- tiles all windows in a vertical stack
		v-tile: func [face /only windows /no-show /local offset height tiles] [
			windows: any [windows face/pane/pane]
			if empty? windows [exit]
			height: face/size/y / length? windows
			offset: as-pair 0 negate height
			tiles: make block! length? windows
			repeat i length? windows [repend tiles [as-pair face/size/x height offset: as-pair 0 offset/y + height]]
			face/arrange/no-show face windows tiles
			any [no-show show face]
		]
		;-- moves a specific window to front
		to-front: func [face window /no-show] [
			move/to find face/pane/pane window length? head face/pane/pane
			any [no-show show window]
		]
		;-- moves a specific window to back
		to-back: func [face window /no-show] [
			move/to find face/pane/pane window 1
			any [no-show show window]
		]
		;-- deactivates all faces and activates the passed window
		activate: func [face window /no-show] [
			any [no-show show face]
		]
		;-- maximize the passed window
		maximize: func [face window /no-show] [
			window/spring: none
			window/original-offset: window/offset
			window/original-size: window/size
			window/maximize-face/effect: effect-window-restore
			resize/no-show window face/size 0x0
			any [no-show show face]
		]
		;-- iconify the passed window
		iconify: func [face window /no-show] [
			; convert window to an icon face, but keep information about the window available
			; [ ] - swap the window face for an icon face in face/pane/pane
			; [ ] - store the window face inside the icon
			; [ ] - use the window name as icon name
			; [ ] - suggest location for iconified window if not already existing in window face
			any [no-show show window]
		]
		;-- deiconify the passed icon
		deiconify: func [face window /no-show] [
			; convert icon back to window face
		]
		;-- fold the passed window
		fold: func [face window /no-show /local edge min-size] [
			edge: second (2 * edge-size window)
			min-size: window/title-face/size/y + edge
			either window/size/y = min-size [
				window/fold-face/effect: effect-window-fold
				window/size/y: window/content-face/size/y + window/content-face/offset/y + edge
			][
				window/fold-face/effect: effect-window-unfold
				window/size/y: min-size
			]
			any [no-show show window]
		]
		;-- restore window to normal size
		restore: func [face window /no-show] [
			any [window/original-size exit]
			resize/no-springs/no-show window window/original-size window/original-offset
			window/spring: [bottom right]
			window/original-size: none
			window/original-offset: none
			window/maximize-face/effect: effect-window-maximize
			any [no-show show face]
		]
		;-- toggles window between maximized and normal size
		toggle-max: func [face window /no-show] [
			either window/original-size [
				face/restore/no-show face window
			][
				face/maximize/no-show face window
			]
			any [no-show show face]
		]
		;-- close window
		close: func [face window /no-show] [
			; move the tab-face out of here
			; somehow it might be that the window is not entirely lost or gone
			remove find face/pane/pane window
			any [no-show show face]
		]
		;-- new window
		new: func [face title content /size sz /type /offset os win-type /no-show /local window] [
			; perhaps avoid performing this layout at all
			; if we can create a rebol-window directly, init it and then use it directly
			; the parent object won't be made
			window: make get-style 'rebol-window compose/only [
				title: (title)
				action: (content)
				do bind init self
				init: none
				spring: none
			]
			;window: layout/tight compose/only [rebol-window (title) (content)]
			;window: window/pane/1
			;window/spring: none
			if os [window/offset: os]
			set-parent-faces/parent window face/pane
			append face/pane/pane window
			system/words/align/no-show window
			resize/no-show window any [sz window/size] window/offset
			window/spring: [right bottom]
			any [no-show show face]
		]
	]

	; REBOL icon face that represents an iconified window
	REBOL-ICON-WINDOW: FACE spring [right bottom] with [
		; figure whether to use this as part of the existing icon style
		; do not allow renaming these faces
	]

; the rebol window should simply behave as a panel with decorative elements
; so it would be a resizable and movable panel with various things in it
; instead of it being a panel with a scroll-panel inside it
; so this needs to be entirely rewritten

	REBOL-WINDOW: COMPOUND spring [right bottom] with [
		color: ctx-colors/colors/window-background-color
		size: none
		access: make access [
			;-- sets the window title if string is passed. if block is passed, window content is set
			set-face*: func [face value] [
				case [
					string? value [set-face/no-show face/title-face value]
					any-block? value [set-face/no-show face/content-face value]
				]
			]
			;-- returns the content of the face
			get-face*: func [face] [
				get-face face/content-face
			]
		]
		original-offset: none				; stored offset of window, when maximized
		original-size: none					; stored size of window, when maximized
		extra: none							; size difference between scroll-face and its clipper-face

		;-- Window faces
		icon-face:							; icon face that represents this window when iconified
		content-face:						; content for window
		corner-face:						; resize corner face
		iconify-face:						; window button for iconifying face
		maximize-face:						; window button for maximizing face
		fold-face:							; window button for folding/unfolding face
		close-face:							; window button for window closing face
		title-face:							; window title bar face
			none

		faces: [close-face title-face fold-face iconify-face maximize-face content-face]

		compound: [
			across
			space 0
			window-button effect effect-window-close spring [right bottom] tool-tip "Close Window" with [manage: 'close]
			window-title spring [bottom] with [manage: [to-front activate]]
			window-button effect effect-window-fold spring [left bottom] tool-tip "Fold Window" with [manage: 'fold]
			window-button effect effect-window-iconify spring [left bottom] tool-tip "Iconify Window" with [manage: 'iconify]
			window-button effect effect-window-maximize spring [left bottom] tool-tip "Maximize Window" with [manage: 'toggle-max]
			return
			compound 100x100 (content) ; different panel here based on what is needed
		]

		content: none						; content of window
		x-glyph-size: none					; size of glyphs in the x-direction
		y-glyph-size: none					; size of glyphs in the y-direction

		init: [
			content: either all [function? :action not empty? second :action] [
				second :action
			][
				make block! []
			]
			pane: layout/styles/tight compound copy self/styles
			set :faces pane/pane
			set-parent-faces self
			x-glyph-size: y-glyph-size: 0
			if title-face [y-glyph-size: y-glyph-size + title-face/size/y]
			; calculate window size from content or align to size
			; the guess is probably correct, so the size is set
			; now the faces should just be aligned to work in this size
			; compound may perhaps not be 100x100
			; three different kinds of windows and resizing:
			; 1. user sets the size and the window is resizable
			; 2. window sets its size based on the content and is not resizable
			; 3. user sets the 
			; simplify: do not allow the user to set the window size? what about resizable?
			; ; nope, can't simplify
			; resizable windows
			; 1. user sets size (content sets inner size)
			; 2. content sets size (content sets window size)
			; non-resizable windows
			; 1. user sets size (makes little sense)
			; 2. content sets size (makes sense)
			size: any [
				size						; user sets size
				content-face/size +			; content sets size
					(2 * edge-size self) +
					as-pair x-glyph-size y-glyph-size
			]
			pane: pane/pane
			action: none
		]
	]

	; REBOL window with vertical and horizontal scrollbars and resize
	;REBOL-WINDOW-OLD: FACE spring [right bottom] with [
	;	color: ctx-colors/colors/window-background-color
	;	size: none
	;	access: make access [
	;		;-- sets the window title if string is passed. if block is passed, window content is set
	;		set-face*: func [face value] [
	;			case [
	;				string? value [set-face face/title-face value]
	;				any-block? value [set-face/content-face value]
	;			]
	;		]
	;	]
	;	original-offset: none				; stored offset of window, when maximized
	;	original-size: none					; stored size of window, when maximized
	;	extra: none							; size difference between scroll-face and its clipper-face
  ;
	;	;-- Window faces
	;	icon-face:							; icon face that represents this window when iconified
	;	content-face:						; content for window
	;	corner-face:						; resize corner face
	;	iconify-face:						; window button for iconifying face
	;	maximize-face:						; window button for maximizing face
	;	fold-face:							; window button for folding/unfolding face
	;	close-face:							; window button for window closing face
	;	title-face:							; window title bar face
	;		none
	;	; [ ] - set feel in the corner button for the scroll-panel for resizing
	;	pane: [
	;		across
	;		space 0
	;		window-button effect effect-window-close spring [right bottom] tool-tip "Close Window" with [manage: 'close]
	;		window-title spring [bottom] with [manage: [to-front activate]]
	;		window-button effect effect-window-iconify spring [left bottom] tool-tip "Iconify Window" with [manage: 'iconify]
	;		window-button effect effect-window-fold spring [left bottom] tool-tip "Fold Window" with [manage: 'fold]
	;		window-button effect effect-window-maximize spring [left bottom] tool-tip "Maximize Window" with [manage: 'toggle-max]
	;		return
	;		scroll-panel 100x100
	;	]
	;	init-content: func [face] [
	;		action: get in face 'action
	;		either all [function? :action not empty? second :action] [
	;			second :action
	;		][
	;			make block! []
	;		]
	;	]
	;	init-content-face: func [face content-face /local extra action] [
	;		;-- initialize content face
;	;		system/words/align content-face/clipper-face ; this might give the clipper-face the wrong size for scrolling
	;		extra: face/pane/size; - content-face/clipper-face/size + (2 * edge-size face) ; what does this do?
	;		content-face/set-content content-face init-content face
	;		face/pane/spring: none
	;		set-parent-faces face
	;		any [
	;			pair? face/size													; User sets size
	;			face/size: max 100x100 content-face/scrolled-face/size + extra	; Content sets size
	;		]
	;		;-- set corner feel for scroll-panel
	;		if in content-face 'corner-face [
	;			content-face/corner-face/feel: svvf/window-resizer
	;			content-face/corner-face/effect: effect-window-resize
	;		]
	;	]
	;	init: [
	;		;-- window layout
	;		pane: layout/tight pane
	;		set [close-face title-face iconify-face fold-face maximize-face content-face] pane/pane
	;		init-content-face self content-face
	;		;-- resize window area to fit size
	;		resize/no-show pane size - (2 * edge-size self) pane/offset
	;		pane: pane/pane
	;		set-face self text
	;		text: none
	;	]
	;]

	; REBOL window wtih no scrollers or resize
	REBOL-DIALOG-WINDOW: REBOL-WINDOW with [
		pane: [
			across
			space 0
			window-button effect effect-window-close spring [right bottom] tool-tip "Close Window" with [manage: 'close]
			window-title spring [bottom] with [manage: [to-front activate]]
			window-button effect effect-window-fold spring [left bottom] tool-tip "Fold Window" with [manage: 'fold]
			window-button effect effect-window-iconify spring [left bottom] tool-tip "Iconify Window" with [manage: 'iconify]
			window-button effect effect-window-maximize spring [left bottom] tool-tip "Maximize Window" with [manage: 'toggle-max]
			return
			panel 100x100
		]
		init-content-face: func [face content-face] [
			; need to improve this design as it's a bit confusing when exactly to use align
			; edge needs to be there as well
			system/words/align content-face
			extra: 2 * edge-size face
			pane/spring: none
			set-parent-faces self
			any [
				pair? face/size										; User sets size
				face/size: max 100x100 content-face/size + extra	; Content sets size
			]
			; panel content needs to be set here
			; init-content
		]
	]
]

