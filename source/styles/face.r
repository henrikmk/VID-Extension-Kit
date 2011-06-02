REBOL [
	Title: "VID Face Object"
	Short: "VID Face Object"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %face.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 03-Apr-2009
	Date: 03-Apr-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Face and Window styles
	}
	History: []
	Keywords: []
]

stylize/master [
	; Prototype for regular window
	WINDOW: FACE 100x100 with [ ; Fields for align and resize hints - can be changed later
		font: none
		access: ctx-access/compound								; Accessor for windows are like COMPOUND
		origin: ctx-resize/window-origin						; Set since this affects contents
	]
	; Prototype for resizable window with some defaults set
	RESIZABLE-WINDOW: WINDOW with [
		options: [resize]										; Allow window resizing
		access: make access ctx-resize/access					; Default accessor will be changed on first resize
		data: none												; Used for storing dialog result
		result: none
		align: [center]
		tool-tip-face: none										; Face for tool-tip
		menu-face: none											; Face for menu
		sheet-face: none										; Face for sheet
		focus-ring-faces: none									; Faces for focus rings
		tool-tip-hide-delay: 0:0:0.2							; Delay of tool-tip hiding
		tool-tip-show-delay: 0:0:1								; Delay of tool-tip showing
		then: none												; Storage of timestamp
		rate: 0:0:1												; Triggers a rate, but not this rate
		init: [
			tab-face: any [tab-face self]						; Set the tab face
			unless pane [pane: make block! []]					; Create an empty pane if none exists
			append pane focus-ring-faces: make-focus-ring self	; Append faces for focus ring
			append pane menu-face: make-menu-face self			; Append faces for menu
			; sheet face here
			append pane tool-tip-face: make-tool-tip			; Append face for tool-tip
			set-parent-faces self								; Set all PARENT-FACE in all faces
			ctx-resize/add-resize-face* self					; Set the runtime resize-face* (changes access)
			ctx-resize/align/no-show self none					; Autoalign the window based on the above hints
;			ctx-resize/resize/no-show self size offset			; Autosize the window based on the above hints
			if find ctx-vid-debug/debug 'face [dump-face self]	; Dump window face on init if debugging is enabled
		]
	]
]