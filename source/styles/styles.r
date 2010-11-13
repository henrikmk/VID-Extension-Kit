REBOL [
	Title: "VID Styles"
	Short: "VID Styles"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-styles.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 02-Jan-2009
	Date: 02-Jan-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Base for extended VID styles.
		Colors and style appearance is set here.
	}
	History: []
	Keywords: []
]

; ---------- Edges
normal-edge:			[color: svvc/window-background-color + 5 size: 2x2 effect: 'bevel]
disabled-normal-edge:	[image: standard-edge.png size: 2x2 effect: [extend 2 2 contrast -30 luma 50]]
narrow-edge:			[color: svvc/window-background-color size: 1x2 effect: 'bevel]
horizontal-edge:		[color: svvc/window-background-color size: 0x2 effect: 'bevel]
field-edge:				[color: svvc/window-background-color + 5 size: 2x2 effect: 'ibevel]
disabled-field-edge:	[image: standard-edge.png size: 2x2 effect: [invert extend 2 2 contrast -30 luma 50]]
read-only-edge:			[color: svvc/line-color size: 2x2 effect: none]
frame-edge:				[color: svvc/frame-background-color size: 2x2 effect: 'ibevel]
mini-edge:				[color: svvc/window-background-color size: 1x1]
tip-edge:				[color: svvc/tool-tip-edge-color size: 1x1]
warning-edge:			[size: 2x2 color: 240.240.0 effect: [tile colorize 100.100.100] image: load-stock 'blocked]
window-edge:			[size: 1x1 color: svvc/line-color effect: none]

; ---------- Borders and Spacing
system/view/vid/vid-space: 2x2
system/view/vid/vid-origin: 4x4

; ---------- Stretch Types
no-stretch: [spring: none]
stretch-x: [spring: [bottom]]
stretch-xy: [spring: none]
stretch-fill: [spring: none fill: 1x1]

; ---------- Standard Effects
disabled-effect: [brightness 1 contrast -1];[colorize 100.100.100]; this is not very visible in some cases

; ---------- Glyphs

effect-window-close:	[draw [anti-alias off pen black line-width 1 line 4x6 11x13 line 11x6 4x13]]
effect-window-fold:		[draw [pen black fill-pen black box 3x8 12x11]]
effect-window-unfold:	[draw [anti-alias off pen black fill-pen black box 3x8 12x16]]
effect-window-maximize:	[draw [anti-alias off pen black box 3x5 12x14 fill-pen black box 3x5 12x7]]
effect-window-restore:	[draw [anti-alias off pen black box 3x7 12x12 fill-pen black box 3x7 12x9]]
effect-window-iconify:	[draw [pen black fill-pen black box 3x12 7x16]]
effect-window-resize:	[draw [anti-alias off pen black fill-pen black triangle 4x13 13x13 13x4]]

stylize/master [
	; ---------- Labels
	LABEL: LABEL 100x24 right black shadow none
	MINI-LABEL: MINI-LABEL black shadow none

	; ---------- Texts
	TEXT: TEXT 100x24 font [valign: 'middle] with stretch-x
	FORM-TEXT: TEXT svvc/body-text-color snow para [wrap?: false] edge read-only-edge
	LED: LED edge field-edge
	DUMMY: DUMMY edge read-only-edge

	; ---------- Groups
	BACKDROP: BACKDROP svvc/window-background-color with stretch-fill
	GROUP: PANEL fill 1x0 spring [top]
	FRAME: FRAME svvc/frame-background-color edge frame-edge
	WARNING-FRAME: WARNING-FRAME edge warning-edge
	SCROLL-FRAME: SCROLL-FRAME edge frame-edge
	H-SCROLL-FRAME: H-SCROLL-FRAME edge frame-edge
	V-SCROLL-FRAME: V-SCROLL-FRAME edge frame-edge
	TAB-PANEL-FRAME: PANEL edge normal-edge

	; ---------- Lists
	DATA-LIST: DATA-LIST edge frame-edge
	PARAMETER-LIST: PARAMETER-LIST edge frame-edge

	; ---------- Fields
	AREA: AREA edge field-edge with stretch-xy
	FIELD: FIELD edge field-edge
	INFO: INFO edge field-edge
	NAME-FIELD: NAME-FIELD edge field-edge
	COMPLETION-FIELD: COMPLETION-FIELD edge field-edge
	DATA-FIELD: DATA-FIELD edge field-edge
	SECURE-FIELD: SECURE-FIELD edge field-edge

	; ---------- Lines
	LINE: BOX svvc/line-color 2x2
	BAR: LINE fill 1x0 spring [bottom]
	VLINE: LINE fill 0x1 spring [right]

	; ---------- Buttons
	CHECK: CHECK 24x24
	RADIO: RADIO 24x24
	CHOICE: CHOICE svvc/action-color edge normal-edge
	ROTARY: ROTARY svvc/action-color edge [color: 160.160.160 effect: 'bevel]
	TOGGLE: TOGGLE svvc/action-color edge normal-edge
	STATE: STATE svvc/action-color edge normal-edge
	SELECTOR-TOGGLE: SELECTOR-TOGGLE svvc/action-color edge normal-edge
	MULTI-SELECTOR-TOGGLE: MULTI-SELECTOR-TOGGLE svvc/action-color edge narrow-edge
	ARROW: ARROW svvc/manipulator-color edge normal-edge
	BUTTON: BUTTON svvc/action-color edge normal-edge
	ACT-BUTTON: BUTTON svvc/action-color edge normal-edge
	FOLD-BUTTON: FOLD-BUTTON svvc/action-color edge normal-edge
	HIGHLIGHT-BUTTON: BUTTON svvc/important-color with [font: make font [colors: svvc/important-font-color shadow: 1x1]]
	MINI-BUTTON: BUTTON 100x20 font-size 10 edge mini-edge
	TOOL-BUTTON: BUTTON edge [size: 1x1 color: 100.100.100] 50x20
	ICON-BUTTON: BUTTON 24x24 edge none with [init: []] ; problematic as we want an icon-button with edge as well
	GLYPH-BUTTON: BUTTON 24x24 edge normal-edge
	BOTTOM-BUTTON: BUTTON with [spring: [top]]
	CENTER-BUTTON: BUTTON with [align: [left right]]
	SAVE-BUTTON: SAVE-BUTTON svvc/true-color edge normal-edge
	VALIDATE-BUTTON: VALIDATE-BUTTON svvc/true-color edge normal-edge
	LEFT-BUTTON: LEFT-BUTTON svvc/true-color edge normal-edge
	TRUE-BUTTON: TRUE-BUTTON svvc/true-color edge normal-edge
	RETRY-BUTTON: RETRY-BUTTON svvc/true-color edge normal-edge
	USE-BUTTON: USE-BUTTON svvc/true-color edge normal-edge
	SEND-BUTTON: SEND-BUTTON svvc/true-color edge normal-edge
	OK-BUTTON: OK-BUTTON svvc/true-color edge normal-edge
	YES-BUTTON: YES-BUTTON svvc/true-color edge normal-edge
	CANCEL-BUTTON: CANCEL-BUTTON svvc/false-color edge normal-edge
	RIGHT-BUTTON: RIGHT-BUTTON svvc/false-color edge normal-edge
	FALSE-BUTTON: FALSE-BUTTON svvc/false-color edge normal-edge
	NO-BUTTON: NO-BUTTON svvc/false-color edge normal-edge
	CLOSE-BUTTON: CLOSE-BUTTON svvc/false-color edge normal-edge
	POP-BUTTON: POP-BUTTON 24x24 svvc/action-color edge normal-edge
	SORT-BUTTON: SORT-BUTTON -1x20 svvc/manipulator-color font [color: black shadow: none]
	SORT-RESET-BUTTON: SORT-RESET-BUTTON svvc/action-color edge none
	COLOR-BUTTON: COLOR-BUTTON edge normal-edge

	; ---------- Cells
	DATE-WEEKDAY-CELL: DATE-WEEKDAY-CELL
		svvc/weekday-color 30x30 with [font: make font [color: svvc/weekday-font-color shadow: none size: 12]]
	DATE-CELL: DATE-CELL 30x30 with [font: make font [color: svvc/day-font-color shadow: none size: 12]]
	;MENU-BUTTON: menu-button
	;	with [colors: reduce [svvc/menu-color black]]
	;	font [
	;		color: first svvc/menu-text-color
	;		colors: svvc/menu-text-color
	;		shadow: none
	;		offset: 6x2 ; this is basically to allow correct font display for font-size 12
	;	]
	;	edge none

	; ---------- Menus
	;menu-items: menu-items edge normal-edge

	; ---------- Selectors
	SELECTOR: SELECTOR svvc/action-color with [font: make font [shadow: none size: 12 style: 'bold align: 'center]]
	MULTI-SELECTOR: MULTI-SELECTOR svvc/action-color with [font: make font [shadow: none size: 12 style: 'bold align: 'center]]

	; ---------- Misc
	PROGRESS: PROGRESS edge field-edge
	SCROLLER: SCROLLER coal svvc/manipulator-color with [
		dragger: make dragger [edge: make face/edge normal-edge]
	]
	SLIDER: SLIDER edge field-edge
	GRADIENT-SLIDER: GRADIENT-SLIDER edge field-edge
	BALANCER: BALANCER svvc/frame-background-color edge field-edge
	RESIZER: RESIZER svvc/frame-background-color edge field-edge
	LIST-HEADER: LIST-HEADER edge normal-edge

	; ---------- Windows
	REBOL-WINDOW: REBOL-WINDOW edge window-edge
	REBOL-DIALOG-WINDOW: REBOL-DIALOG-WINDOW edge window-edge
	WINDOW-BUTTON: WINDOW-BUTTON svvc/action-color edge normal-edge
	WINDOW-TITLE: WINDOW-TITLE svvc/action-color edge normal-edge
	
]