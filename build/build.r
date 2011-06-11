REBOL [
	Title: "VID Build"
	Short: "VID Build"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-build.r
	Version: 0.0.2
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 05-Apr-2009
	Date: 13-Nov-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Builds the VID extension kit into a single file.
	}
	History: []
	Keywords: []
]

print "Building VID Extension Kit"

system/options/binary-base: 64 ; smaller binaries

build-version: 0.0.6

code: make block! []

add-file: func [file /local data header][
	data: load/header file
	header: first data
	remove data
	append code compose [
		--- (header/title) ; we want new-line marker
	]
	append code data
]

add-binary: func [file /local data fl] [
	data: read/binary file
	fl: last split-path file
	append repend code ['set to-lit-word to-string fl 'load] data
]

append code [---: func [s][]]

;-- Image Stock
foreach image read %../resources/images/ [
	unless #"." = first image [
		add-binary join %../resources/images/ image
	]
]

;-- Base files
foreach file [
	vid					; base VID context
	ctx/ctx-vid-debug	; debugging
	feel				; feel and access contexts for various styles
	ctx/ctx-text		; text editing core
	ctx/ctx-colors		; COLORS core
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
		add-file to-file join %../source/ join to-file file '.r
	]
]

;-- Skin Stock
foreach file read %../resources/skins/standard/ [
	unless #"." = first file [
		add-binary join %../resources/skins/standard/ file
	]
]

append code [
	read-skin 'standard
	load-skin 'standard
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
	doc					; document style
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
		add-file to-file join %../source/styles/ join file '.r
	]
]

make-dir/deep %../release/

save/header %../release/vid-ext-kit.r code compose [
	Title: "VID Extension Kit"
	Version: (build-version)
	Date: (now)
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		VID Extension Kit adds new methods and styles to VID for REBOL 2.
	}
]

print ["Wrote" length? mold code "bytes. Done."]