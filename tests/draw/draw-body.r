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
	b1: button "Button Test 1" [print "boo"]
	b2: button "Button Test 2"
	b3: button "Button Test 3"
   ;; allow propagation of a color from the face into this, so the color can vary freely
   selector-toggle
   selector ; does not select
   ;frame [
   ;	true-button
   ;	retry-button
   ;	ok-button
   ;	cancel-button
   ;]
   multi-selector-toggle
   m: multi-selector
   field
	rs: radio-selector [probe value]
;   check-selector
;	r1: radio-line "radio" [probe 'asd] ; cannot clear-face. cannot set-face.
;	check-line "asd" ; this causes para to shift
;	t1: toggle "Toggle Test 1" [probe get-face face]
;   t2: toggle "Toggle Test 2"
;   t3: toggle "Toggle Test 3"
;	button "Set Face" [clear-face r1] ; does not display change in toggle
;   ;check
;   text "Test"
;   ;arrow
	;a: arrow right
	;panel [
	;	across
	;	arrow north-west
	;	arrow north
	;	arrow north-east
	;	return
	;	arrow west
	;	pad 22
	;	arrow east
	;	return
	;	arrow south-west
	;	arrow south
	;	arrow south-east
	;]
	;slider
;	scroller ; crash on startup
]

view m