REBOL [
	Title: "VID Style Flags"
	Short: "VID Style Flags"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %flags.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 11-May-2009
	Date: 11-May-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Table of flags set for each style in VID.
		Should be set after all stylization.
	}
	History: []
	Keywords: []
]

; INPUT				- will be set by GET-FACE and SET-FACE when in a panel
; TEXT				- contains text
; FIXED				- used during layout for removing calculation of face size and offset
; DROP				- used during layout for setting custom size of backdrop
; FLAGS				- ?
; FONT				- contains modified or shared font object
; PARA				- contains modified or shared para object
; CHECK				- ?
; RADIO				- ?
; TOGGLE			- ?
; TABBED			- Supports tab navigation
; DETABBED			- A face supporting tab navigation that has been disabled
; AS-IS				- This will avoid trimming text
; PANEL				- Style is a panel style which contains multiple other faces.
; RESIZE			- Is resizable
; HIDE				- Text is hidden (password style)
; CLOSE-FALSE		- For buttons that close windows and return FALSE
; CLOSE-TRUE		- For buttons that close windows and return TRUE
; ACTION			- User input directly via mouse or keyboard and can be disabled or contains ACTION faces.
; TEXT-EDIT			- Contains text editing along with tab navigation
; FULL-TEXT-EDIT	- Full text editing without tab nagivation
; CHANGES			- Produces DIRTY? flag to check whether the face has been changed by the user
; AUTO-TAB			- Tabs away from a field solely based on cursor movement in text field
; INTEGER			- Accepts only integers as keyboard input
; DECIMAL			- Accepts only decimal as keyboard input
; TRANSPARENT		- For panels, does not SET-FACE and returns NONE for GET-FACE when INPUT faces inside it are disabled.
; SCROLLABLE		- Indicates that this style can be scrolled using a SCROLLER or SLIDER
; COMPOUND			- Styles that contain specific other faces, built in a custom way, like COMPOUNDs and CONSTRUCTs
; LAYOUT			- Provides its own layout that is typically built using LAYOUT inside SETUP-FACE

