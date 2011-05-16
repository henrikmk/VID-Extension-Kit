;REBOL [
;	Title:  "REBOL/View: Requestors"
;	Author: "Carl Sassenrath"
;	Rights: "Copyright 2000 REBOL Technologies. All rights reserved."
;	; You are free to use, modify, and distribute this software with any
;	; REBOL Technologies products as long as the above header, copyright,
;	; and this comment remain intact. This software is provided "as is"
;	; and without warranties of any kind. In no event shall the owners or
;	; contributors be liable for any damages of any kind, even if advised
;	; of the possibility of such damage. See license for more information.
;
;	; Please help us to improve this software by contributing changes and
;	; fixes via http://www.rebol.com/feedback.html - Thanks!
;]
;
;req-funcs: context [
;
;	set 'request func [
;		"Requests an answer to a simple question."
;		str [string! block! object! none!]
;		/title ttl
;		/buttons btns [block!]
;		/local lo
;	] [
;		any [btns btns: ["OK" "Cancel"]]
;		str: either block? str [str][reduce [str copy ""]]
;		str-size: size-text make face [
;			size: 1000x100
;			text: str
;			para/margin: 2x2
;			para/origin: 2x2
;			font/style: 'bold
;			font/size: 14
;		]
;		str-size: str-size + 4
;		str2-size: 0x0
;		pnl-size: max 200x75 str-size
;		ttt: lo: make-window probe [
;			panel [
;				across
;				frame spring [right] 75x75 [
;					image help.gif align [center] spring [left right top bottom]
;				]
;				panel pnl-size [
;					text str-size font-size 14 bold str/1 spring [left]
;					text 200 font-size 11 str/2 spring [left]
;				]
;			]
;			button-group with [texts: btns]
;		]
;		inform/title lo copy any [ttl "Request"]
;		lo/result
;	]
;
;	set 'message func [
;		"Displays a message along with an icon and a close button"
;		message
;		title
;		button-text
;		icon
;	] [
;		any [button-text "OK"]
;		lo: make-window compose/deep [
;			panel [
;				across
;				frame spring [vertical right] 75x75 [
;					image (icon) align [center] spring [left right top bottom]
;				]
;				panel 200x75 [text 200x75 message]
;			]
;			close with [texts: [(button-text)]]
;		]
;		inform/title lo title
;	]
;
;	; The titles of these windows should have the function names e.g.: alert !!!
;	set 'alert func ["Flashes an alert message to the user. Waits for a user response." str] [message str "Alert" "OK" exclamation.gif]
;	set 'notify func ["Flashes an informational message to the user. Waits for a user response." str] [message str "Notification" "OK" info.gif]
;
;	set 'confirm func [
;		"Confirms a user choice." 
;		question [series!] "Prompt to user"
;		/with choices [string! block!] 
;		/local yes no
;	][
;		question: form question
;		if with [
;			yes: "Yes"
;			no: "No"
;			if string? choices [yes: choices]
;			if all [block? choices not empty? choices] [
;				either tail? next choices [yes: choices/1][set [yes no] choices]
;			]
;			question: reduce [question yes no]
;		]
;		request/confirm question
;	]
;
;	set 'flash func [
;		"Flashes a message to the user and continues."
;		val
;		/with face "Center over this face"
;		/offset xy
;	][
;		val: layout [
;			origin 10x10
;			image info.gif
;			origin 62x24
;			text bold form val 200x-1
;			origin 20x20
;		]
;		val/text: "Information"
;		either offset [val/offset: xy][
;			center-face val
;			if with [center-face/with val face]
;		]
;		view/new val
;		val ; unview it later
;	]
;
;	req-color: context [
;		color-lay: x: t: r: g: b: none
;		mods: func [slid clr rgb] [slid/effect/4: poke rgb clr 0 slid/effect/3: poke rgb clr 255]
;		refresh: does [
;			mods r 1 x/color
;			mods g 2 x/color
;			mods b 3 x/color
;			t/text: x/color
;			show [x t r g b]
;		]
;		setc: func [clr val][
;			x/color: poke x/color clr to-integer 255 * (1 - val)
;			refresh
;		]
;		set 'request-color func [
;			"Requests a color value."
;			/color clr /title ttl /offset xy /local result
;		][
;			if none? :color-lay [
;				color-lay: make-window [
;					panel [
;						across
;						x: box 80x30 ibevel
;						t: field center middle 80 font-size 11
;					]
;					panel [
;						r: slider 278x16 gray red effect [gradient 1x0 0.0.0 255.0.0] [setc 1 r/data] spring [horizontal]
;						g: slider 278x16 gray green effect [gradient 1x0 0.0.0 0.255.0] [setc 2 g/data] spring [horizontal]
;						b: slider 278x16 gray blue effect [gradient 1x0 0.0.0 0.0.255] [setc 3 b/data] spring [horizontal]
;					]
;					ok-cancel
;					;pad 8 btn-enter "OK" 64 [result: x/color hide-popup]
;					;return
;					;pad 8 btn-cancel "None" escape 64 [hide-popup]
;				]
;			]
;			x/color: either tuple? clr [clr][0.0.0]
;			r/data: 1 - (x/color/1 / 255)
;			g/data: 1 - (x/color/2 / 255)
;			b/data: 1 - (x/color/3 / 255)
;			refresh
;			either offset [inform/offset/title color-lay xy][inform color-lay any [ttl "Select Color"]]
;			if color-lay/result [x/color]
;		]
;	]
;
;	req-pass: context [
;		userf: pass: ok: pass-lay: none
;		set 'request-pass func [
;			"Requests a username and password."
;			/offset xy
;			/user username
;			/only "Password only."
;			/title title-text
;		][
;			if none? user [username: copy ""]
;			pass-lay: layout compose [
;				style tx text 40x24 middle right
;				across origin 10x10 space 2x4
;				h3 (either title [title-text][either only ["Enter password:"]["Enter username and password:"]])
;				return
;				(either only [[]][[tx "User:" userf: field username return]])
;				tx "Pass:" pass: field hide [ok: yes hide-popup] with [flags: [return tabbed]] return
;				pad 140 
;				;btn-enter 50 [ok: yes hide-popup]
;				;btn-cancel 50 #"^(ESC)" [hide-popup]
;				button 50 [ok: yes hide-popup]
;				button 50 #"^(ESC)" [hide-popup]
;			]
;			ok: no
;			focus either only [pass][userf]
;			either offset [inform/offset pass-lay xy][inform pass-lay]
;			all [ok either only [pass/data][reduce [userf/data pass/data]]]
;		]
;	]
;
;	req-text: context [
;		tf: ok: text-lay: none
;		set 'request-text func [
;			"Requests a text string be entered."
;			/offset xy
;			/title title-text
;			/default str
;		][
;			if none? str [str: copy ""]
;			text-lay: layout compose [
;				across origin 10x10 space 2x4
;				h3 bold (either title [title-text]["Enter text below:"])
;				return
;				tf: field 300 str [ok: yes hide-popup] with [flags: [return]] return
;				pad 194
;				;btn-enter 50 [ok: yes hide-popup]
;				;btn-cancel 50 #"^(ESC)" [hide-popup]
;				button 50 [ok: yes hide-popup]
;				button 50 #"^(ESC)" [hide-popup]
;			]
;			ok: no
;			focus tf
;			either offset [inform/offset text-lay xy][inform text-lay]
;			all [ok tf/text]
;		]
;	]
;
;	req-list: context [
;		set 'request-list func [
;			"Requests a selection from a list."
;			titl [string!]
;			alist [block!] /offset xy /local rslt list-lay
;		] [
;			list-lay: layout [
;				;across space 4x8
;				origin 10x10
;				h3 titl
;				text-list data alist [rslt: value hide-popup]
;				btn-cancel #"^(ESC)" [rslt: none hide-popup]
;			]
;			rslt: none
;			either offset [inform/offset list-lay xy][inform list-lay]
;			rslt
;		]
;	]
;
;	req-date: context [
;		cell-size: 24x24
;		result: today: base: date-lay: offs: mo-box: last-f: none
;		day-edge: make face/edge [color: sky size: 2x2]
;
;		calc-month: func [month /local slot bas][
;			bas: base
;			bas/day: slot: 1
;			bas/month: month
;			foreach face skip date-lay/pane 3 [
;				face/edge: none
;				either any [slot <= bas/weekday  bas/month <> month][face/text: none][
;					if bas/date = today/date [face/edge: day-edge]
;					face/text: bas/day  bas: bas + 1
;				]
;				slot: slot + 1
;			]
;			show date-lay
;		]
;
;		md: func [date] [join pick system/locale/months date/month [" " date/year]]
;
;		init: does [
;			date-lay: layout [
;				size cell-size * 7
;				origin 0x0 space 0
;				across
;				arrow left cell-size [
;					either base/month = 1 [base/year: base/year - 1  base/month: 12][
;						base/month: base/month - 1
;					]
;					mo-box/text: md base  show mo-box
;					calc-month base/month
;				]
;				mo-box: text cell-size * 5x1 md base center middle bold
;				arrow right cell-size [base/month: base/month + 1  calc-month base/month
;					mo-box/text: md base  show mo-box]
;				return
;				offs: at
;			]
;
;			last-f: none
;			cell-feel: make face/feel [
;				over: func [f a] [
;					if f/text [f/color: yello show f if last-f [last-f/color: white show last-f]]
;					last-f: f
;				]
;				engage: func [f a e] [
;					if all [a = 'down f/text] [base/day: f/text f/color: white result: base hide-popup]
;				]
;			]
;
;			repeat slot 42 [
;				fon: make face/font [valign: 'middle align: 'center]
;				append date-lay/pane make face [
;					offset: offs  size: cell-size  color: white  edge: none  font: fon
;					feel: cell-feel
;				]
;				offs/x: offs/x + cell-size/x
;				if zero? slot // 7 [offs: offs + cell-size * 0x1]
;			]
;			calc-month base/month
;		]
;
;		set 'request-date func [
;			"Requests a date."
;			/offset xy
;			/date when "Default date"
;		][
;			result: when ; NONE if not set
;			base: today: any [when now/date]
;			either date-lay [calc-month base/month] [init]
;			either offset [inform/offset date-lay xy][inform date-lay]
;			result
;		]
;	]
;]
;
;req-file: context [
;	dp: p1: ld: dn: s1: lf: fn: s2: p2: ef: p3: so: ob: ff: fp: fcnt: tt: none
;	n: n2: m: m2: 0
;	si: 1
;	files: none
;	picked: copy []
;	filters: none
;	dir-path: %.
;	done: none
;	out: dirs: none
;	filter-list: [["*"]["*.r" "*.reb" "*.rip"]["*.txt"]["*.jpg" "*.gif" "*.bmp" "*.png"]]
;
;	pick-file: func [f] [alter picked f/text  show-pick]
;
;	show-pick: does [
;		ef/text: mold picked
;		remove ef/text
;		remove back tail ef/text
;		ef/line-list: none  ; !!! should not be required in simple cases like this!!!
;		show ef
;	]
;
;	reset-scroll: does [
;		m: m2: n: n2: 0
;		s1/data: s2/data: 0.0
;		show out
;	]
;
;	reshow: does [
;		clear ef/text
;		clear picked
;		system/view/focal-face:
;		system/view/caret:
;		system/view/highlight-start:
;		system/view/highlight-end: none
;		reset-scroll
;	]
;
;	start-out: [
;	out: layout [
;		across origin 8x8 space 0x4
;		style txt txt font-size 11
;		style lab text 50x24 middle right bold para [wrap?: no]
;		style fld field 336x24 middle font-size 11
;		style btn button 72x24
;		style rty rotary 72x24
;
;		tt: h2 "Select a File:" 400x24 left
;		return
;		lab "Path: "
;		dp: fld form what-dir [read-dir/full dp/text reshow]
;		p1: at
;		;pad -16x2 arrow down 14x20 180.180.180
;		return
;		lab "Dirs:"
;
;		ld: data-list 320x72 with [
;			source: read-dir dp/text
;		]
;		;ld: list 320x72 [
;		;	dn: txt 200x16 [read-dir dn/text reshow]
;		;] supply [
;		;	count: count + n
;		;	face/text: ""
;		;	face/font/color: black
;		;	if count > length? dirs [return none]
;		;	face/text: pick dirs count
;		;]
;		sl: scroller 20x72 fill 0x0
;		;s1: slider 16x72 [
;		;	n2: to-integer s1/data * ((length? dirs) - (ld/size/y / dn/size/y) + 2)
;		;	if n <> n2 [n: n2 show ld]
;		;]
;		return
;
;		lab "Filters:"
;		ff: fld "*" [filters: parse ff/text none  read-dir none reshow]
;		pad 6x0
;		fp: rty "Normal" "REBOL" "Text" "Images" [
;			pick-filter
;			read-dir none reshow
;		]
;		return
;		lab "Files:"
;		
;		lf: data-list 320x264 with [
;			source: []
;		]
;		;lf: list 320x264 [
;		;	across space 0x0
;		;	fn: txt 120x16
;		;	txt 60x16 right
;		;	txt 75x16 right
;		;	txt 55x16 right 
;		;] supply [
;		;	fcnt: count: count + m
;		;	face/font/color: black
;		;	face/text: ""
;		;	if count > length? files [return none]
;		;	face/text: do pick [
;		;		[files/:count/1]
;		;		[files/:count/2]
;		;		[all [date? files/:count/3 files/:count/3/date]]
;		;		[all [date? files/:count/3 files/:count/3/time]]
;		;	] index
;		;]
;
;		s2: scroller 20x264 fill 0x0
;		;slider 16x264 [
;		;	m2: to-integer s2/data * ((length? files) - (lf/size/y / fn/size/y) + 2)
;		;	if m <> m2 [m: m2 show lf]
;		;]
;		p2: at return
;		lab "Name:"
;		ef: fld [
;			if not error? try [picked: parse ef/text none] [
;				foreach file picked [if #"%" = first file [remove file]]
;				forall picked [change picked to-file first picked]
;				picked: unique head picked
;				show-pick
;			]
;		]
;		p3: at below at p1 + 6x0
;		btn "Parent" [read-dir %.. reshow]
;		;btn "Make Dir"
;		at p2 + 6x0
;		;lab 70 "Sort By:" center
;		so: rty "By Name" "Newest" "Oldest" "Largest" "Smallest" [
;			si: index? so/data
;			sort-files
;			reset-scroll
;			show lf
;		]
;		pad 20
;		btn "All" [
;			clear picked
;			foreach file files [append picked first file]
;			show-pick
;			show lf
;		]
;		btn "Clear" [clear picked show-pick show lf]
;		btn "Refresh" [read-dir none show lf]
;		pad 0x40
;;does not work, requestor in a requestor bug	btn "Delete" [delete-files read-dir none reshow]
;;		btn "Rename"
;		at p3 + 6x0
;;		ob: btn-enter 72x24 "Save" [done: true hide-popup]
;		ob: button 72x24 "Save" [done: true hide-popup]
;		at p3 + 6x-28
;;		btn-cancel 72x24 "Cancel" [hide-popup]
;		button 72x24 "Cancel" [hide-popup]
;		across
;
;	]
;
;	deflag-face ef tabbed  ;!!!should be a face option to not tab
;	deflag-face dp tabbed
;
;	fn/feel: make fn/feel [
;		redraw: func [f a i] [
;			f/color: either find picked f/text [240.240.50][240.240.240]
;		]
;		over: func [f a e] [
;			if all [a integer? f/state][
;				clear picked
;				for n f/state min fcnt length? files either fcnt > f/state [1][-1][
;					append picked first pick files n
;				]
;				show lf
;			]
;		]
;		engage: func [f a e] [
;			if a = 'down [
;				if fcnt > length? files [exit]
;				if not e/control [f/state: fcnt clear picked]
;				pick-file f
;				show lf
;			]
;			if a = 'over [if integer? f/state [clear picked append picked f/text show lf]]
;			if a = 'up [f/state: none show-pick]
;		]
;	]
;
;	]
;
;;	find-file: func [name] [foreach item files [if item/1 = name [return item]]]
;
;	filter-files: does [
;		while [not tail? files] [
;			either foreach filter filters [
;				if find/any files/1/1 filter [break/return true]
;				false
;			][files: next files][remove files]
;		]
;		files: head files
;	]
;
;	pick-filter: does [
;		filters: pick filter-list index? fp/data
;		ff/text: form filters show ff
;	]
;
;	sort-files: does [
;		sort/compare files func [a b] pick [
;			[a/1 < b/1] ; name
;			[a/3 > b/3] ; newest
;			[a/3 < b/3] ; oldest
;			[a/2 > b/2] ; largest
;			[a/2 < b/2] ; smallest
;		] si
;	]
;
;	delete-files: function [][safe] [
;		safe: on
;		foreach file picked [
;			if safe [
;				safe: request [join "Are you sure you want to delete " [dir-path/:file "?"] "Yes" "All" "Cancel"]
;				if none? safe [exit]
;			]
;			error? try [delete dir-path/:file]
;		]
;	]
;
;	read-dir: func [dir /full /local new-path file-info file] [
;		files: []
;		show lf 
;		if dir [
;			new-path: dirize clean-path either full [to-file dir] [dir-path/:dir]
;			if exists? new-path [dir-path: new-path]
;		]
;		dp/text: form dir-path
;		if error? try [files: read dir-path][files: copy []]
;		dirs: copy []
;		while [not tail? files] [
;			file: first files
;			file: dir-path/:file
;			either file-info: info? file [
;				either file-info/type = 'directory [append dirs first files remove files]
;					[change/only files reduce [files/1 file-info/size file-info/date] files: next files]
;			] [files: next files]
;		]
;		dirs: sort dirs
;		files: head files
;		m: m2: n: n2: 0
;		s1/data: 0.0
;		s2/data: 0.0
;		s1/redrag (ld/size/y / dn/size/y) / max 1 length? dirs 
;		s2/redrag (lf/size/y / fn/size/y) / max 1 length? files
;		filter-files
;		sort-files
;	]
;
;	set 'request-file func [
;		"Requests a file using a popup list of files and directories."
;		/title "Change heading on request."
;			title-line "Title line of request"
;			button-text "Button text for selection"
;		/file name "Default file name or block of file names"
;		/filter filt "Filter or block of filters"
;		/keep "Keep previous settings and results"
;		/only "Return only a single file, not a block."
;		/path "Return absolute path followed by relative files."
;		/save "Request file for saving, otherwise loading."
;		/local where data filt-names filt-values
;	][
;		if none? out start-out ; fails, because layout is wrong
;		either file [ ; Otherise uses previous value
;			either block? name [picked: copy name][picked: reduce [to-file name]]
;		][
;			if not keep [picked: copy []]
;		]
;		if none? picked [picked: copy []]
;		if file: picked/1 [where: first split-path file]
;		probe 'd
;		while [not tail? picked] [	; remove any files not in the path
;			set [name file] split-path first picked
;			either name <> where [remove picked][
;				change picked file
;				picked: next picked
;			]
;		]
;		picked: head picked
;		if any [not where not exists? where] [where: clean-path %.]
;		if not keep [
;			fp/data: head fp/data
;			so/data: head so/data
;			si: 1
;		]
;		either filter [
;			filters: either block? filt [filt][reduce [filt]]
;		][if any [not keep not block? filters][pick-filter]]
;		ff/text: form filters
;		tt/text: either title [copy title-line]["Select a File:"] 
;		ob/text: either title [copy button-text]["Select"]
;
;		if all [
;			error? done: try [
;				filt-names: copy head fp/data
;				filt-values: copy filter-list
;				either filter [
;					insert head filt-names "Custom"
;					insert/only filt-values filters
;				] [
;					filt-names: at filt-names index? fp/data
;				]
;				done: local-request-file data: reduce
;					[tt/text ob/text clean-path where picked filt-names filt-values found? any [only] found? any [save]]
;				if done [
;					dir-path: data/3
;					picked: data/4
;					if not filter [fp/data: at head fp/data index? data/5]
;				]
;				done
;			]
;			(get in disarm done 'code) = 328	; RE_FEATURE_NA
;		] [
;			done: false
;			read-dir/full either where [where][dir-path]
;			show-pick
;			inform out
;			unfocus
;		]
;		if error? done [done]
;		if all [done  picked  any [path not empty? picked]] [
;			either path [
;				done: insert copy picked copy dir-path
;				either only [done/1][head done]
;			][
;				foreach file picked [insert file dir-path]
;				either only [picked/1][picked]
;			]
;		]
;	]
;]
;
;req-dir: context [
;	dirs: []
;	max-dirs:
;	cnt: 0
;	path:
;	last-path:
;	f-name:
;	f-list:
;	f-txt:
;	f-slid:
;	f-path:
;	f-title:
;	result:
;		none
;
;	show-dir: does [
;		dirs: attempt [load dirize path]
;		if not dirs [
;			path: last-path
;			if not dirs: attempt [load dirize path][
;				alert reform ["Directory does not exist:" path]
;				path: what-dir
;				dirs: any [attempt [load path] copy []]
;			]
;		]
;		remove-each file dirs [(last file) <> slash]
;		foreach file dirs [remove back tail file]
;		sort dirs
;		f-name/text: any [attempt [second split-path path] "(Top)"]
;		f-path/text: any [attempt [to-local-file path] copy ""]
;		f-slid/redrag max-dirs / max 1 length? dirs
;		f-slid/data: 0.0
;		cnt: 0
;		show [f-list f-name f-path f-slid]
;	]
;
;	chg-dir: func [file][
;		if none? file [exit]
;		last-path: path
;		path: path/:file
;		show-dir
;	]
;
;	back-dir: does [
;		last-path: copy path
;		clear find/last path slash
;		show-dir
;	]
;
;	dirout: [
;		origin 10 space 0
;		backeffect base-effect
;		f-title: h4 200 para [origin: 0x0]
;		pad 4
;		f-name: text white bold black 200 "Parent" [back-dir]
;		across
;		f-list: list 184x200 [
;			f-txt: text font-size 11 200 font [colors: [0.0.0 0.0.0]] [chg-dir value]
;		] supply [
;			count: count + cnt
;			face/color: pick [240.240.240 220.220.220] odd? count
;			if not block? dirs [dirs: copy []]
;			face/text: pick dirs count
;		]
;		f-slid: scroller 16x200 [
;			c: to-integer value * ((length? dirs) - max-dirs)
;			if c <> cnt [cnt: c show f-list]
;		]
;		return
;		f-path: field wrap font-size 11 200x40 [
;			value: attempt [to-rebol-file f-path/text]
;			if all [value exists? value] [path: value show-dir]
;		]
;		return
;		pad 2x3
;;		btn-enter 65 "Open" [if not empty? trim path [result: dirize path] hide-popup]
;		button 65 "Open" [if not empty? trim path [result: dirize path] hide-popup]
;		button 65 "Make Dir" [
;			inform center-face dout: layout [
;				across
;				origin 6
;				text 100x24 middle bold "Directory name:" f-idir: field return
;				pad 120
;				btn-enter 70 "Create" [
;					hide-popup
;					trim value: f-idir/text
;					if not empty? value [
;						either attempt [make-dir/deep rejoin [path slash value] true][
;							show-dir ;chg-dir value
;						][
;							alert "Cannot create directory."
;						]
;					]
;				]
;				btn-cancel 70 "Cancel" escape [hide-popup]
;			] "Make a new directory"
;			focus f-idir
;		]
;		btn-cancel 65 "Cancel" escape [hide-popup]
;		at f-name/offset + 180x2
;		arrow 20x16 black gold up with [color: none edge: none] [back-dir]
;	]
;
;	set 'request-dir func [
;		"Requests a directory using a popup list."
;		/title "Change heading on request." title-line
;		/dir "Set starting directory" where [file!]
;		/keep "Keep previous directory path"
;		/offset xy
;	][
;		if block? dirout [
;			dirout: layout dirout
;			max-dirs: to-integer f-list/size/y - 4 / f-txt/size/y
;			center-face dirout
;		]
;		set-face f-title any [title-line "Select a directory:"]
;		if not all [keep path] [
;			path: copy either where [clean-path where] [what-dir]
;		]
;		if all [not empty? path slash = last path][remove back tail path]
;		last-path: path
;		result: none
;		show-dir
;		either offset [inform/offset dirout xy][inform dirout]
;		result
;	]
;]

;request-dir

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