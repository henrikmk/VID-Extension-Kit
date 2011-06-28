REBOL [
	Title: "Balancer Test"
	Short: "Balancer Test"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2011 - HMK Design"
	Filename: %balancer.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 29-May-2011
	Date: 29-May-2011
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Test BALANCER.
	}
	History: []
	Keywords: []
]

do %../../build/include.r

clear ctx-vid-debug/debug

view make-window [
	h3 "BALANCER Test"
	bar
	panel [
		panel [
			across
			text-area 200x200 spring [right]
			balancer
			data-list 200x200
		] spring [bottom]
		balancer
		text-area 300x100 fill 1x0
	]
	bottom-panel [
		across
		button
		balancer
		toggle
	]
]