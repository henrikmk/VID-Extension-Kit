REBOL [
	Title: "Sensor specific styles for VID"
	Short: "Sensor specific styles for VID"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %vid-sensor.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 26-Jul-2009
	Date: 26-Jul-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Keyboard and mouse global sensor styles for VID
	}
	History: []
	Keywords: []
]

stylize/master [
	SENSOR: BLANK-FACE with [
		feel: svvf/sensor ; be careful that this does not reintroduce the keyboard sense bug again
		doc: [
			info: "Transparent sensor area"
			pair: "Size of sensor"
		]
		init: [if none? size [size: 100x100]]
	]

	KEY: SENSOR 0x0 doc [info: "Keyboard action" pair: none]
]