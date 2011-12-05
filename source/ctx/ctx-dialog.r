REBOL [
	Title: "VID Extension Kit Dialog Management"
	Short: "VID Extension Kit Dialog Management"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %ctx-dialog.r
	Version: 0.0.2
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-May-2010
	Date: 05-Dec-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Management of Tool Windows, Requesters, Information Windows and Alerts
	}
	History: []
	Keywords: []
]

ctx-dialog: context [

;-- Dialog Functions

; sets the DATA value of a dialog and closes it
set-dialog-value: func [face value /local win] [
	win: root-face face
	win/data: value
	either popup? win [hide-popup][unview/only win]
	; unfocus here? it seems inappropriate, as we want this available generally in the inform
	; simply restore the previous focal-face?
]

; performs validation of a dialog and if true, sets the data to its content and closes it
dialog-use: func [face /local pnl vals] [
	pnl: back-face face/parent-face
	; validate dialog panel here and perform action on it
	if true [
		unfocus
		; deal with when no values from all disabled faces are there. when this is the case, the block returned from get-face pnl is full of nones
		vals: get-face pnl
		either all [block? vals equal? reduce [none] unique vals] [
			; this contains only disabled faces, so nothing can be saved
		][
			set-dialog-value face get-face pnl
		]
	]
]

; rebinds the face functions and actors in a layout to a new context
bind-face-func: func [content call-back] [
	traverse-face content [
		; rebind all actions
		if get in face 'action [bind second get in face 'action 'call-back]
		if get in face 'alt-action [bind second get in face 'alt-action 'call-back]
		; rebind all actors
		if get in face 'actors [
			; rebind each actor
		]
	]
]

;-- Tool Windows

; create new tool window
set 'tool func [title [string!] type [word! block!] content [any-type!] call-back [any-function!] /local layout-content lo] [
	;-- If already open, find and reuse that window
	if word? type [
		foreach window system/view/screen-face/pane [
			all [lo: find-style window type break]
		]
	]
	;-- Assign layout content
	layout-content: any [all [lo lo/parent-face] make-window either block? type [type][reduce [type]]]
	bind-face-func layout-content :call-back
	;-- Set content values
	if content [set-face/no-show layout-content/pane/1 content]
	;-- Display content
	either lo [
		show layout-content
	][
		; [ ] - need to bind callback somehow so the opener knows the window is closed
		view/new/title layout-content title
	]
]

; color tool window
set 'tool-color func [content output-func] [tool "Color Tool" 'layout-color content :output-func]

;-- Request Dialogs

make-button-group: func [buttons] [compose/deep [btn-group [across bar return (buttons)]]]

; create new request window
set 'request func [
	title [string!] type [word! block!] content [any-type!] button-group [word! block!]
	/local call-back layout-content
] [
	layout-content: either block? type [type][reduce [type]]
	layout-content:
		make-window
		append
			layout-content
			either word? button-group [
				button-group
			][
				make-button-group button-group
			]
	call-back: none
	bind-face-func layout-content :call-back
	if content [set-face/no-show layout-content/pane/1 content]
	; layout-content is perhaps not the same object as win
	inform/title layout-content title
	layout-content/data
]

;-- requesters

set 'request-dir		func [/file where /title ttl]			[request any [ttl "Get Directory"] 'layout-dir where 'use-cancel]
set 'request-color		func [value /title ttl]					[request any [ttl "Get Color"] 'layout-color value 'use-cancel]
set 'request-user		func [user pass /title ttl]				[request any [ttl "Enter User & Pass"] 'layout-user reduce [user pass] 'use-cancel]
set 'request-pass		func [value /title ttl]					[request any [ttl "Enter Password"] 'layout-pass value 'use-cancel]
set 'request-date		func [/date value /title ttl]			[request any [ttl "Enter Date"] 'layout-date any [value now/date] 'use-cancel]
set 'request-download	func [urls /title ttl]					[request any [ttl "Downloading..."] either block? urls ['layout-downloads]['layout-download] urls 'cancel]
set 'request-value		func [value /title ttl]					[request any [ttl "Enter Value"] 'layout-value value 'use-cancel]
set 'request-text		func [value /title ttl]					[request any [ttl "Enter Text"] 'layout-text value 'use-cancel]
set 'request-rename		func [value /title ttl]					[request any [ttl "Enter New Name"] 'layout-rename value 'use-cancel]
set 'request-email		func [target subject text /title ttl]	[request any [ttl "Send Email"] 'layout-email reduce [target subject text] 'send-cancel]
set 'request-message	func [target text /title ttl]			[request any [ttl "Send Message"] 'layout-message reduce [target text] 'send-cancel]
set 'request-item		func [data /title ttl]					[request any [ttl "Select One Item"] 'layout-list data 'use-cancel]
set 'request-items		func [data /title ttl]					[request any [ttl "Select Item(s)"] 'layout-lists data 'use-cancel]
set 'request-find		func [src /title ttl]					[request any [ttl "Search for Text"] 'layout-find data 'use-cancel]
set 'request-replace	func [src repl /title ttl]				[request any [ttl "Search and Replace Text"] 'layout-replace reduce [src repl] 'use-cancel]

