REBOL [
	Title: "VID Requesters"
	Short: "VID Requesters"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %request.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 17-May-2009
	Date: 17-May-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Provides standard requesters for VID
	}
	History: []
	Keywords: []
]

; requests should be simplified. There should be a base function, and then a few other functions that work absolutely on this base function, no refinements allowed.

request: func [
	"Requests an answer to a simple question."
	str [string! block! object! none!]
	/title ttl
	/buttons btns [block!]
	/local lo
] [
	any [btns btns: ["OK" "Cancel"]]
	str: either block? str [str][reduce [str copy ""]]
	str-size: size-text make face [
		size: 1000x100
		text: str
		para/margin: 2x2
		para/origin: 2x2
		font/style: 'bold
		font/size: 14
	]
	str-size: str-size + 4
	str2-size: 0x0
	pnl-size: max 200x75 str-size
	ttt: lo: make-window [
		panel [
			across
			frame 75x75 [
				image help.gif align [center] spring [left right top bottom]
			]
			panel pnl-size [
				text str-size font-size 14 bold str/1 spring [left]
				text 200 font-size 11 str/2 spring [left]
			]
		]
		button-group with [texts: btns]
	]
	inform/title lo copy any [ttl "Request"]
	lo/result
]

request-pass: func [
	"Requests a user name and a password."
	user [string! none!]
	pass [binary! none!] ; as a precaution, passwords should absolutely never be passed in the clear
	/local lo f f-user f-pass
] [
	lo: make-window [
		compound 350x125 [
			h3 "Enter Username and Password"
			bar
			panel fill 0x0 align [center] spring [left right top bottom] [
				across
				label "User Name"
					field user
					validate [
						pick [valid required] not empty? get-face face
					]
					valid-indicator
					return
				label "Password" secure-field
			]
		]
		ok-cancel
	]
	inform lo
	if lo/result [
		f-user: lo/pane/1/pane/3/pane/2
		f-pass: lo/pane/1/pane/3/pane/6
		reduce [
			get-face f-user
			all [
				get-face f-pass
				checksum/secure get-face f-pass
			]
		]
	]
]

about: func [
	"Displays an About requester based on the header of the script."
] [
	lo: make-window compose/deep [
		; [ ] - gather data from current script
		; [ ] - present data from current script in layout
	]
	inform lo
]

; date generator needs to be from R3, if we are to change it. it could be necessary to do that now.

request-date: func [
	"Requests a date."
	/date when "Default date"
	/local selected-date requested-date lo lo-days day-color week
][
	; [ ] - localized human formatting of date
	;       [x] - grab real date no longer from text but from selected date
	;       [ ] - localized system/locale
	; [?] - find first day of the visible area

	selected-date: requested-date: either date [when][now/date]
	lo: make block! [
		style dotw box 30x30 font [size: 12 shadow: none color: white] black
		style day toggle-box 30x30 edge none [
			use [date] [
				date: selected-date
				date/day: to-integer face/text
				selected-date: date
				date/month: selected-date/month + face/month-offset
				lo/pane/2/text: either value? 'to-localized-date [
					to-localized-date date
				][
					mold date
				]
				show lo/pane/2
			]
		] with [
			month-offset: 0
			text: none
		]
		style ar arrow gray 24x24 edge [size: 2x2 color: 160.160.160]
		space 2 across
		ar left [selected-date/month: selected-date/month - 1 set-days selected-date]
		text 158x24 center bold with [spring: none]
		ar right [selected-date/month: selected-date/month + 1 set-days selected-date]
		return
		panel with [flags: [panel tabbed]]
	]
	lo-days: make block! [across space 0]
	week: system/locale/days
	day-color: gray
	set-days: has [colors mstartday day-btn lead-in-days running-date fday] [
		fday: 7
		mstartday: selected-date - selected-date/date/day + 1
		lead-in-days: ((mstartday/weekday - 1) + (pick [6 5 4 3 2 1 0] fday)) // 7
		running-date: mstartday - lead-in-days
		set-face lo/pane/2 selected-date
		days: lo/pane/4/pane
		repeat i 42 [
			day-btn: pick days i + 7
			day-btn/colors/1:
				pick
					either selected-date/month <> running-date/month [
						day-btn/month-offset: running-date/month - selected-date/month
						either selected-date = running-date [
							[255.120.100 120.120.120]
						][
							either now/date = running-date [
								[100.120.140 120.120.120]
							][
								[140.120.100 120.120.120]
							]
						]
					][
						day-btn/month-offset: 0
						either selected-date = running-date [
							either now/date = running-date [
								[255.140.120 80.120.160]
							][
								[255.140.120 140.140.140]
							]
						][
							either now/date = running-date [
								[120.140.160 80.120.160]
							][
								[160.140.120 140.140.140]
							]
						]
					]
					zero? i // 7
			day-btn/text: mold running-date/day
			set-face/no-show day-btn selected-date = running-date
			running-date: running-date + 1 ; still wrong
		]
		show days
	]
	repeat i 7 [
		repend lo-days ['dotw copy/part system/locale/days/:i 2]
	]
	append lo-days 'return
	loop 6 [
		loop 7 [
			repend lo-days ['day 'of to-lit-word 'days]
		]
		append lo-days 'return
	]
	append/only lo lo-days
	append lo [return use-cancel]
	lo: make-window lo
	print dump-face lo
	set-days
	inform/title lo "Select Date"
	if lo/result [selected-date]
]