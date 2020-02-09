REBOL [
	Title: "GUI Resizing Context"
	Short: "GUI Resizing Context"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %ctx-resize.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 16-Jul-2009
	Date: 16-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Face alignment and resizing.
	}
	History: []
	Keywords: []
]

ctx-resize: context [
	; Resize calculation internal temporary variables
	; Note: You shouldn't run more than one function using these words at a time.
	*fo:        ; Face offset (pair!)
	*fs:        ; Face real size (pair!)
	*fa:        ; Face aspect ratio (decimal!)
	*fps:       ; Parent face size (pair!)
	*fpis:      ; Parent face inner size without margins (pair!)
	*fpa:       ; Parent face inner aspect ratio (decimal!)
	*mtl:       ; Margin top left (pair! from parent origin or default)
	*mbr:       ; Margin bottom right (pair! from parent origin or default)
	*maxs:      ; Maximum size of a face if specified as max-size hint
	*mins:      ; Minimum size of a face if specified as min-size hint
	center:     ; Exterior align hint (true when in face's hint block)
	top:        ; Exterior align and spring hint (true when in face's hint block)
	bottom:     ; Exterior align and spring hint (true when in face's hint block)
	left:       ; Exterior align and spring hint (true when in face's hint block)
	right:      ; Exterior align and spring hint (true when in face's hint block)
	;horizontal: ; Interior spring hint (true when in face's hint block)
	;vertical:   ; Interior spring hint (true when in face's hint block)
		none

	; Align hints, just listed here for documentation
	; align:    ; Block containing some of [center top bottom left right]
	; fill:     ; Fill (1) or not fill (0) remaining space in X or Y direction (pair!)
	; min-size: ; Minimum size of face (pair! default 0x0)
	; max-size: ; Maximum size of face (pair!)
	; origin:   ; Position of inner face area in from top-left and bottom-right (pair! or [pair! pair!])

	; Resize hints, just listed here for documentation
	; spring:   ; Block containing some of [top bottom left right horizontal vertical]
	; min-size: ; Same as above
	; max-size: ; Same as above

	; Default values - can be changed by external code
	screen-origin:	50x50 ; Screen origin value if not set (pair! or [pair! pair!])
	window-origin:	20x20 ; Window face origin value if not set (pair! or [pair! pair!])
	face-origin:	0x0   ; Face origin value if not set (pair! or [pair! pair!])
	win-pos:		0x0   ; Internal variable to keep track of the current global offset
	
	; Resize helpers
	;tab-face?:	false    ; This turns true when the tab face was encountered during resize

	; Note: Type checks and doc strings commented out for efficiency.
	;       Uncomment these to debug, or for test code.
	aspect: func [; "Helper function to set aspect for a specific size"
		[catch]
		size ;[pair!] "The size to derive the aspect from"
	] [
		unless pair? size [throw make error! reform ["Aspect error, size is" size]]
		if zero? size/y [return 0]
		size/x / size/y
	]
	set-vars: func [; "Helper function to set short words (internal)"
		face ;[object!] "The face to get the size and offset from"
		parent ;[object! none!] "The parent face to get the parent size and origin from (default screen)"
	] [
		*fo: face/offset
		*fs: any [face/real-size face/size]
		either parent [ ; Regular face, use parent
			set [*mtl *mbr] any [get in face 'origin  face-origin]
			if all [parent/edge parent/edge/size] [*mbr: *mbr + (2 * parent/edge/size)]
			*fps: parent/size
		] [ ; Window face (no parent), use screen
			set [*mtl *mbr] screen-origin
			*fps: system/view/screen-face/size
		]
		*fpis: *fps - *mtl - *mbr
		*fa: face/aspect-ratio
		*fpa: aspect *fpis ; inner aspect ratio of parent face
		*mins: face/min-size
		*maxs: face/max-size
		set [horizontal vertical center top bottom left right] false
		;print ["offset" *fo "size" *fs "parent" found? parent "parent size" *fps "margin" *mtl *mbr]
	]
	set-faces: func [; "Helper function to set face values from short words (internal)"
		face ;[object!] "The face to set"
	] [
		face/win-offset: win-pos
		face/offset: *fo
		face/size: max 0x0 face/real-size: *fs
		face/aspect-ratio: *fa
	]

	get-resize-face*: func [; "Get the resize-face* function if there is one, none if not."
		face ;[object!] "The face to check"
	] [
		all [face: get in face 'access  get in face 'resize-face*]
	]

	do-align: func [; "Align a face relative to its parent. Called only during initialization."
		face ;[object!] "The face to align"
		parent ;[object! none!] "The parent face (passed because parent-face isn't set until view)"
		/local fo diff
	] [
		; Align the current face
		; fill changes the size and therefore should resize the content of the face
		; consider ramifications
		set-vars face parent
		diff: *fs
		if pair? get in face 'fill [
			either flag-face? face fixed [
				if face/fill/x = 1 [*fs/x: *fps/x - *fo/x]
				if face/fill/x = -1 [*fs/x: *fs/x + *fo/x *fo/x: 0]
				if face/fill/y = 1 [*fs/y: *fps/y - *fo/y]
				if face/fill/y = -1 [*fs/y: *fs/y + *fo/y *fo/y: 0]
			][
				if face/fill/x = 1 [*fs/x: *fps/x - *mbr/x - *fo/x]
				if face/fill/x = -1 [*fs/x: *fs/x + *fo/x *fo/x: *mtl/x]
				if face/fill/y = 1 [*fs/y: *fps/y - *mbr/y - *fo/y]
				if face/fill/y = -1 [*fs/y: *fs/y + *fo/y *fo/y: *mtl/y]
			]
		]
		if get in face 'align [set bind face/align self true]
		if *mins [*fs: max *mins *fs]                        ; min-size
		if *maxs [*fs: min *maxs *fs]                        ; max-size
		if zero? *fa [*fa: aspect *fs]                       ; aspect ratio
		either center [
			*fo: *fps - *mtl - *mbr - *fs / 2 + *mtl         ; Move to center
		] [
			case [
				all [top bottom] [                           ; Center vertically
					*fo/y: *fps/y - *mtl/y - *mbr/y - *fs/y / 2 + *mtl/y
				]
				top [*fo/y: *mtl/y]                          ; Move to top
				bottom [*fo/y: *fps/y - *mbr/y - *fs/y]      ; Move to bottom
			]
			case [
				all [left right] [                           ; Center horizontally
					*fo/x: *fps/x - *mtl/x - *mbr/x - *fs/x / 2 + *mtl/x
				]
				left [*fo/x: *mtl/x]                         ; Move to left
				right [*fo/x: *fps/x - *mbr/x - *fs/x]       ; Move to right
			]
		]
		diff: *fs - diff
		; Resize contents if the fill causes a size change
		if diff <> 0x0 [
			set-faces face
			resize-contents face diff
			set-vars face parent
		]
		; [ ] - win-pos should be set to parent win-pos if we are aligning a sub-face
		if parent [win-pos: win-pos + (fo: *fo) + edge-size parent]
		set-faces face
		debug-align :face
		face/line-list: none
		; Align the face contents
		align-contents face parent
		; Perform text adjustments to face due to new alignment
		ctx-text/set-text-body face face/text
		; Perform draw adjustments to face if it has a new size
		resize-draw-body face
		act-face face none 'on-align
		if parent [win-pos: win-pos - fo - edge-size parent] ; only set win-pos when parent is not screen-face
	]
	align-contents: func [; "Align the contents of a face. Called only during initialization."
		face ;[object!] "The face with the contents to align"
		parent ;[object! none!] "The parent face (passed because parent-face isn't set until view)"
		/local r pane panes
	] [
		in-level
		(pane: face/pane face 1) ; Just in case it's iterated
		panes: get in face 'panes
		case [
			all [
				parent                     ; Not window face (prevent looping)
				r: get-resize-face* face   ; Has a resize-face* function
			] [r face face/size none none] ; Then call resize-face* instead, else
			block? :panes [foreach [w p] head panes [either object? p [do-align p face][foreach fc p [do-align fc face]]]] ; align multiple panes in panel face
			object? :pane [do-align pane face]                ; align child, or
			block? :pane [foreach fc pane [do-align fc face]] ; align children
		]
		out-level
	]

	set 'boo false
	irk: func [face] [if boo [print ['--- face/style face/size face/real-size *fs]]]

	do-resize: func [; "Resize a face relative to the size of its parent."
		face ;[object!] "The face to resize"
		diff ;[pair!] "The difference in size"
		/local n-diff fo *fs* *fo*
	] [
		n-diff: 0x0
		; Resize the current face
		set-vars face face/parent-face ; this sets size by real-size
		if get in face 'spring [set bind face/spring self true]
		*fs*: *fs                                                ; original size
		*fo*: *fo                                                ; original offset
		*fs: *fs + n-diff: diff                                  ; new size
		*fo: *fo + diff                                          ; new offset
		if any [left right] [*fs/x: *fs*/x n-diff/x: 0]          ; right spring
		if any [top bottom] [*fs/y: *fs*/y n-diff/y: 0]          ; bottom spring
		if get in face 'fixed-aspect [
			switch face/fill [
				0x1 [
					*fs/x: *fs/y * *fa
				]
				1x0 [
					*fs/y: *fs/x / *fa
				]
				1x1 [
					; this is the main problem apparently, once again
					; we can do them separately, but why not together?
					; when switching, the size is not properly calculated
					; it seems we should be keeping the original size somehow
					; there is a problem here with not having a good size to start from
					; as when we are moving from one size to another, the scaled side takes over
					; and the face gets smaller and smaller
					; which means the scaled side should not have been scaled, but should have been the original
					either *fpa > *fa [
						*fs/x: *fs/y * *fa
					][
						*fs/y: *fs/x / *fa
					]
				]
			]
		]
		;if get in face 'fixed-aspect [
		;	if face/fill/x = 1 [*fs/x: *fpis/x]                  ; fill horizontally
		;	if face/fill/y = 1 [*fs/y: *fpis/y]                  ; fill vertically
		;	; adjust for aspect based on the fill. This MUST be simplified once and for all.
		;	either *fpa > *fa [                                  ; fixed aspect stretch
		;		*fs/x: *fs/y * *fa
		;	][
		;		*fs/y: *fs/x / *fa
		;	]
		;]
		unless left [*fo/x: *fo*/x]                              ; left spring
		unless top [*fo/y: *fo*/y]                               ; top spring
		if *mins [*fs: max *mins *fs]                            ; min-size
		if *maxs [*fs: min *maxs *fs]                            ; max-size
		if all [left right] [                                    ; horizontal center
			*fo/x: *fps/x - *mtl/x - *mbr/x - *fs/x / 2 + *mtl/x
		]
		if all [top bottom] [                                    ; vertical center
			*fo/y: *fps/y - *mtl/y - *mbr/y - *fs/y / 2 + *mtl/y
		]
		if face/parent-face [win-pos: win-pos + (fo: *fo) + edge-size face/parent-face]
		;if face/tab-face? [tab-face?: true set-focus-ring/tab-face/no-show face face]
		set-faces face ; this remembers the wrong sizes
		debug-resize :face diff
		if n-diff <> 0x0 [face/line-list: none]
		; Resize the face contents
		resize-contents face n-diff
		; Perform text adjustments to face due to new size
		ctx-text/set-text-body face face/text
		; Perform draw adjustments to face due to new size
		resize-draw-body face
		act-face face none 'on-resize
		if face/parent-face [win-pos: win-pos - fo - edge-size face/parent-face]
	]
	resize-contents: func [; "Resize the contents of a face."
		face ;[object!] "The face with the contents to align"
		diff ;[pair!] "The difference in size"
		/local r pane panes
	] [
		in-level
		(pane: face/pane face 1) ; Just in case it's iterated
		panes: get in face 'panes
		case [
			r: get-resize-face* face [r face face/size none none] ; Call resize-face*, or
			; [ ] - does really only resize the currently visible panel
			block? :panes [foreach [w p] head panes [either object? p [do-resize p diff][foreach fc p [do-resize fc diff]]]]  ; resize multiple panes in panel. if possible, only resize the visible one?
			object? :pane [do-resize pane diff]                   ; resize child, or
			block? :pane [foreach fc pane [do-resize fc diff]]    ; resize children
		]
		out-level
	]

	; Default resizable accessor object (resize-face* set later)
	access: make object! [resize-face*: none]

	access/resize-face*: resize-face*: func [ ; Default function, replaced on first run.
		"Initialize face layout alignment. Accessed through resize-face."
		face [object!] "The face that has been resized (must be VID face)"
		size [pair! number!] "The new size (apparently = face/size)"
		x [logic! none!] "Resize only width"  ; Propagated refinement
		y [logic! none!] "Resize only height" ; Propagated refinement
	] [
		; Note: face/size is already set to size. /x and /y are irrelevant here
		; Warning: Only valid to call once if the window face not yet viewed.
		align-contents face face/parent-face  ; Align the contents
		add-resize-face* face                 ; Replace resize-face* with the runtime version
	]

	add-resize-face*: func [
		"Build and assign runtime resize accessor resize-face*."
		face [object!] "The face (must be VID face)"
	] [
		if in face 'access [
			use [last-size] copy/deep [ ; Does USE copy/deep its body in R2?
				last-size: face/size
				face/access: make any [face/access ctx-access/data] [
					resize-face*: func [face size x y] [ ; Parameters are documented above
						; Note: face/size is already set to size, but...
						; Bounds check size
						size: max size any [get in face 'min-size  0x0]
						if get in face 'max-size [size: min size face/max-size]
						; Limit changes to those applicable
						size: (1x1 * size) - last-size  ; Make size into relative pair!
						if x [size: size * 1x0]         ; /x set, eliminate the height
						if y [size: size * 0x1]         ; /y set, eliminate the width
						; If both /x and /y, neither the height or width are changed
						; ... Set face/size to the size after bounds check and limit
						face/size: last-size + size
						; Recalculate text body if present
						ctx-text/set-text-body face face/text
						; Recaclulate draw body if present
						;resize-draw-body face
						; Resize the contents, copied here to prevent looping
						if object? face/pane [do-resize face/pane size]
						if block? face/pane [foreach fc face/pane [do-resize fc size]]
						last-size: face/size            ; Cache the size for next time
						face
					]
				]
			]
		]
		face
	]

	; Enable the resize-face accessor as a global window resize-contents event.
	handler: insert-event-func [
		if all [
			event/face
			not event/face/parent-face ; should use a more formal method
		] [
			switch event/type [
				resize [
					; used during user window resize
					svv/resizing?: true ; use this to prevent a face redraw from occurring here
					resize-face event/face event/face/size ; performs ON-RESIZE-WINDOW actor
					svv/resizing?: false
					set-focus-ring event/face
				]
				offset [
					; used during user window move
					traverse-face event/face [
						act-face face none 'on-move-window
					]
				]
				close [
					; used during user window close
					traverse-face event/face [
						act-face face none 'on-close-window
					]
				]
			]
		]
		event
	]

	; used during initial size and offset calculation
	resize: func [
		"Resize a face and its contents."
		face [object!] "The face"
		size [pair!] "The new size"
		offset [pair!] "The new offset"
		/no-show "Do not show change yet."
		/no-springs "Ignore springs in face."
		/local diff pane-spring spring
	] [
		diff: size - any [face/real-size face/size]
		face/offset: offset
		if no-springs [
			;-- Disable springs for face and face/pane
			spring: face/spring face/spring: none
			if object? face/pane [
				pane-spring: face/pane/spring
				face/pane/spring: none
			]
		]
		; need to allow setting the focus rings automatically:
		; [ ] - track whether we are resizing the tab face
		; [ ] - resize the focus ring for the tab face
		; [ ] - decide what other places the resizing occurs
		; [ ] - simple way to mark the tab face itself, so we can quickly detect it during resize
		;       [ ] - if the tab face was detected during resize, resize the focus ring as well
		; [ ] - mark the tab face object itself during SET-TAB-FACE
		; [ ] - method to tell that the tab face was encountered during resize so the faces can be shown
		do-resize face diff
		if no-springs [
			;-- Re-enable springs for face and face/pane
			face/spring: spring
			if object? face/pane [
				face/pane/spring: pane-spring
			]
		]
		any [no-show show face]
		face
	]

	align: func [
		"Align a face and its contents."
		face [object!] "The face"
		/no-show "Do not show change yet."
		/local diff
	] [
		if face/parent-face [
			win-pos: face/parent-face/win-offset
		]
		do-align face face/parent-face
		any [no-show show face]
		face
	]
] ; end ctx-resize

; Exported functions
resize: get in ctx-resize 'resize
align: get in ctx-resize 'align

resizable?: func [
	"Check a face to see if it is supposed to be resizable."
	face [object!] "The face"
] [
	not none? any [
		flag-face? face resize  ; Has VID flag
		face/options = 'resize  ; Has window flag
		all [block? face/options  find face/options 'resize] ; Has window flag
		ctx-resize/get-resize-face* face  ; Has resize accessor
		not empty? intersect any [get in face 'spring []] [horizontal vertical]  ; Auto-resized
	]
]

flag-resize: func [
	"Flag a VID face with 'resize if appropriate."
	face [object!] "The face"
] [
	all [
		in face 'flags  ; Is VID face
		resizable? face
		flag-face face resize
	]
]