;-- simpler dialogs

set 'question			func [str /buttons btns /title ttl]		[request any [ttl "Question"] 'layout-question str any [btns 'yes-no]]
set 'important-question	func [str /buttons btns /title ttl]		[request any [ttl "Question"] 'layout-warning str any [btns 'yes-no]]
set 'notify				func [str /title ttl]					[request any [ttl "Notification"] 'layout-notify str 'close]
set 'alert				func [str /title ttl]					[request any [ttl "Alert"] 'layout-alert str 'close]
set 'warn				func [str /title ttl]					[request any [ttl "Warning"] 'layout-warning str 'close]
set 'about-program		func [/title ttl]						[request any [ttl "About Program"] 'layout-about none 'close] ; not used?

; more complex, special dialogs
req-file: context [

dp: p1: ld: dn: s1: lf: fn: s2: p2: ef: p3: so: ob: ff: fp: fcnt: tt: none
n: n2: m: m2: 0
si: 1
files: none
picked: copy []
filters: none
dir-path: %.
done: none
out: dirs: none
filter-list: [["*"]["*.r" "*.reb" "*.rip"]["*.txt"]["*.jpg" "*.gif" "*.bmp" "*.png"]]

; requests a file via the native file requester
; note: this is a complicated function that needs to be cleaned up
set 'request-file func [
	"Requests a file using a popup list of files and directories."
	/title "Change heading on request."
		title-text "Title text of request"
		button-text "Button text for selection"
	/file name "Default file name or block of file names"
	/filter filt "Filter or block of filters"
	/keep "Keep previous settings and results"
	/only "Return only a single file, not a block."
	/path "Return absolute path followed by relative files."
	/save "Request file for saving, otherwise loading."
	/local where data filt-names filt-values
] [
	either file [ ; Otherwise uses previous value
		either block? name [picked: copy name][picked: reduce [to-file name]]
	][
		unless keep [picked: copy []]
	]
	if none? picked [picked: copy []]
	if file: picked/1 [where: first split-path file]
	while [not tail? picked] [	; remove any files not in the path
		set [name file] split-path first picked
		either name <> where [
			remove picked
		][
			change picked file
			picked: next picked
		]
	]
	picked: head picked
	if any [not where not exists? where] [where: clean-path %.]
	unless keep [
		;fp/data: head fp/data ; filter
		;so/data: head so/data ; sorting
		;si: 1 ; sort index
	]
	either filter [
		filters: either block? filt [filt][reduce [filt]]
	][
		;if any [not keep not block? filters][pick-filter]
	]
	;filter-text: form filters
	title-text: either title [copy title-text]["Select a File:"]
	button-text: either title [copy button-text]["Select"]
	if all [
		; open native file requester
		error? done: try [
			filt-names: copy ["Normal" "REBOL" "Text" "Images"] ; change this
			filt-values: copy filter-list
			either filter [
				insert head filt-names "Custom"
				insert/only filt-values filters
			] [
				filt-names: at filt-names 1;index? fp/data
			]
			; form native file requester
			done: local-request-file data: reduce [
				title-text			; requester title text
				button-text			; select button text
				clean-path where	; the path to start from
				picked				; which files are picked
				filt-names			; filtering of names
				filt-values			; selected extensions for filtering
				found? any [only]	; whether to select only one file
				found? any [save]	; whether to use a save button instead of select button
			]
			; output data
			if done [
				dir-path: data/3
				picked: data/4
				;unless filter [fp/data: at head fp/data index? data/5] ; what does this do?
			]
			done
		]
		(get in disarm done 'code) = 328	; RE_FEATURE_NA
	] [
		; if native requester fails, open VID version
		done: false
		read-dir/full either where [where][dir-path]
		; local-request-file has failed
		;show-pick
		;inform out ; wrong
		;unfocus
	]
	if error? done [done]
	; process collected output
	if all [done  picked  any [path not empty? picked]] [
		either path [
			done: insert copy picked copy dir-path
			either only [done/1][head done]
		][
			foreach file picked [insert file dir-path]
			either only [picked/1][picked]
		]
	]
]

]

]

