REBOL [
	Title: "VID Main"
	Short: "VID Main"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010 - HMK Design"
	Filename: %main.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 13-Nov-2010
	Date: 13-Nov-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Main file to preprocess and build the VID Extension Kit parts
	}
	History: []
	Keywords: []
]

;-- Source
#include %vid.r						; base VID context
#include %ctx/ctx-vid-debug.r		; debugging
#include %feel.r					; feel and access contexts for various styles
#include %ctx/ctx-text.r			; text editing core
#include %face-tree.r				; face tree functions
#include %image-stock.r				; all image bitmaps
#include %ctx/ctx-content.r			; text content formatting context
#include %ctx/ctx-list.r			; list context for list styles
#include %ctx/ctx-scroll.r			; scroll context for scroll styles
#include %ctx/ctx-focus-ring.r		; focus ring handling context
#include %ctx/ctx-tool-tip.r		; tool tip system
#include %ctx/ctx-key-nav.r			; keyboard navigation
#include %ctx/ctx-resize.r			; resizing mechanism
#include %window.r					; windowing functions
#include %ctx/ctx-dialog.r			; dialog system
#include %extras.r					; helper functions

;-- Styles
#include %styles/face				; basic face and window face styles
#include %styles/image				; base image, logo and backdrop styles
#include %styles/sensor				; base sensor style
#include %styles/text				; basic text and document styles
#include %styles/box				; box, bar and aspect box styles
#include %styles/button				; button styles
#include %styles/toggle				; toggle styles
#include %styles/scroller			; slider and scroller styles
#include %styles/panel				; panel styles
#include %styles/dialog-buttons		; buttons for dialogs
#include %styles/field				; field and area styles
#include %styles/label				; labelling styles
#include %styles/construct			; construct style
#include %styles/selector			; selectors and multiselectors
#include %styles/icon				; icon style
#include %styles/balance			; balancer styles
#include %styles/date				; date and calendar styles
#include %styles/indicator			; validation indicator styles
#include %styles/pop-face			; various window and list popup styles
#include %styles/form				; form related styles
#include %styles/list				; list styles
#include %styles/search				; list search style
#include %styles/super-styles		; style combinations for dialogs
#include %styles/windows			; styles for window manager and multi-document windows
#include %styles/styles				; style skin