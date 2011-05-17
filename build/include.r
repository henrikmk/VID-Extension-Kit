REBOL [
	Title: "VID Includes"
	Short: "VID Includes"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %include.r
	Version: 0.0.2
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Jan-2009
	Date: 13-Nov-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Loads all includes for the VID extension kit.
	}
	History: []
	Keywords: []
]

; [ ] - should be part of the skins
foreach file read %../resources/images/ [
	set to-word to-string file load join %../resources/images/ file
]

;-- Base files
foreach file [
	vid					; base VID context
	ctx/ctx-vid-debug	; debugging
	feel				; feel and access contexts for various styles
	ctx/ctx-text		; text editing core
	ctx/ctx-draw		; Face DRAW core
	ctx/ctx-surface		; SURFACE core
	ctx/ctx-skin		; SKIN core
	funcs				; face navigation functions
	<layout>			; (unused)
	image-stock			; all image bitmaps
	ctx/ctx-content		; text content formatting context
	ctx/ctx-list		; list context for list styles
	ctx/ctx-scroll		; scroll context for scroll styles
	ctx/ctx-focus-ring	; focus ring handling
	ctx/ctx-menu-face	; handles the display of menu faces (unused)
	ctx/ctx-tool-tip	; tool tip system
	ctx/ctx-key-nav		; keyboard navigation
	ctx/ctx-resize		; resizing mechanism
	window				; windowing functions
	<request>			; (unused)
	<ctx-sheet>			; (unused)
	ctx/ctx-dialog		; dialog system
	extras				; helper functions
] [
	unless tag? file [
		do to-file join join %../source/ to-file file '.r
	]
]

;-- Styles
foreach file [
	;-- Styles
	face				; basic face and window face styles
	image				; base image, logo and backdrop styles
	sensor				; base sensor style
	text				; basic text and document styles
	box					; box, bar and aspect box styles
	button				; button styles
	toggle				; toggle styles
	scroller			; slider and scroller styles
	panel				; panel styles
	dialog-buttons		; buttons for dialogs
	field				; field and area styles
	label				; labelling styles
	construct			; construct style
	selector			; selectors and multiselectors
	icon				; icon style
	balance				; balancer styles
	date				; date and calendar styles
	indicator			; validation indicator styles
	pop-face			; various window and list popup styles
	form				; form related styles
	list				; list styles
	<menu>				; menu style (non-functioning)
	search				; list search style
	file				; file management styles
	super-styles		; style combinations for dialogs
	windows				; styles for window manager and multi-document windows
	styles				; style skin

	;-- Lists
	flags				; full list of flags for all styles
	tags				; full list of tags for all styles
][
	;-- Include all files
	unless tag? file [
		do to-file join %../source/styles/ join file '.r
	]
]

;-- Skins
foreach file read %../resources/skins/ [
	if #"/" = last file [read-skin join %../resources/skins/ file]
]

load-skin 'standard