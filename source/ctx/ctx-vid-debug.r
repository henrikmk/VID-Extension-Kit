REBOL [
	Title: "VID Debugging Tools"
	Short: "VID Debugging Tools"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-debug.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 20-Apr-2009
	Date: 20-Apr-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Debugging tools to analyze faces in VID.
	}
	History: []
	Keywords: []
]

; [ ] - this falls out with iterated faces. it won't update an iterated face.

ctx-vid-debug: context [
	debug: []
	fc: none
	level: copy ""
	set 'in-level does [if find debug 'face [append level "-"]]
	set 'out-level does [if find debug 'face [remove level]]
	set 'debug-face func [doing data] [
		if find debug 'face [print trim/lines to-string reduce [doing ": +" level data]]
	]
	face-name: does [any [all [function? fc "iterated"] fc/var fc/style fc/type "unknown"]]
	face-text: does [mold any [all [function? fc "iterated"] fc/text ""]]
	set 'debug-align func [face] [
		unless find debug 'align [exit]
		fc: :face
		debug-face "Aligning" reduce [
			face-name
			face-text
			"align:" get in :fc 'align
			"fill:" get in :fc 'fill
			"spring:" mold get in :fc 'spring
			"size:" get in :fc 'size
			"offset:" get in :fc 'offset
		]
	]
	set 'debug-resize func [face diff] [
		unless find debug 'resize [exit]
		fc: :face
		debug-face "Resizing" reduce [face-name face-text "by" diff "offset:" get in :fc 'offset]
	]
	set 'debug-vid func [str] [
		unless find debug 'vid [exit]
		print "Debug: " str
	]
	set 'remind func [value] [if find debug 'remind [probe value]]
]

dump-face: func [
	"Print face info for entire pane. (for debugging)"
	face [object!]
	/parent p
	/local depth pane style
][
	depth: " "
	print [
		depth "Style:"
		either face/show? [all [in face 'style face/style]][rejoin [#"(" all [in face 'style face/style] #")"]]
		"WinOs:" all [in face 'win-offset face/win-offset]
		"Os:" face/offset
		"Sz:" face/size
		"Rsz:" all [in face 'real-size face/real-size]
		"Txt:" if face/text [copy/part form face/text 20]
		"Fill:" all [in face 'fill face/fill]
		"Align:" all [in face 'align mold face/align]
		"Spring:" all [in face 'spring mold face/spring]
		"P:"
		case [
			none? face/parent-face ["No"]
			any [all [not parent face/parent-face] face/parent-face = p] ["Yes"]
			face/parent-face ["(Yes)"]
		]
	]
	insert depth tab
	pane: get in face 'pane
	case [
		any-function? :pane [dump-face pane face 1]
		object? :pane [dump-face/parent :pane face]
		block? :pane [foreach f :pane [dump-face/parent f face]]
		none? :pane []
		true [print [depth "Unknown pane type: " type? :pane]]
	]
	remove depth
]