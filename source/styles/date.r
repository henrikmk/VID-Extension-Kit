REBOL [
	Title: "VID Date Field"
	Short: "VID Date Field"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2008 - HMK Design"
	Filename: %date.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-Dec-2008
	Date: 26-Dec-2008
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Easy Date Field
	}
	History: []
	Keywords: []
]

stylize/master [
	; [ ] - sometimes the birthdate can be read out as zero
	; date indication field
	DATE-FIELD: COMPOUND 200x24 spring [bottom right] with [
		font: face/font
		multi: make multi [
			text: func [face blk][
				if pick blk 1 [
					face/text: attempt [to-date first blk]
					face/texts: copy blk
				]
			]
		]
		day-act: [numeric-range face [1 31] zero-pad face 2]
		month-act: [numeric-range face [1 12] zero-pad face 2]
		year-act: [numeric-range face [0 9999] zero-pad face 4]
		access: make access [
			set-face*: func [face value] [
				value: attempt [to-date value]
				unless value [exit]
				unless face/pane [exit]
				set-face/no-show face/pane/1 value/day
				set-face/no-show face/pane/2 value/month
				set-face/no-show face/pane/3 value/year
			]
			get-face*: func [face] [
				attempt [
					to-date to-string reduce [
						face/pane/3/data '-
						face/pane/2/data '-
						face/pane/1/data
					]
				]
			]
		]
		content: [
			across space 0
			style
				if
					field integer max-length 2 fill 0x1
						on-key [act-face face/parent-face event 'on-key]
						[do-face face/parent-face none]
						with [append flags [auto-tab] font: (make self/font [])]
			if 30 on-tab day-act on-set day-act
			if 30 on-tab month-act on-set month-act
			if 44 on-tab year-act on-set year-act max-length 4
			button 24x0 fill 0x1 "..." on-click [
				show-menu-face/hinge
					face
					[
						layout-date
							on-init-window [
								use [d] [
									d: get-face get in get-opener-face 'parent-face
									set-face face d/date
								]
							]
							on-click [
								use [pf] [
									set-face pf: get in get-opener-face 'parent-face value
									hide-menu-face
									do-face pf none
									act-face pf none 'on-click
									act-face pf none 'on-select
								]
							]
							on-key [
								if find [#" " #"^M"] event/key [
									act-face face none 'on-click
									act-face face none 'on-select
								]
							]
							on-escape [
								hide-menu-face
							]
					]
					[bottom right]
					[top right]
			]
		]
		init: [
			pane: layout/tight compose/only/deep content
			set-parent-faces self
			size/x: max size/x pane/size/x
			pane: pane/pane
			set-face/no-show self now
		]
	]

	; date field with time indication
	DATE-TIME-FIELD: DATE-FIELD with [
		hour-act: [numeric-range face [0 23] zero-pad face 2]
		minute-act:
		second-act: [numeric-range face [0 59] zero-pad face 2]
		content: [
			across space 0
			style
				if
					field integer max-length 2 fill 0x1
						on-key [act-face face/parent-face event 'on-key]
						[do-face face/parent-face none]
						with [spring: none append flags [auto-tab] font: (make self/font [])]
			if 30 on-tab day-act on-set day-act
			if 30 on-tab month-act on-set month-act
			if 44 on-tab year-act on-set year-act max-length 4
			if 30 on-tab hour-act on-set hour-act
			if 30 on-tab minute-act on-set minute-act
			if 30 on-tab second-act on-set second-act
			button 24x0 fill 0x1 "..." on-click [
				show-menu-face/hinge
					face
					[
						layout-date
							on-init-window [
								use [d] [
									d: get-face get in get-opener-face 'parent-face
									set-face face d/date
								]
							]
							on-click [
								use [pf] [
									set-face pf: get in get-opener-face 'parent-face value
									hide-menu-face
									do-face pf none
									act-face pf none 'on-click
									act-face pf none 'on-select
								]
							]
							on-key [
								if find [#" " #"^M"] event/key [
									act-face face none 'on-click
									act-face face none 'on-select
								]
							]
							on-escape [
								hide-menu-face
							]
					]
					[bottom right]
					[top right]
			]
		]
		access: make access [
			set-face*: func [face value /local time] [
				value: attempt [to-date value]
				unless value [exit]
				unless face/pane [exit]
				; all values should be zero-padded, but how do we do that with integer fields?
				; the text representation should allow this independently from the integer presentation
				set-face/no-show face/pane/1 value/day
				set-face/no-show face/pane/2 value/month
				set-face/no-show face/pane/3 value/year
				if value/time [
					set-face/no-show face/pane/4 value/time/1
					set-face/no-show face/pane/5 value/time/2
					set-face/no-show face/pane/6 to-integer value/time/3 ; why is this still decimal?
				]
			]
			get-face*: func [face] [
				attempt [
					to-date to-string reduce [
						face/pane/3/text '-
						face/pane/2/text '-
						face/pane/1/text
						"/"
						face/pane/4/text ":"
						face/pane/5/text ":"
						face/pane/6/text ":"
					]
				]
			]
		]
	]

	; single cell for the DATE-MONTH array to describe a weekday
	DATE-WEEKDAY-CELL: IMAGE with [
		data: none
		colors: none
		feel: make face/feel [
			engage: func [face act event] [] ; disallows passing events here
		]
		init: [
			colors: reduce [
				font/color
				255.255.255 - font/color
			]
		]
	]

	; single cell for the DATE-MONTH array
	DATE-CELL: DATE-WEEKDAY-CELL with [
		feel: make face/feel [
			engage: func [face act event] [
				if act = 'down [
					set-face face/parent-face get-face face
					act-face face/parent-face event 'on-click
				]
			]
		]
		access: make access [
			set-face*: func [face value] [
				;-- Cell date
				if date? value [
					face/data: value
					face/text: form value/day
				]
				;-- Cell indicators
				face/color: ctx-colors/colors/day-color
				if block? value [
					either find value 'out-of-month [
						face/color: ctx-colors/colors/out-of-month-color
					][
						if find value 'weekend [
							face/color: ctx-colors/colors/weekend-color
						]
						if find value 'selected [
							face/color: face/color + 20
						]
						if find value 'day [
							face/color: ctx-colors/colors/today-color
						]
					]
				]
			]
			get-face*: func [face] [
				face/data
			]
		]
	]

	; displays a static month array of date cells
	DATE-MONTH: COMPOUND with [
		dates: none
		sunday: false
		color: ctx-colors/colors/grid-color
		access: make access [
			set-face*: func [face value /local i start-date] [
				if date? value [face/data: value/date]			; store date as for month to display
				start-date: face/data							; requested date
				start-date: start-date - start-date/day + 1		; first day of month
				start-date: start-date - start-date/weekday + 1	; first day visible in month calendar
				i: 0
				;-- Distribute dates for all cells
				foreach day face/pane [
					either i < 7 [
						day/text: copy/part pick system/locale/days i + 1 2
					][
						set-face/no-show day current-date: start-date + i - 7
						set-face/no-show day reduce [
							if current-date/month <> face/data/month ['out-of-month]
							;if current-date = now ['today]
							if find [6 7] current-date/weekday ['weekend]
							if current-date = face/data ['day] ; there may not be one
							;if all [dates find dates current-date] ['selected] ; fix this later
						]
					]
					i: i + 1
				]
			]
			get-face*: func [face] [face/data]
		]
		init: [
			any [data data: now]
			pane: make block! [across space 1 origin 1]
			;-- Day Names
			repeat i 7 [
				insert tail pane 'date-weekday-cell
			]
			insert tail pane 'return
			;-- Dates
			repeat i 6 [
				insert insert/dup tail pane 'date-cell 7 'return
			]
			pane: layout/tight pane
			size: pane/size
			pane: pane/pane
			dates: make block! []
			access/set-face* self data
		]
	]

	; displays a keyboard and mouse navigable month array of date cells
	DATE-NAV-MONTH: DATE-MONTH with [
		access: make access [
			key-face*: func [face event] [
				set-face* face
					switch event/key [
						up [face/data - 7]
						down [face/data + 7]
						left [face/data - 1]
						right [face/data + 1]
					]
				act-face face event 'on-key
				if event/key = #"^M" [
					act-face face event 'on-return
				]
				event
			]
			; scroll-wheel moves back and forth one month
			scroll-face*: func [face x y] [
				set-face* face face/data/month: face/data/month + pick [1 -1] positive? y
				act-face face none 'on-scroll
				true
			]
		]
	]
]