foreach [style flags] face-flags: [

WINDOW					[panel action]
RESIZABLE-WINDOW		[panel action]
FACE					[]
BLANK-FACE				[]
IMAGE					[]
IMAGES					[]
BACKDROP				[fixed drop]
BACKTILE				[fixed drop]
BOX						[]
BAR						[]
SENSOR					[]
KEY						[]
BASE-TEXT				[text]
VTEXT					[text]
TEXT					[flags text font] ; tabs when it shouldn't
BODY					[flags text]
TXT						[flags text]
BANNER					[flags text font]
VH1						[flags text font]
VH2						[flags text font]
VH3						[flags text] ; no font. bug?
VH4						[flags text font]
LABEL					[flags text font]
VLAB					[flags text font]
LBL						[flags text font]
LAB						[flags text font]
TITLE					[flags text font]
H1						[flags text font]
H2						[flags text font]
H3						[flags text font]
H4						[flags text font]
H5						[flags text] ; no font. bug?
TT						[flags text font]
CODE					[flags text font]
FORM-TEXT				[flags text font input]
PLATE					[]
BUTTON					[tabbed action]
ACT-BUTTON				[tabbed action]
FOLD-BUTTON				[tabbed action]
LEFT-BUTTON				[tabbed action]
RIGHT-BUTTON			[tabbed action]
VALIDATE-BUTTON			[tabbed action]
TRUE-BUTTON				[tabbed action close-true]
OK-BUTTON				[tabbed action close-true]
SAVE-BUTTON				[tabbed action close-true]
USE-BUTTON				[tabbed action close-true]
YES-BUTTON				[tabbed action close-true]
RETRY-BUTTON			[tabbed action close-true]
CANCEL-BUTTON			[tabbed action close-false]
FALSE-BUTTON			[tabbed action close-false]
CLOSE-BUTTON			[tabbed action close-false]
NO-BUTTON				[tabbed action close-false]
GLYPH-BUTTON			[tabbed action]
POP-BUTTON				[tabbed action]
MINI-BUTTON				[tabbed action]
TOOL-BUTTON				[tabbed action]
ICON-BUTTON				[tabbed action]
BOTTOM-BUTTON			[tabbed action]
CENTER-BUTTON			[tabbed action]
HIGHLIGHT-BUTTON		[tabbed action]
COLOR-BUTTON			[tabbed action]
;SORT-BUTTON			[tabbed action]
;SORT-RESET-BUTTON		[tabbed action]
OK-CANCEL				[compound action]
SAVE-CANCEL				[compound action]
USE-CANCEL				[compound action]
CLOSE					[compound action]
CANCEL					[compound action]
YES-NO					[compound action]
YES-NO-CANCEL			[compound action]
RETRY-CANCEL			[compound action]

CHECK					[tabbed action check input changes]
CHECK-MARK				[tabbed action check input changes]
ENABLER					[tabbed action check]
RADIO					[tabbed action radio input changes]
CHECK-LINE				[tabbed action flags input check font changes]
RADIO-LINE				[tabbed action flags input radio font changes] ; radio instead of check. bug?
LED						[input]
ARROW					[action]
TAB-BUTTON				[tabbed action toggle]
TOGGLE					[tabbed action toggle changes input]
;MENU-BUTTON				[toggle action]
;STATE					[tabbed action toggle changes]
;ROTARY					[tabbed action input changes]
CHOICE					[tabbed action input changes scrollable]
;DROP-DOWN				[tabbed action flags text font changes]
ICON					[tabbed action input]
HIDDEN					[input fixed]
FIELD					[tabbed action text-edit field return input cancel changes on-unfocus] ; no longer return or on-unfocus
DUMMY					[input]
INFO					[text-edit field input]
AREA					[internal action text-edit input changes scrollable]
TEXT-AREA				[tabbed action compound input changes]
FULL-TEXT-AREA			[tabbed action compound input changes]
CODE-TEXT-AREA			[tabbed action compound input changes]
DATE-FIELD				[input action compound changes]
DATE-TIME-FIELD			[input action compound changes]
DATE-CELL				[internal action input action]
DATE-WEEKDAY-CELL		[internal]
DATE-MONTH				[input action compound]
DATE-NAV-MONTH			[tabbed scrollable input action compound changes]
SLIDER					[tabbed action input changes compound]
GRADIENT-SLIDER			[tabbed action input changes compound]
DRAGGER					[internal action]
SCROLLER				[internal action compound] ; how do we set this, then, if input is not allowed?
PROGRESS				[input]
COMPOUND				[panel compound] ; as standard does not have ACTION, but should it?
PANEL					[panel]
TRANSPARENT-PANEL		[panel transparent]
FRAME					[panel]
WARNING-FRAME			[panel]
CENTER-PANEL			[panel]
RIGHT-PANEL				[panel]
BOTTOM-PANEL			[panel]
SCROLL-PANEL			[panel action scrollable]
V-SCROLL-PANEL			[panel action scrollable]
H-SCROLL-PANEL			[panel action scrollable]
SCROLL-FRAME			[panel action scrollable]
V-SCROLL-FRAME			[panel action scrollable]
H-SCROLL-FRAME			[panel action scrollable]
;ACTION-PANEL			[panel tabbed]
TAB-PANEL				[panel action]
SELECTOR-TOGGLE			[tabbed toggle action input]
MULTI-SELECTOR-TOGGLE	[tabbed toggle action input]
SELECTOR				[compound action input changes]
MULTI-SELECTOR			[panel compound action input changes] ; may not want this to be a panel
TAB-SELECTOR			[panel compound action input]
RADIO-SELECTOR			[panel compound action input changes]
CHECK-SELECTOR			[panel compound action input changes]
SEARCH-FIELD			[text-edit action field return input]
LIST-CELL				[flags text font action input]
LIST-TEXT-CELL			[flags text font action input]
LIST-IMAGE-CELL			[action input]
LIST					[iterated action]
CARET-LIST				[iterated action tabbed input scrollable]
CHOICE-LIST				[iterated action tabbed input scrollable]
REVERSE-LIST			[iterated action]
NAV-LIST				[tabbed action compound layout]
DATA-LIST				[tabbed action compound layout scrollable input]
PARAMETER-LIST			[tabbed action compound layout scrollable input]
;SCROLL-DATA-LIST		[tabbed compound action] ; compound, is not iterated in itself
TEXT-LIST				[tabbed action compound layout flags text as-is input]
;MENU-ITEMS				[iterated action]
ANIM					[]
;BTN					[tabbed action]
;BTN-ENTER				[tabbed action]
;BTN-CANCEL				[tabbed action]
;BTN-HELP				[tabbed action flags font]
LOGO-BAR				[]
;TOG					[tabbed action toggle input changes]
VALID-INDICATOR			[]
;VALIDATE				[]
;FACE-CONSTRUCT			[panel]

LAYOUT-COLOR			[panel action]
LAYOUT-DATE				[panel action]
LAYOUT-USER				[panel action]
LAYOUT-PASS				[panel action]
LAYOUT-LIST				[panel action]
LAYOUT-DIR				[panel action]
LAYOUT-RENAME			[panel action]
LAYOUT-DOWNLOAD			[panel]
LAYOUT-DOWNLOADS		[panel]
LAYOUT-VALUE			[panel action]
LAYOUT-EMAIL			[panel action]
LAYOUT-TEXT				[panel action]
LAYOUT-MESSAGE			[panel action]
LAYOUT-FIND				[panel action]
LAYOUT-REPLACE			[panel action]
LAYOUT-INLINE-FIND		[panel action]
LAYOUT-QUESTION			[panel]
LAYOUT-ALERT			[panel]
LAYOUT-WARNING			[panel]
LAYOUT-NOTIFY			[panel]
LAYOUT-ABOUT			[panel]

] [
	; set flags for each style
	if error? try [
		set in get-style style 'flags flags
	] [
		make error! rejoin ["Error when setting flags for style " style]
	]
]

