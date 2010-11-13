REBOL [
	Title: "VID Style Tags"
	Short: "VID Style Tags"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-tags.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 01-Jul-2009
	Date: 01-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Tags each style for cataloging purposes.
	}
	History: []
	Keywords: []
]

; tags:

; construct		- a construct style
; compound		- a compound style
; internal		- a style meant to be used internally only
; user			- a style meant to be used by an end user
; data-only		- an invisible data style
; text			- contains text
; deprecated	- style that really should not be used anymore

foreach [style tags] [

FACE				[internal]
BLANK-FACE			[]
IMAGE				[]
IMAGES				[]
BACKDROP			[]
BACKTILE			[]
BOX					[]
BAR					[]
SENSOR				[data-only]
KEY					[data-only]
BASE-TEXT			[internal]
VTEXT				[text]
TEXT				[text]
BODY				[text]
TXT					[text]
BANNER				[text]
VH1					[text]
VH2					[text]
VH3					[text]
VH4					[text]
LABEL				[text]
VLAB				[text]
LBL					[text]
LAB					[text]
TITLE				[text]
H1					[text]
H2					[text]
H3					[text]
H4					[text]
H5					[text]
TT					[text]
CODE				[text]
FORM-TEXT			[text]
PLATE				[text]
BUTTON				[text]
ACT-BUTTON			[text]
TRUE-BUTTON			[text]
FALSE-BUTTON		[text]
CLOSE-BUTTON		[text]
POP-BUTTON			[text]
MINI-BUTTON			[text]
TOOL-BUTTON			[text]
ICON-BUTTON			[text]
BOTTOM-BUTTON		[text]
CENTER-BUTTON		[text]
HIGHLIGHT-BUTTON	[text]

CHECK				[]
CHECK-MARK			[deprecated]
ENABLER				[]
RADIO				[]
CHECK-LINE			[]
RADIO-LINE			[]
LED					[]
ARROW				[]
TAB-BUTTON			[]
TOGGLE				[]
ROTARY				[]
CHOICE				[]
;DROP-DOWN			[]
ICON				[]
FIELD				[text]
DUMMY				[]
INFO				[text]
AREA				[text]
DATE-FIELD			[text]
DATE-TIME-FIELD		[text]
SLIDER				[]
SCROLLER			[]
PROGRESS			[]
PANEL				[]
;ACTION-PANEL		[]
TAB-PANEL			[]
SELECTOR-TOGGLE		[]
SELECTOR			[]
TAB-SELECTOR		[]
RADIO-SELECTOR		[]
SEARCH-FIELD		[text]
LIST				[text iterated]
TABLE				[text iterated]
TEXT-LIST			[text iterated]
DATA-LIST			[text iterated]
;SCROLL-DATA-LIST	[text iterated compound]
ANIM				[]
;BTN					[deprecated]
;BTN-ENTER			[deprecated]
;BTN-CANCEL			[deprecated]
;BTN-HELP			[deprecated]
;LOGO-BAR			[]
;TOG					[deprecated]
VALID-INDICATOR		[]
;VALIDATE			[data-only]

OK-CANCEL			[compound]
CLOSE				[compound]

] [
	; set tags for each style
	if error? try [
		set in get-style style 'tags tags
	] [
		make error! rejoin ["Error when setting tags for style " style]
	]
]