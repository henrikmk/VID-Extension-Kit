REBOL [
	Title: "Form Related Styles"
	Short: "Form Related Styles"
	Author: ["Henrik Mikael Kristensen"]
	Copyright: "2009, 2010 - HMK Design"
	Filename: %form.r
	Version: 0.0.1
	Type: 'script
	Maturity: 'unstable
	Release: 'internal
	Created: 09-May-2009
	Date: 09-May-2009
	License: {
		BSD (www.opensource.org/licenses/bsd-license.php)
		Use at your own risk.
	}
	Purpose: {
		Fields and other inputs that are friendly for forms.
	}
	History: []
	Keywords: []
]

stylize/master [

	; 6 images: not validated, valid, invalid, not required, required, attention
	VALID-INDICATOR: IMAGES 24x24 spring [left bottom] with [
		; [ ] - load as stock instead
		images: reduce [
			'not-validated	load-stock 'validation-not-validated
			'valid			load-stock 'validation-valid
			'invalid		load-stock 'validation-invalid
			'not-required	load-stock 'validation-not-required
			'required		load-stock 'validation-required
			'attention		load-stock 'validation-attention
		]
	]

	; validates the face before it and indicates its validation status in the face after it
	; [ ] - deprecated
	VALIDATE-OLD: FACE with [
		size: 0x0
		valid: none			; true = valid, false = not valid, none = not validated
		validation: none	; code to run to validate this field. result is stored in VALID.
		action: func [face value] [face/validate face value]
		multi: make multi [
			block: func [face blk] [
				if pick blk 1 [
					face/validation: func [face value] pick blk 1
					if pick blk 2 [face/validation: func [face value] pick blk 2]
				]
			]
		]
		validate: func [fc value /local enabler face indicator result init no-show] [
			set [init no-show] value										; multiple values as input for this function
			face: back-face fc												; previous face is face to validate
			enabler: back-face face											; previous face to face is enabler
			any [enabler/style = 'enabler enabler: none]					; enabler must be the correct style
			if all [enabler not get-face enabler] [return 'not-required]	; do not validate as false if enabler is false
			indicator: next-face fc											; next face is validation indicator

			; need to have initial conditions working properly. no-show must work here as well

			; not using this directly yet. this seems to be mostly useful from inside other faces.
			either flag-face? face panel [									; for attachment to an entire panel
				validate-face face											; validate the whole panel
			][
				; validate the single face
				if function? get in fc 'validation [
					fc/valid: fc/validation face get-face face
					if indicator/style = 'valid-indicator [
						result: switch/default fc/valid reduce [
							true		['valid]
							false		['invalid]
							none		['invalid]
						][
							; return a word here
							fc/valid
						]
						either no-show [
							set-face/no-show indicator result
						][
							set-face indicator result
						]
					]
				]
				case [
					logic? fc/valid [fc/valid]
					word? fc/valid [
						select reduce [
							'not-required	true
							'valid			true
							'required		false
							'invalid		false
						] fc/valid
					]
					true [to-logic fc/valid] ; may not be correct
				]
			]
		]
		required: func [value] [pick [required valid] empty? value]
		init: []
	]

	; enables or disables the next face in the layout
	ENABLER: CHECK 24x24 [
		use [nf] [
			nf: next-face face
			either get-face face [
				enable-face nf
				set-tab-face focus nf ; does not focus inside a panel
			][
				disable-face nf
				clear-face nf
			]
			validate-init-face nf
		]
	]

	; Style that contains whatever value is set in it. Invisible.
	EMBED: FACE with [
		font: none
		size: 0x0
		access: ctx-access/data
		init: []
	]

]