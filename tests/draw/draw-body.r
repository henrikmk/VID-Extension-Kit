REBOL [
	Title: "DRAW-BODY Test"
	Short: "DRAW-BODY Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2010, 2011 - HMK Design"
	Filename: %draw-body.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-Jun-2010
	Date: 26-Jun-2010
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test the DRAW-BODY context with a derivative BUTTON
	}
	History: []
	Keywords: []
]

; arrow-down problem here

do %../../build/include.r

;insert clear ctx-vid-debug/debug 'draw-body

m: make-window [
;	c: check
;	radio of 'a ; radio relation does not work
;	radio of 'a ; keyboard space/return does not work very well
;	b1: button "Button Test 1" [print "boo"]
;	b2: button "Button Test 2"
;	b3: button "Button Test 3"
   ;; allow propagation of a color from the face into this, so the color can vary freely
;   selector-toggle
s:  selector [probe value]
;button "Get Face" [
;	probe get-face s
;]
button "Disable" [disable-face t]
button "Enable" [enable-face t]
;button "Set Face" [
;	set-face s probe random/only [choice1 choice2 choice3]
;	probe get-face s
;]
;frame [ ; need to show the correct colors
;	true-button
;	retry-button
;	ok-button
;	cancel-button
;]
	y: multi-selector []
;	button "Get Face" [
;		probe get-face y
;	]
;	button "Set Face" [
;		set-face y probe remove-each a copy [choice1 choice2 choice3] [random true]
;		probe get-face y
;	]
;f1:	field
;f2:	field
;i1: info "test"
;i2: info "est2"
;field
;a: text-area ; scroller not working, but this is a general problem
;ct: code-text-area
tab-selector [probe value]
;t: tab-button spring none
t: tab-panel setup [
	a "A" [origin 4 field]
	b "B" [origin 4 button button]
	c "C" []
]
;code-text-area
;c: choice ; crashes on open
	rs: radio-selector [probe value]
;;   check-selector
;;	r1: radio-line "radio" [probe 'asd] ; cannot clear-face. cannot set-face.
;;	button "Set Face" [clear-face r1] ; does not display change in toggle
;;	check-line "asd"
;;	t1: toggle "Toggle Test 1" [probe get-face face]
;;   t2: toggle "Toggle Test 2"
;;   t3: toggle "Toggle Test 3"
;;   ;check
;;   text "Test"
;ar:   arrow
;data-list
;	;a: arrow right
;	;panel [
;	;	across
;	;	arrow north-west
;	;	arrow north
;	;	arrow north-east
;	;	return
;	;	arrow west
;	;	pad 22
;	;	arrow east
;	;	return
;	;	arrow south-west
;	;	arrow south
;	;	arrow south-east
;	;]
;;	dragger
;;sl:	slider
;sc:	scroller [probe value]
;hsc: scroller 200x20
]

view m