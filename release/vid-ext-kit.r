REBOL [
    Title: "VID Extension Kit" 
    Version: 0.0.6 
    Date: 13-Nov-2010/15:36:48+1:00 
    Author: ["Henrik Mikael Kristensen"] 
    Copyright: "2009, 2010 - HMK Design" 
    License: {
^-^-BSD (www.opensource.org/licenses/bsd-license.php)
^-^-Use at your own risk.
^-} 
    Purpose: {
^-^-VID Extension Kit adds new methods and styles to VID for REBOL 2.
^-}
]
---: func [s] [] set 'arrow-down.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAe0lEQVQ4Ee1QQQ7A
IAhz2cf42XjafNlGE5IZBeSw7DKbEA2lpVrKwn9/4JCnX5PCzIBt6DwNGEYwtXuk
EI4cnqVfLc7c0gx6KV3dLCG8qVmAK0uZ6UC6m0Aq+pShJpMQvqTmLKebTmdSB1L2
SU1hNiHEp9Qr6WC28OEP3ItvFAjuOlTvAAAAAElFTkSuQmCC
} set 'arrow-left.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAASUlEQVQ4EWNgGAXD
JgTqqeUTkEH/oZgiM5ENoshAbAaRZSA+g/AayERRQJChGZ9LyTAOoQWbwQhZCljI
BlNgDKZWkMGjYKiEAACQmiRajiKaMAAAAABJRU5ErkJggg==
} set 'arrow-pop.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAiklEQVQ4Ec3QAQ6A
IAgFUGrdu6NXLJmBfKDNrdxKQXxDiYj265s21mlSgz4Fj8ptqh0KJjO0K6BFbKzw
DESHUZ4iEB5qLbn7m+pXB4sOa1HUYU0wVf8Hozd0H93ccHjn6MpDcYbxfgTyPkJR
PgU9FGJcnHXINTwEkfnOOv8q+EQdpqfegP1UsJoOnozwCqsthHqPAAAAAElFTkSu
QmCC
} set 'arrow-right.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAU0lEQVQ4Ee3QywoA
IAhEUenH+/Qei7sZxEUJERjEIMJBxqzeVw307GvHAvdPgwHJaxhI8xhWSGcXbtnF
R55exOxeFkHsAMhjSMFrCDANAqx81MAEzW0kWprqwgUAAAAASUVORK5CYII=
} set 'arrow-up.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAYElEQVQ4Ee2QwQ4A
EAxDx4/7dOYwQbRzcCGWLIS2e5nIr2s3kJS89rHKmlTbregqRjKXMmwEzmTU4xGu
iFZvjYtOU9VMZ0boY4SMBP7BSYSOUiJCSGBpeu5oOvm/vrOBAjwmCgA8sTKWAAAA
AElFTkSuQmCC
} set 'blocked.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAATUlEQVQoFY3PMQ4A
IAhDUfH+d0Y6kJCmIAwO+J+JdvpxdWVqGTsZx94UaGM8zmCMGXzjClZxgnUMcHGI
4b9l4gq0MRSDMWbwjStYxQAPyJQMEQGHQacAAAAASUVORK5CYII=
} set 'check-off-down.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAdklEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEhMRFsElRZI41XyA
y9ZRC3CFDFx8NIjgQYGLMRpEuEIGLk7zIMJaFuEquODOIoGBUrSC9H3//J3s4hqk
H724BomNgoENAQDXJQucNhMGBQAAAABJRU5ErkJggg==
} set 'check-off-over.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAdklEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEgsJDsElRZI41XyA
y9ZRC3CFDFx8NIjgQYGLMRpEuEIGLk7zIMJaFuEquODOIoGBUrSC9H3//J3s4hqk
H724BomNgoENAQDhcAxcmkCxRAAAAABJRU5ErkJggg==
} set 'check-off-up.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAdklEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEgsJDsElRZI41XyA
y9ZRC3CFDFx8NIjgQYGLMRpEuEIGLk7zIMJaFuEquODOIoGBUrSC9H3//J3s4hqk
H724BomNgoENAQDhcAxcmkCxRAAAAABJRU5ErkJggg==
} set 'check-on-down.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAuUlEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEhMRFsElRZI41XyA
y1ayLTj5axsDCBMCZFtAyGCYPFkWwFxuzuYFMwcnTZYFOE3DIkGyBaS4HmQfQQuI
jUwsjgcLEbQAFs7IFsHEcBmKLE7QApBiUgxENhzExpmT0RWSawlRPkC3jBQ+Vh/g
KrhIMRimFqVoBQl+//yd7OIapB+9uAaJjYKBDQEA3VIikPQxHKoAAAAASUVORK5C
YII=
} set 'check-on-over.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAuUlEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEgsJDsElRZI41XyA
y1ayLejcVcYAwoQA2RYQMhgmT5YFMJeXu3XBzMFJk2UBTtOwSJBsASmuB9lH0AJi
IxOL48FCBC2AhTOyRTAxXIYiixO0AKSYFAORDQexceZkdIXkWkKUD9AtI4WP1Qe4
Ci5SDIapRSlaQYLfP38nu7gG6UcvrkFio2BgQwAAq0ch0Op9qFEAAAAASUVORK5C
YII=
} set 'check-on-up.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAuUlEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEgsJDsElRZI41XyA
y1ayLejcVcYAwoQA2RYQMhgmT5YFMJeXu3XBzMFJk2UBTtOwSJBsASmuB9lH0AJi
IxOL48FCBC2AhTOyRTAxXIYiixO0AKSYFAORDQexceZkdIXkWkKUD9AtI4WP1Qe4
Ci5SDIapRSlaQYLfP38nu7gG6UcvrkFio2BgQwAAq0ch0Op9qFEAAAAASUVORK5C
YII=
} set 'corner.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAAAQAAAAECAYAAACp8Z5+AAAAG0lEQVQIHWP8DwQM
UMAIBEzIHDAbWQVMEoUGAITxCAR1UjwNAAAAAElFTkSuQmCC
} set 'radio-off-down.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA00lEQVRIDe1UsQ6D
QAjVxsWhU/1LOzr4BzrcWP/STg6OGowYfQeUpoNJ4y0I93gPyGGSXOfsCaSeAspn
OUm47tV9zDcBGjGKWUKqAJIXj+LA27/7xQ9NWGx+z0Wu7JC1OntyJGY8xsdhnCSR
GydIFkkkTBtaKbzFIoF99RvK+UFdIDQSYICnesZaXagCnPyr/WMBfueeEdVVrcKi
EVlbqbKsF1/vgacLq3rSFdebLmgf+DdAPj5FJJaqpzxVgC6lxaE4Ho2ccKYAE2lC
FjHnXvb8Ccw8KjjUv4OCCQAAAABJRU5ErkJggg==
} set 'radio-off-over.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA2ElEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGx4SHIJi7pq1a8D8nvYeMM3J
y4nVLKyCyIajG4xiC5BjYWIBF8JmCRNcFguDkOEgLSfOnMCiEyGEYQGy6xHKiGN9
//wdIzFgWAAzihjXw9Ti8wVOC2CaKaWHsQWwdE5MECEnVXT1GEGEL1eia0bnk5wP
iPEFPteDHIA1J4MkQPkBVgyA+OhJEd1gbK4H6cNpAUgSW8YBiaMDXIaD1OG1AGYQ
LovwGQzTO0oPfAgAAH/ONhrtcRpHAAAAAElFTkSuQmCC
} set 'radio-off-up.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA2ElEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGx4SHIJi7pq1a8D8nvYeMM3J
y4nVLKyCyIajG4xiC5BjYWIBF8JmCRNcFguDkOEgLSfOnMCiEyGEYQGy6xHKiGN9
//wdIzFgWAAzihjXw9Ti8wVOC2CaKaWHsQWwdE5MECEnVXT1GEGEL1eia0bnk5wP
iPEFPteDHIA1J4MkQPkBVgyA+OhJEd1gbK4H6cNpAUgSW8YBiaMDXIaD1OG1AGYQ
LovwGQzTO0oPfAgAAH/ONhrtcRpHAAAAAElFTkSuQmCC
} set 'radio-on-down.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA8ElEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGy4iLIJi7pu3b8D8nvYeMM3J
y4nVLBYUXVAOsuHoBsPUo4t///z9PzZLmGAasNHohmBT09HTgU0YLobhA2TXw1UB
GSd/bUPmMpizeaHwQRxsvsDpA2TXoxsOMgxZDJ8vcFoAMoQaYBhbAEvnoGDCFqHI
YhUlFThDE2vmgKUk5IjGaQJQAmYByfkA2Re4LIAZjkseqw9AikG+gBUDID56UkQ3
GJvrQfpwWgCSBGUcEE0I4DIcpA+vBTCDcVmEz2CY3lF64EMAAFpTRBaYeG/RAAAA
AElFTkSuQmCC
} set 'radio-on-over.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA90lEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGx4SHIJi7pq1a8D8nvYeMM3J
y4nVLKyCyIajG4xiC5BjYWIBF8JmCRNcFguDkOEgLSfOnMCiEyHEgmBCWMiuR5br
3FWGzGUod+tC4YM43z9//4/uC5w+QHY9uuEgw5DF8PkCpwUgQ6gBhrEFsHQOCiZs
EYoshpxU0YMVbz5Ajmh0jch8mAXoKQikBm8cIPsC2UBkNsxwZDFkNlYfgBSA8gOs
GADx0ZMiusHYXA/Sh9MCkCQo44BoQgCX4SB9eC2AGYzLInwGw/SO0gMfAgBp2UFc
z5JNMAAAAABJRU5ErkJggg==
} set 'radio-on-up.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA90lEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGx4SHIJi7pq1a8D8nvYeMM3J
y4nVLKyCyIajG4xiC5BjYWIBF8JmCRNcFguDkOEgLSfOnMCiEyHEgmBCWMiuR5br
3FWGzGUod+tC4YM43z9//4/uC5w+QHY9uuEgw5DF8PkCpwUgQ6gBhrEFsHQOCiZs
EYoshpxU0YMVbz5Ajmh0jch8mAXoKQikBm8cIPsC2UBkNsxwZDFkNlYfgBSA8gOs
GADx0ZMiusHYXA/Sh9MCkCQo44BoQgCX4SB9eC2AGYzLInwGw/SO0gMfAgBp2UFc
z5JNMAAAAABJRU5ErkJggg==
} set 'read-off.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAIUlEQVRIDe3QAQ0A
AADCoPdP7ewBESgMGDBgwIABAwY+MAkYAAGvX7w8AAAAAElFTkSuQmCC
} set 'read-on.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAgElEQVRIDe1USQ7A
IAikTf//5TbcBmSLqZGDHowos5ko0Rm7b+D6ycALPILzhoMlS6E2qeC6Z772CUL3
7ROk7lsnKLnnBA9PapTBCmeW3juIRKKzQcR7ByiMhANBtoFEVi+Sc6+uLYzYywS4
GUkRXMFSqckQqeLW/0UY+az33MAHloUNGtzbryUAAAAASUVORK5CYII=
} set 'striped.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAASUlEQVQYGcWPMQ4A
IAgDrf//M1qSIy7oKIPQ5kBQRAxC0pYhtDPexMRAn5DrBF9QNu2n/c4A4aWoM3fT
a0dTHeQDC7xBHvLxmAXg5FMFzw9t0wAAAABJRU5ErkJggg==
} set 'tab-down.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAIAAABvFaqvAAAAm0lEQVQ4EWPcsW0n
AyrYvG0TqgAWnq+XH5ooExqfGFP0dPXYOdnQNLIg8+GmTJ0yFVkcjb1//36gCNCs
n99/waUQLiLSFKBOR0dHiH5kd0ENIt4UiBGYZoEMItUUrGYxZudkQyTwhwtEDSYJ
DC9JSUl5aXloYJNnCtBcoB+/f/4OZCACG9M2kkRGDSIcXKNhNBpGhEOAsIphnI4A
eyoqg69mEksAAAAASUVORK5CYII=
} set 'tab-on.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAIAAABvFaqvAAAAoklEQVQ4EWPcsW0n
Ayqwt7VDFcDCO3j4EJooExqfGFMePn3IzsmGppEFmQ83hZOXE1kcjb1//36gCNCs
n99/waUQLiLSFKBOR0dHiH5kd0ENIt4UiBGYZoEMItUUrGYxfv/8HSKBP1wgajBJ
SHjdunUL6jXyTAGaC/Qj0JRLly8hAhvTNiJFgKYAVVLBIIh9owYRDvfRMBoNI8Ih
QFjF4EtHACtxJCSUm4qAAAAAAElFTkSuQmCC
} set 'tab.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAIAAABvFaqvAAAAqklEQVQ4EWPcsW0n
AzUAEzUMAZnBgmmQva0dpiCayMHDh9BE0F1EjCkPnz5k52RDMwjFRXBTFi1bhKYO
maumpgbkAs36+f0XXBzhIiJNAeq8desWRD+yu6AGEW8KxAhMs0AGkWoKVrMYv3/+
DpHAHy4QNZgkJLyADoQaRJ4pcHMvXb6ECGy4KKkMoClALVQwCGLxqEGEI2A0jIZi
GDE+ePiQsLuJUEG16AcARvMy42wzfesAAAAASUVORK5CYII=
} set 'validation-attention.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAdUlEQVRIDe2RQQ5A
EQxE65/K/Vdu5WdiIZFRMsSqXYig7zHMoiKBZwkUs6rIvp0mFQ72UnACXwpO4RAk
DKwUeCY8GpECZ5fEGhXMDivrVMCeqsDRM/0DbI5RKWL6AsBRCrB19tEV3JJ0nTMb
43KOxlYkcDmBH83oD2ipZrtxAAAAAElFTkSuQmCC
} set 'validation-invalid.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAmElEQVRIDe1QSQqA
MAyMvsr/n/yVMuDA0Ga7iKDm0JZklmbM/vp2ArvZUSVQYZZIQImbmYvrYEoiPzCa
qHiEQd81wCATyGbgaoUGAHlCSuZ73I593KkBAJVJJt4yyEwqcXBXHHfWsxFV+XPz
LKpwA0+cQtmMprxdg45ABwMT1wADFeDP0dfqYBQ/vVVgGl6NDibi/v2XJHACfMwp
KmRPo2gAAAAASUVORK5CYII=
} set 'validation-not-required.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAU0lEQVRIDWNgGAWj
ITAaAowkBMF/NLWk6EXTislFNxykApsYpk4iRPAZhE8ObDQTERZQpGToW0Cs97GF
NTYxDPNISWroBpKiF8PiUYHREBhJIQAAloIIA53MRq4AAAAASUVORK5CYII=
} set 'validation-not-validated.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAIUlEQVRIDe3QAQ0A
AADCoPdP7ewBESgMGDBgwIABAwY+MAkYAAGvX7w8AAAAAElFTkSuQmCC
} set 'validation-required.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAATUlEQVRIDWNgGAWj
ITAaAowkBMF/NLVE6SVKEdBgdMNhdhHUT1ABHsOJsoQJpopW9NC3gJg4AIUeTSMZ
Fj3olhDrOJj+UXo0BEZsCAAAsYkFDM9z81MAAAAASUVORK5CYII=
} set 'validation-valid.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAi0lEQVRIDe1TSQqA
MAyM4pN9hn9W5tAyCTGpolikOWjbOFslIqO+voHpEQOb7JVnFcU518ZLC6V2SyNw
D77OEyTuO0/Q4L7jBI3ukWDBQ9UFsMKdbPw5iESiniPizwGPOxM6BNmRn6CgmByi
dl++C96xAIBMykScks/NOhcAwIo0kgPq/wN0Rv3mBg6Fnxoa60sNyQAAAABJRU5E
rkJggg==
} set 'validation-warn.png load 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAwUlEQVRIDe1TQQ6D
MAxjiOtew/+fsNdwB9JIRqlIGhfGaauEmhLHdlJ1GP7ryxPYhK989HrRyDMxVTt2
CFyCUi6EWceyLrOKjO8PxNL6xzuAk9auFyvuccGbjVuFJfd4B5lANXvrFvch/xRj
czbOBCz2UtwSCN1DiemiJQCeW3skkLqHatbFBCCzGzIGrhjvJYbu8YI9IeSEteKM
RkQ7zICVmoBD9xlRyXtduAIMWYI5eI/AFGgX5twbepy9HL+E3wHHWDVRhz+rmgAA
AABJRU5ErkJggg==
} 
--- "REBOL/View: Visual Interface Dialect" 
find-key-face: func [
    "Search faces to determine if keycode applies." 
    face [object!] keycode [char! word!] /local w f result
] [
    either all [
        w: in face 'keycode 
        w: get w 
        any [keycode = w all [block? w find w keycode]]
    ] [face] [
        w: in face 'pane 
        either block? w: get w [
            result: none 
            foreach f w [if all [object? f f: find-key-face f keycode] [result: f break]] 
            result
        ] [
            if object? :w [find-key-face w keycode]
        ]
    ]
] 
do-face: func [face value] [
    do get in face 'action face either value [value] [get-face face]
] 
do-face-alt: func [face value] [
    do get in face 'alt-action face either value [value] [get-face face]
] 
remove system/view/screen-face/feel/event-funcs 
svv: system/view/vid: context [
    verbose: off 
    warn: off 
    word-limits: none 
    image-stock: 
    vid-feel: 
    icon-image: 
    radio.bmp: 
    radio-on.bmp: none 
    vid-colors: context [
        focus-ring-color: 20.120.230 
        body-text-color: black 
        body-text-disabled-color: gray 
        select-body-text-color: white 
        title-text-color: black 
        field-color: snow - 5 
        field-select-color: yello 
        window-background-color: 180.180.180 
        menu-color: window-background-color + 20 
        frame-background-color: window-background-color - 20 
        line-color: window-background-color - 100 
        menu-text-color: [0.0.0 0.75.150 255.255.255] 
        important-color: 150.0.0 
        manipulator-color: 200.200.200 
        glyph-color: black 
        action-color: 200.200.200 
        true-color: 80.180.80 
        false-color: 180.180.180 
        action-colors: reduce [action-color action-color] 
        disabled-action-colors: reduce [action-color - 50 action-color - 50] 
        select-color: focus-ring-color 
        select-disabled-color: 120.120.120 
        font-color: reduce [black focus-ring-color - 75] 
        important-font-color: reduce [white important-color + 100] 
        tool-tip-background-color: white 
        tool-tip-edge-color: black 
        grid-color: 140.140.140 
        today-color: select-color 
        day-color: snow 
        day-font-color: black 
        weekend-color: yello 
        out-of-month-color: 180.180.180 
        weekday-color: black 
        weekday-font-color: snow 
        appointment-color: orange
    ] 
    text-body: context [
        size: 0x0 
        line-height: 0 
        area: 0x0 
        paras: 0 
        para: 0 
        para-start: 0 
        para-end: 0 
        line: 0 
        line-start: 0 
        line-end: 0 
        lines: 0 
        v-ratio: 0.0 
        h-ratio: 0.0 
        v-scroll: 0.0 
        h-scroll: 0.0 
        caret: none 
        highlight-start: none 
        highlight-end: none
    ] 
    set 'svvc vid-colors 
    vid-face: make face [
        state: false 
        setup: 
        access: 
        style: 
        action: 
        alt-action: 
        facets: 
        related: 
        words: 
        colors: 
        texts: 
        images: 
        file: 
        var: 
        keycode: 
        reset: 
        styles: 
        init: 
        multi: 
        blinker: 
        min-size: 
        max-size: 
        real-size: 
        pane-size: 
        dirty?: 
        help: 
        user-data: none 
        size: none 
        text-body: none 
        flags: [] 
        edge: make edge [size: 0x0] 
        font: make font [style: none color: white align: 'left valign: 'top shadow: 1x1 colors: vid-colors/font-color] 
        doc: none 
        options: 
        saved-feel: 
        saved-font: 
        saved-para: 
        saved-flags: 
        old-value: none 
        default: none 
        origin: 0x0 
        win-offset: 0x0 
        tags: none 
        fill: 0x0 
        spring: [right bottom] 
        align: none 
        fixed-aspect: false 
        aspect-ratio: 0.0 
        level: 0 
        pos: none 
        valid: none 
        actors: none 
        tab-face?: none 
        tab-face: none 
        focal-face: none 
        tool-tip: none
    ] 
    state-flags: [font para edge] 
    vid-face/doc: make object! [
        info: "base face style" 
        string: 
        image: 
        logic: 
        integer: 
        pair: 
        tuple: 
        file: 
        url: 
        decimal: 
        time: 
        block: 
        keywords: 
        none
    ] 
    vid-face/actors: make object! [
        on-setup: 
        on-key: 
        on-tab: 
        on-return: 
        on-click: 
        on-alt-click: 
        on-set: 
        on-clear: 
        on-reset: 
        on-escape: 
        on-focus: 
        on-unfocus: 
        on-scroll: 
        on-resize: 
        on-align: 
        on-time: 
        on-search: 
        on-validate: 
        on-init-validate: 
        on-change: 
        on-enable: 
        on-disable: 
        on-freeze: 
        on-thaw: 
        none
    ] 
    set 'set-font func [aface 'word val] [
        if none? aface/font [aface/font: vid-face/font] 
        unless flag-face? aface font [aface/font: make aface/font [] flag-face aface font] 
        either word = 'style [
            either none? val [aface/font/style: none] [
                if none? aface/font/style [aface/font/style: copy []] 
                if word? aface/font/style [aface/font/style: reduce [aface/font/style]] 
                aface/font/style: union aface/font/style reduce [val]
            ]
        ] [set in aface/font word val]
    ] 
    set 'set-para func [aface 'word val] [
        if none? aface/para [aface/para: vid-face/para] 
        unless flag-face? aface para [aface/para: make aface/para [] flag-face aface para] 
        set in aface/para word val
    ] 
    set 'set-edge func [aface 'word val] [
        if none? aface/edge [aface/edge: vid-face/edge] 
        unless flag-face? aface edge [aface/edge: make aface/edge [] flag-face aface edge] 
        set in aface/edge word val
    ] 
    set 'set-valid func [aface 'word val] [
        if none? aface/valid [aface/valid: make object! [action: result: none required: false]] 
        if word = 'action [aface/valid/action: func [face] val exit] 
        set in aface/valid word val
    ] 
    set 'set-tool-tip-face func [aface 'word val] [
        if none? aface/tool-tip [aface/tool-tip: val]
    ] 
    vid-face/multi: context [
        text: func [face blk] [
            if pick blk 1 [
                face/text: first blk 
                face/texts: copy blk
            ]
        ] 
        size: func [face blk] [
            if pick blk 1 [
                if pair? first blk [face/real-size: none face/size: first blk] 
                if integer? first blk [
                    if none? face/size [face/real-size: none face/size: -1x-1] 
                    face/size/x: first blk
                ]
            ]
        ] 
        file: func [face blk] [
            if pick blk 1 [
                face/image: load-image face/file: first blk 
                if pick blk 2 [
                    face/colors: reduce [face/image] 
                    foreach i next blk [
                        append face/colors load-image i
                    ]
                ]
            ]
        ] 
        image: func [face blk] [
            if pick blk 1 [
                face/image: first blk 
                if pick blk 2 [face/images: copy blk]
            ]
        ] 
        color: func [face blk] [
            if pick blk 1 [
                either flag-face? face text [
                    set-font face color first blk 
                    if pick blk 2 [face/color: second blk]
                ] [
                    face/color: first blk
                ] 
                if pick blk 2 [face/colors: copy blk]
            ]
        ] 
        block: func [face blk] [
            if pick blk 1 [
                face/action: func [face value] pick blk 1 
                if pick blk 2 [face/alt-action: func [face value] pick blk 2]
            ]
        ]
    ] 
    set 'BLANK-FACE make vid-face [
        edge: font: para: feel: image: color: text: effect: none 
        doc: make doc [info: "empty style (transparent, minimized)"]
    ] 
    vid-words: [] 
    vid-styles: reduce ['face vid-face 'blank-face blank-face] 
    track: func [blk] [if verbose [print blk]] 
    error: func [msg spot] [print [msg either series? :spot [mold copy/part :spot 6] [:spot]]] 
    warning: func [blk] [print blk] 
    facet-words: [
        edge font para doc feel 
        align fill spring setup default 
        effect effects keycode rate colors texts help user-data 
        with [args: next args] 
        bold italic underline [set-font new style first args args] 
        left center right [set-font new align first args args] 
        top middle bottom [set-font new valign first args args] 
        plain [set-font new style none args] 
        of [new/related: second args next args] 
        font-size [set-font new size second args next args] 
        font-name [set-font new name second args next args] 
        font-color [set-font new color second args next args] 
        wrap [set-para new wrap? on args] 
        no-wrap [set-para new wrap? off args] 
        required [set-valid new required true args] 
        validate [set-valid new action second args next args] 
        tool-tip [set-tool-tip-face new action second args next args] 
        disabled [disable-face new args] 
        as-is [flag-face new as-is args] 
        shadow [set-font new shadow second args next args] 
        frame [set-edge new none args] 
        bevel [set-edge new 'bevel args] 
        ibevel [set-edge new 'ibevel args] 
        on-setup [set-actor new 'on-setup second args next args] 
        on-key [set-actor new 'on-key second args next args] 
        on-tab [set-actor new 'on-tab second args next args] 
        on-return [set-actor new 'on-return second args next args] 
        on-click [set-actor new 'on-click second args next args] 
        on-alt-click [set-actor new 'on-alt-click second args next args] 
        on-set [set-actor new 'on-set second args next args] 
        on-clear [set-actor new 'on-clear second args next args] 
        on-reset [set-actor new 'on-reset second args next args] 
        on-escape [set-actor new 'on-escape second args next args] 
        on-focus [set-actor new 'on-focus second args next args] 
        on-unfocus [set-actor new 'on-unfocus second args next args] 
        on-scroll [set-actor new 'on-scroll second args next args] 
        on-resize [set-actor new 'on-resize second args next args] 
        on-align [set-actor new 'on-align second args next args] 
        on-time [set-actor new 'on-time second args next args] 
        on-search [set-actor new 'on-search second args next args] 
        on-validate [set-actor new 'on-validate second args next args] 
        on-init-validate [set-actor new 'on-init-validate second args next args] 
        on-change [set-actor new 'on-change second args next args] 
        on-enable [set-actor new 'on-enable second args next args] 
        on-disable [set-actor new 'on-disable second args next args] 
        on-freeze [set-actor new 'on-freeze second args next args] 
        on-thaw [set-actor new 'on-thaw second args next args]
    ] 
    fw-with: find facet-words 'with 
    fw-feel: find facet-words 'feel 
    spot: facet-words 
    while [spot: find spot block!] [change spot func [new args] first spot] 
    set 'get-style func [
        "Get the style by its name." 
        name [word!] 
        /styles ss "Stylesheet"
    ] [
        if none? styles [ss: vid-styles] 
        select ss name
    ] 
    set 'set-style func [
        "Set a style by its name." 
        name [word!] 
        new-face [object!] 
        /styles ss "Stylesheet" 
        /local here
    ] [
        if none? styles [ss: vid-styles] 
        either here: find ss name [change next here new-face] [repend ss [name new-face]]
    ] 
    set 'make-face func [
        {Make a face from a given style name or example face.} 
        style [word! object!] "A name or a face" 
        /styles ss "Stylesheet" 
        /clone "Copy all primary facets" 
        /size wh [pair!] "Size of face" 
        /spec blk [block!] "Spec block" 
        /offset xy [pair!] "Offset of face" 
        /keep "Keep style related data"
    ] [
        if word? style [style: either styles [select ss style] [get-style style]] 
        if none? style [return none] 
        spec: [parent-face: saved-area: line-list: old-offset: old-size: none] 
        if blk [spec: append copy spec blk] 
        style: make style spec 
        if size [style/size: wh] 
        if offset [style/offset: xy] 
        style/flags: exclude style/flags state-flags 
        if clone [
            foreach word [text effect colors texts font para edge] [
                if style/:word [
                    set in style word either series? style/:word [copy style/:word] [
                        make style/:word []
                    ]
                ]
            ]
        ] 
        do bind style/init in style 'init 
        unless keep [
            style/init: copy [] 
            style/facets: none
        ] 
        style
    ] 
    expand-specs: func [face specs /local here] [
        specs: copy specs 
        foreach var [edge: font: para: doc:] [
            if here: find/tail specs :var [
                if here/1 <> 'none [
                    insert here reduce either get in face to-word :var [
                        ['make to-word :var]
                    ] [
                        ['make to-path reduce ['vid-face to-word :var]]
                    ]
                ]
            ]
        ] 
        specs
    ] 
    grow-facets: func [new args /local pairs texts images colors files blocks val tmp] [
        new/facets: args 
        pairs: clear [] 
        texts: clear [] 
        colors: clear [] 
        files: clear [] 
        blocks: clear [] 
        images: clear [] 
        forall args [
            val: first args 
            switch/default type?/word val [
                pair! [append pairs val] 
                integer! [append pairs val] 
                string! [append texts val] 
                tuple! [append colors val] 
                block! [append/only blocks val] 
                file! [append files val] 
                url! [append files val] 
                image! [append images val] 
                char! [new/keycode: val] 
                logic! [new/data: new/state: val] 
                decimal! [new/data val] 
                time! [new/rate: val] 
                word! [
                    any [
                        if all [new/words tmp: find new/words :val] [
                            until [function? first tmp: next tmp] 
                            args: do first tmp new args
                        ] 
                        if tmp: find facet-words :val [
                            either 0 >= offset? tmp fw-with [
                                until [function? first tmp: next tmp] 
                                args: do first tmp new args
                            ] [
                                either tail? args: next args [error "Missing argument for" :val] [
                                    set in new val either positive? offset? fw-feel tmp [
                                        first args
                                    ] [
                                        if first args [make any [get in new val vid-face/:val] bind/copy first args new]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ] [
                error "Unrecognized parameter:" val
            ]
        ] 
        new/multi/text new texts 
        new/multi/size new pairs 
        new/multi/file new files 
        new/multi/image new images 
        new/multi/color new colors 
        new/multi/block new blocks
    ] 
    set 'stylize func [
        "Return a style sheet block." 
        specs [block!] "A block of: new-style: old-style facets" 
        /master "Add to or change master style sheet" 
        /styles styls [block!] "Base on existing style sheet" 
        /local new old new-face old-face args tmp
    ] [
        styles: either master [vid-styles] [copy either styles [styls] [[]]] 
        while [specs: find specs set-word!] [
            set [new old] specs 
            specs: skip specs 2 
            new: to-word :new 
            unless word? :old [error "Invalid style for:" new] 
            unless any [
                old-face: select styles old 
                old-face: select vid-styles old
            ] [error "No such style:" old] 
            unless tmp: find specs set-word! [tmp: tail specs] 
            args: copy/part specs tmp 
            forall args [
                if any [
                    find/only facet-words first args 
                    all [old-face/words find old-face/words first args]
                ] [
                    change args to-lit-word first args
                ]
            ] 
            args: reduce head args 
            new-face: make old-face either tmp: select args 'with [expand-specs old-face tmp] [[]] 
            new-face/facets: args 
            new-face/style: old 
            new-face/flags: exclude new-face/flags state-flags 
            grow-facets new-face args 
            either old: find styles new [change next old new-face] [repend styles [new new-face]] 
            if tmp: new-face/words [
                while [tmp: find tmp block!] [
                    change tmp func [new args] first tmp
                ]
            ]
        ] 
        styles
    ] 
    do-facets: func [
        {Build block of parameters (and attribute words) while not a vid word or style.} 
        specs words styles /local facets item
    ] [
        facets: copy [] 
        while [not tail? specs] [
            item: first specs 
            if set-word? :item [break] 
            either word? :item [
                if any [find vid-words item find styles item] [break] 
                facets: insert facets either any [
                    all [words find words item] 
                    all [find facet-words item]
                ] [to-lit-word item] [item]
            ] [
                facets: insert/only facets :item
            ] 
            specs: next specs
        ] 
        reduce [specs reduce head facets]
    ] 
    next-tab: func [tabs way where] [
        if pair? tabs [
            tabs: max 1x1 tabs 
            return where / tabs * tabs + tabs * way + (where * reverse way)
        ] 
        if block? tabs [
            foreach t tabs [
                if integer? t [t: t * 1x1] 
                if all [pair? t (way * t) = (way * max t where)] [
                    return way * t + (where * reverse way)
                ]
            ]
        ] 
        100 * way + where
    ] 
    vid-origin: 8x8 
    vid-space: 4 
    set 'layout func [
        {Return a face with a pane built from style description dialect.} 
        specs [block!] "Dialect block of styles, attributes, and layouts" 
        /size pane-size [pair!] "Size (width and height) of pane face" 
        /offset where [pair!] "Offset of pane face" 
        /parent new [object! word! block!] "Face style for pane" 
        /origin pos [pair!] "Set layout origin" 
        /styles list [block!] "Block of styles to use" 
        /keep "Keep style related data" 
        /tight "Zero offset and origin" 
        /local pane way space tabs var value args new-face pos-rule val facets start vid-rules max-off guide 
        def-style rtn word
    ] [
        if tight [
            unless offset [offset: true where: 0x0] 
            unless origin [origin: true pos: 0x0]
        ] 
        new-face: make any [
            all [parent object? new new] 
            all [parent word? new get-style new] 
            vid-face
        ] any [all [parent block? new new] [parent: 'panel]] 
        unless parent [
            new-face/offset: any [
                all [offset where] 
                50x50
            ]
        ] 
        new-face/size: pane-size: any [
            all [size pane-size] 
            new-face/size 
            system/view/screen-face/size - (2 * new-face/offset)
        ] 
        new-face/pane: pane: copy [] 
        max-off: origin: where: either origin [pos] [vid-origin] 
        space: vid-space way: 0x1 pos: guide: none tabs: 100x100 
        def-style: none 
        new-face/styles: styles: either styles [list] [copy vid-styles] 
        parse specs [some [thru 'style val: 
                [set word word! (unless find styles word [insert styles reduce [word none]]) 
                    | none (error "Expected a style name" val)
                ]
            ]] 
        parse specs [some [thru 'styles val: [
                    set word word! (
                        if all [value? word value: get word block? value] [
                            insert styles value
                        ]
                    ) | none (error "Expected a style name" val)
                ]
            ]] 
        rtn: [where: (max-off * reverse way) + (way * any [guide origin])] 
        vid-rules: [
            'return (do rtn) 
            | 'at [set pos pair! (where: pos) | none] 
            | 'space pos-rule (space: 1x1 * pos) 
            | 'pad pos-rule (
                value: either integer? pos [way * pos] [pos] 
                where: where + value 
                max-off: max-off + value
            ) 
            | 'across (if way <> 1x0 [way: 1x0 do rtn]) 
            | 'below (if way <> 0x1 [do rtn way: 0x1]) 
            | 'backward (way: negate way) 
            | 'origin [set pos [pair! | integer!] (origin: pos * 1x1) | none] (where: max-off: origin) 
            | 'guide [set pos pair! (guide: pos do rtn) | none (guide: where)] (max-off: 0x0) 
            | 'tab (where: next-tab tabs way where) 
            | 'tabs [
                set value [block! | pair!] (tabs: value) | 
                set value integer! (tabs: value * 1x1)
            ] 
            | 'indent pos-rule (where/x: either integer? pos [where/x + pos] [pos/x]) 
            | 'style set def-style word! 
            | 'styles set value block! 
            | 'size set pos pair! (pane-size: new-face/size: pos size: true) 
            | 'backcolor set value tuple! (new-face/color: value) 
            | 'backeffect set value block! (new-face/effect: value) 
            | 'do set value block! (do :value)
        ] 
        pos-rule: [set pos [integer! | pair! | skip (error "Expected position or size:" :pos)]] 
        if empty? vid-words [
            foreach value vid-rules [if lit-word? :value [append vid-words to-word value]]
        ] 
        while [not tail? specs] [
            forever [
                value: first specs specs: next specs 
                if set-word? :value [var: :value break] 
                unless word? :value [error "Misplaced item:" :value break] 
                if find vid-words value [
                    either value = 'style [
                        facets: reduce [first specs] 
                        specs: next specs
                    ] [
                        set [specs facets] do-facets start: specs [] styles
                    ] 
                    if :var [set :var where var: none] 
                    insert facets :value 
                    unless parse facets vid-rules [error "Invalid args:" start] 
                    break
                ] 
                new: select styles value 
                unless new [error "Unknown word or style:" value break] 
                set [specs facets] do-facets specs new/words styles 
                new: make new either val: select facets 'with [expand-specs new val] [[]] 
                new/style: value 
                new/origin: origin 
                new/pane-size: pane-size 
                if new/valid [new/valid: make new/valid []] 
                new/styles: styles 
                new/flags: exclude new/flags state-flags 
                new/text-body: make text-body [] 
                new/actors: make new/actors [] 
                unless flag-face? new fixed [new/offset: where] 
                grow-facets new facets 
                track ["Style:" new/style "Offset:" new/offset "Size:" new/size] 
                either def-style [
                    change next find styles def-style new 
                    def-style: none
                ] [
                    new/parent-face: none 
                    if :var [new/var: bind to-word :var :var] 
                    do bind new/init in new 'init 
                    if new/parent-face [new: new/parent-face] 
                    if :var [set :var new var: none] 
                    append pane new 
                    unless flag-face? new fixed [
                        max-off: maximum max-off new/size + space + where 
                        where: way * (new/size + space) + where
                    ] 
                    if all [warn any [new/offset/x > pane-size/x new/offset/y > pane-size/y]] [
                        error "Face offset outside the pane:" new/style
                    ] 
                    track ["Style:" new/style "Offset:" new/offset "Size:" new/size] 
                    unless keep [
                        new/init: copy [] 
                        new/words: new/styles: new/facets: none
                    ]
                ] 
                break
            ]
        ] 
        unless size [
            foreach face pane [if flag-face? face drop [face/size: 0x0]] 
            new-face/size: size: origin + second span? pane 
            foreach face pane [
                if flag-face? face drop [face/size: size] 
                face/pane-size: size
            ]
        ] 
        if get in new-face 'init [
            do bind (new-face/init) in new-face 'init 
            unless keep [new-face/init: none]
        ] 
        new-face
    ] 
    choice-face: make face [
        way: mway: iway: none 
        iter-face: none 
        item-size: none 
        options: [no-title no-border] 
        pane: func [face oset /num] [
            if pair? oset [return to-integer (1 + (to-integer oset/:way / item-size/:way))] 
            if any [none? oset oset > length? iter-face/flat-texts] [return none] 
            iter-face/text: pick iter-face/flat-texts oset 
            iter-face/offset: iter-face/old-offset: mway * item-size * (oset - 1) 
            iter-face/selectable: not all [iter-face/texts <> iter-face/flat-texts find iter-face/texts iter-face/text] 
            iter-face/color: switch true reduce [
                iter-face/selectable and iter-face/selected [iter-face/colors/2] 
                iter-face/selectable and not iter-face/selected [iter-face/colors/1] 
                not iter-face/selectable [any [iter-face/colors/3 iter-face/colors/2]]
            ] 
            iter-face
        ] 
        evt-func: func [face event /local iface over] [
            either event/type = 'down [
                iface: choice-face/pane self event/offset - choice-face/offset 
                any [all [iface: choice-face/pane self iface over: 'over] 
                    all [iface: choice-face/pane self 1 over: 'away]
                ] 
                iface/feel/engage iface over event 
                none
            ] [event]
        ] 
        set 'choose func [
            {Generates a choice selector menu, vertical or horizontal.} 
            choices [block!] "Block of items to display" 
            function [function! none!] "Function to call on selection" 
            /style styl [object!] "The style choice button" 
            /window winf [object!] "The parent window to appear in" 
            /offset xy [pair!] "Offset of choice box" 
            /across "Use horizontal layout" 
            /local t oset up down wsize edg
        ] [
            set [way mway iway] pick [[y 0x1 1x0] [x 1x0 0x1]] none? across 
            if none? window [winf: system/view/screen-face] 
            if none? style [styl: get-style 'button] 
            edg: any [all [styl/edge styl/edge/size] 0x0] 
            iter-face: make styl [
                size: size - (2 * edg) 
                pane-parent: styl 
                window: winf 
                feel: vid-feel/choice-iterator 
                texts: choices 
                flat-texts: [] 
                action: :function 
                selected: false 
                selectable: true 
                edge: none 
                if colors = vid-colors/window-background-color [colors/1: color] 
                unless block? colors [colors: vid-colors/window-background-color] 
                color: colors/1
            ] 
            item-size: iter-face/size 
            either find choices block! [
                clear iter-face/flat-texts 
                foreach x choices [append iter-face/flat-texts x]
            ] [iter-face/flat-texts: choices] 
            self/size: (item-size * mway * length? iter-face/flat-texts) + (item-size * iway) + (2 * (t: any [all [edge edge/size] 0x0])) 
            either offset [self/offset: xy] [
                oset: (either window [styl/offset] [screen-offset? styl]) + (any [all [styl/edge styl/edge/size] 0x0]) - t 
                t: any [find iter-face/flat-texts styl/text iter-face/flat-texts] 
                up: (index? t) - 1 * item-size/:way 
                down: ((subtract length? iter-face/flat-texts index? t) + 1 * item-size/:way) 
                wsize: get in find-window winf 'size 
                self/offset: (any [
                        all [up < (oset/:way - 4) down < (wsize/:way - oset/:way - 4) 
                            oset - ((mway * ((index? t) - 1) * item-size/:way))
                        ] 
                        all [up < (oset/:way - 4) if wsize/:way > (up + down + 8) [
                                edg: (to-integer ((wsize/:way - oset/:way - 4) / item-size/:way)) * item-size/:way 
                                oset - ((up + down - edg) * mway)
                            ]] 
                        oset - (oset - 4 * mway / iter-face/size/:way * iter-face/size/:way)
                    ])
            ] 
            show-popup/window/away self winf 
            do-events
        ]
    ] 
    set-edge: func [face type args] [
        face/edge: make face/edge [size: 2x2 effect: type color: 128.128.128] 
        unless tail? args: next args [
            if tuple? first args [face/edge/color: first args]
        ] 
        unless tail? args: next args [
            if any [integer? first args pair? first args] [
                face/edge/size: 1x1 * first args
            ]
        ] 
        next args
    ] 
    set-actor: func [face type args] [
        insert-actor-func face type make function! [face value event actor] bind args ctx-content
    ]
] 
--- "VID Debugging Tools" 
ctx-vid-debug: context [
    debug: false 
    fc: none 
    level: copy "" 
    set 'in-level does [if debug [append level "-"]] 
    set 'out-level does [if debug [remove level]] 
    set 'debug-face func [doing data] [
        if debug [print trim/lines to-string reduce [doing ": +" level data]]
    ] 
    face-name: does [any [all [function? fc "iterated"] fc/var fc/style fc/type "unknown"]] 
    face-text: does [mold any [all [function? fc "iterated"] fc/text ""]] 
    set 'debug-align func [face] [
        unless debug [exit] 
        fc: :face 
        debug-face "Aligning" reduce [
            face-name 
            face-text 
            "to" get in :fc 'align 
            "with fill" get in :fc 'fill 
            "with spring" mold get in :fc 'spring 
            "with size" get in :fc 'size
        ]
    ] 
    set 'debug-resize func [face diff] [
        unless debug [exit] 
        fc: :face 
        debug-face "Resizing" reduce [face-name face-text "by" diff]
    ] 
    set 'debug-vid func [str] [
        unless debug [exit] 
        print "Debug: " str
    ] 
    set 'remind func [value] [if debug [probe value]]
] 
dump-face: func [
    "Print face info for entire pane. (for debugging)" 
    face [object!] 
    /parent p 
    /local depth pane style
] [
    depth: " " 
    print [
        depth "Style:" 
        either face/show? [all [in face 'style face/style]] [rejoin [#"(" all [in face 'style face/style] #")"]] 
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
            any [all [not parent face/parent-face] face/parent-face = p] ["Yes"] 
            face/parent-face ["(Yes)"] 
            true ["No"]
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
--- "REBOL/View: Visual Interface Dialect - Feelings" 
svvf: system/view/vid/vid-feel: context [
    sensor: make face/feel [
        cue: blink: none 
        engage: func [face action event] [
            switch action [
                time [unless face/state [face/blinker: not face/blinker act-face face event 'on-time]] 
                down [face/state: on] 
                alt-down [face/state: on] 
                up [if face/state [do-face face face/text act-face face event 'on-click] face/state: off] 
                alt-up [if face/state [do-face-alt face face/text act-face face event 'on-alt-click] face/state: off] 
                over [face/state: on] 
                away [face/state: off]
            ] 
            cue face action 
            show face
        ]
    ] 
    hot: make sensor [
        over: func [face action event] [
            if all [face/font face/font/colors] [
                face/font/color: pick face/font/colors not action 
                show face 
                face/font/color: first face/font/colors
            ]
        ]
    ] 
    hot-area: make hot [
        over: func [face action event] [
            if face/colors [
                face/color: pick face/colors not action 
                show face 
                face/color: first face/colors
            ]
        ] 
        cue: none
    ] 
    reset-related-faces: func [face] [
        if face/related [
            foreach item face/parent-face/pane [
                if all [
                    item/related 
                    item/related = face/related 
                    item/data
                ] [
                    clear-face item 
                    show item
                ]
            ]
        ]
    ] 
    check: make sensor [
        over: none 
        redraw: func [face act pos] [
            act: pick face/images (to integer! face/data) + either face/hover [5] [1 + (2 * to integer! face/state)] 
            either face/pane [face/pane/image: act] [face/image: act]
        ] 
        engage: func [face action event] [
            if action = 'down [
                reset-related-faces face 
                do-face face face/data: not face/data 
                act-face face event 'on-click 
                show face
            ]
        ]
    ] 
    check-radio: make face/feel [
        redraw: func [face act pos] [
            act: pick face/images (to integer! face/data) + either face/hover [5] [1 + (2 * to integer! face/state)
            ] 
            either face/pane [face/pane/image: act] [face/image: act]
        ] 
        over: func [face over offset] [
            face/hover: over 
            show face 
            face/hover: off
        ] 
        engage: func [face action event] [
            switch action [
                down [face/state: on] 
                alt-down [face/state: on] 
                up [
                    if face/state [
                        face/state: off 
                        reset-related-faces face 
                        do-face face face/data: not face/data 
                        act-face face event 'on-click
                    ]
                ] 
                alt-up [
                    if face/state [
                        do-face-alt face face/text 
                        act-face face event 'on-alt-click
                    ] 
                    face/state: off
                ] 
                over [face/state: on] 
                away [face/state: off]
            ] 
            show face
        ]
    ] 
    led: make sensor [
        over: none 
        redraw: func [face act pos] [face/color: either face/data [face/colors/1] [face/colors/2]] 
        engage: func [face action event] [
            if any [action = 'time all [action = 'down get in face 'action]] [do-face face face/data: not face/data] 
            show face
        ]
    ] 
    button: make hot [
        redraw: func [face act pos /local state] [
            if all [face/texts face/texts/2] [
                face/text: either face/state [face/texts/2] [face/texts/1]
            ] 
            either face/images [
                face/image: either face/state [face/images/2] [face/images/1] 
                if all [face/colors face/effect find face/effect 'colorize] [
                    change next find face/effect 'colorize pick face/colors not face/state
                ]
            ] [
                unless flag-face? face disabled [
                    if face/edge [face/edge/effect: pick [ibevel bevel] face/state]
                ] 
                state: either not face/state [face/blinker] [true]
            ]
        ] 
        cue: none
    ] 
    btn: make button [
        over: func [face act evt] [
            remove/part find face/effect 'mix 2 
            if act [
                evt: any [find face/effect 'extend tail face/effect] 
                insert evt reduce ['mix face/images/3]
            ] 
            all [face/show? show face]
        ] 
        engage: func [face action event] [
            remove/part find face/effect 'mix 2 
            switch action [
                down [face/state: on] 
                alt-down [face/state: on] 
                up [if face/state [do-face face face/text act-face face event 'on-click] face/state: off] 
                alt-up [if face/state [do-face-alt face face/text act-face face event 'on-alt-click] face/state: off] 
                over [face/state: on] 
                away [face/state: off]
            ] 
            cue face action 
            all [face/show? show face]
        ]
    ] 
    icon: make hot [
        redraw: func [face act pos /local state] [
            if face/pane/edge [face/pane/edge/effect: pick [ibevel bevel] face/state]
        ] 
        cue: none
    ] 
    subicon: make hot [
        over: func [f a e] [f/parent-face/feel/over f/parent-face a e] 
        engage: func [f a e] [f/parent-face/feel/engage f/parent-face a e] 
        redraw: func [f a c] [f/parent-face/feel/redraw f/parent-face a c]
    ] 
    toggle: make button [
        engage: func [face action event] [
            if find [down alt-down] action [
                if face/related [
                    foreach item face/parent-face/pane [
                        if all [
                            any [all [in face 'keep face/keep] face <> item] 
                            flag-face? item toggle 
                            item/related 
                            item/related = face/related 
                            item/data
                        ] [
                            item/data: item/state: false 
                            show item
                        ]
                    ]
                ] 
                face/data: face/state: not face/state 
                either action = 'down [
                    do-face face face/data 
                    act-face face event 'on-click
                ] [
                    do-face-alt face face/data 
                    act-face face event 'on-alt-click
                ] 
                show face
            ]
        ]
    ] 
    tog: make btn [
        engage: get in toggle 'engage
    ] 
    rotary: make hot [
        redraw: func [face act pos] [
            face/text: face/data/2 
            if face/edge [face/edge/effect: pick [ibezel bezel] face/state] 
            if face/colors [face/color: any [pick face/colors index? face/data face/color]] 
            if face/effects [face/effect: pick face/effects not face/state]
        ] 
        next-face: func [face] [
            face/data: either tail? skip face/data 2 [head face/data] [skip face/data 2]
        ] 
        back-face: func [face] [
            face/data: either head? face/data [skip tail face/data -2] [skip face/data -2]
        ] 
        engage: func [face action event /local do-it down-it] [
            do-it: [if face/state [do-face face face/data/1] face/state: off] 
            down-it: [unless face/state [next-face face] face/state: on] 
            switch action [
                down down-it 
                up do-it 
                alt-down [
                    unless face/state [back-face face] face/state: on 
                    act-face face event 'on-click
                ] 
                alt-up do-it 
                over down-it 
                away [if face/state [back-face face] face/state: off]
            ] 
            show face
        ]
    ] 
    choice: make hot [
        engage: func [face action event /local idx y-size] [
            if action = 'down [
                if all [block? face/setup not empty? face/setup] [
                    set-face face/choice-face/pane/1 extract/index face/setup 2 2 
                    idx: divide 1 + index? face/data 2 
                    face/choice-face/pane/1/selected: to-block idx 
                    face/choice-face/pane/1/over: as-pair 1 idx 
                    ctx-resize/align-contents face/choice-face none 
                    y-size: face/size/y - (second 2 * edge-size face) 
                    set-menu-face 
                    face 
                    face/choice-face 
                    as-pair face/size/x (2 * second edge-size face) + divide y-size * length? head face/data 2 
                    add win-offset? face as-pair 0 y-size - (y-size * idx)
                ]
            ]
        ]
    ] 
    choice-iterator: make face/feel [
        over: func [face state] [
            face/selected: all [face/selectable state] 
            show face
        ] 
        engage: func [face act event] [
            if event/type = 'down [
                if all [face/selected face/selectable] [
                    do-face face face/pane-parent 
                    act-face face event 'on-click
                ] 
                hide-popup
            ] 
            show face
        ]
    ] 
    drag-off: func [bar drag val /local bmax ax] [
        val: val - bar/clip 
        bmax: bar/size - drag/size - (2 * bar/edge/size) - (2 * bar/clip) 
        val: max 0x0 min val bmax 
        ax: bar/axis 
        drag/offset: val/:ax + bar/clip/:ax * 0x1 
        if ax = 'x [drag/offset: reverse drag/offset] 
        if positive? bmax/:ax [bar/data: val/:ax / bmax/:ax] 
        do-face bar none
    ] 
    drag-action: func [face action event] [
        if find [over away] action [
            drag-off face/parent-face face face/offset + event/offset - face/data 
            show face
        ] 
        if find [down alt-down] action [face/data: event/offset]
    ] 
    drag-release-action: func [face action event] [
        if find [up alt-up] action [
            face/parent-face/redrag face/parent-face/ratio 
            show face/parent-face
        ]
    ] 
    drag: make face/feel [
        engage: :drag-action
    ] 
    scroller-drag: make drag [
        engage: func [face action event] [
            drag-action face action event 
            drag-release-action face action event
        ]
    ] 
    slide: make face/feel [
        redraw: func [face act pos] [
            face/data: max 0 min 1 face/data 
            if face/data <> face/state [
                pos: face/size - face/pane/1/size - (2 * face/edge/size) - (2 * face/clip) 
                either face/size/x > face/size/y [face/pane/1/offset/x: face/data * pos/x + face/clip/x] [
                    face/pane/1/offset/y: face/data * pos/y + face/clip/y
                ] 
                face/state: face/data 
                if act = 'draw [show face/pane/1]
            ]
        ] 
        engage: func [face action event] [
            if action = 'down [
                drag-off face face/pane/1 event/offset - (face/pane/1/size / 2) 
                act-face face event 'on-click 
                show face
            ]
        ]
    ] 
    set 'scroll-drag func [
        "Move the scroller drag bar" 
        face "the scroller to modify" 
        /back "move backward" 
        /page "move each time by one page"
    ] [
        any [
            all [back page move-drag face/pane/2 face/page] 
            all [back move-drag face/pane/2 face/step] 
            all [page move-drag face/pane/3 face/page] 
            move-drag face/pane/3 face/step
        ]
    ] 
    move-drag: func [face val] [
        face/parent-face/data: min 1 max 0 face/parent-face/data + (face/dir * val) 
        do-face face/parent-face none 
        show face/parent-face
    ] 
    scroll: make slide [
        engage: func [f act evt /local tmp] [
            if act = 'down [
                tmp: f/axis 
                do-face pick reduce [f/pane/3 f/pane/2] evt/offset/:tmp > f/pane/1/offset/:tmp f/page
            ]
        ]
    ] 
    scroll-button: make button [
        engage: func [f act evt] [
            switch act [
                down [f/state: on do-face f f/parent-face/step f/rate: 4] 
                up [f/state: flag: no f/rate: none] 
                time [either flag [either f/rate <> f/parent-face/speed [f/rate: f/parent-face/speed] [do-face f f/parent-face/step]] [flag: on exit]] 
                over [f/state: on if flag [f/rate: f/parent-face/speed]] 
                away [f/state: no f/rate: none]
            ] 
            cue f act 
            show f
        ] 
        flag: no
    ] 
    balancer: make face/feel [
        old-offset: none 
        real-face?: func [face new-face] [
            all [
                object? face 
                object? new-face 
                face <> new-face 
                any [
                    not in new-face 'style 
                    new-face/style <> 'highlight
                ]
            ]
        ] 
        lower-limit: func [face pos /local bf] [
            pos: max 0x0 pos 
            bf: back-face face 
            if real-face? face bf [pos: max pos bf/offset] 
            pos
        ] 
        upper-limit: func [face pos /local nf] [
            pos: min face/parent-face/size pos 
            nf: next-face face 
            if real-face? face nf [pos: min pos nf/size + nf/offset - face/size] 
            pos
        ] 
        engage: func [face act event /local axis tmp] [
            axis: face/axis 
            case [
                act = 'down [
                    old-offset: face/offset
                ] 
                find [away over up] act [
                    tmp: face/offset + event/offset 
                    tmp: lower-limit face tmp 
                    tmp: upper-limit face tmp 
                    if tmp/:axis = face/offset/:axis [exit] 
                    face/offset/:axis: tmp/:axis 
                    face/before face face/offset - old-offset 
                    face/after face face/offset - old-offset 
                    old-offset: face/offset 
                    set-tab-face get in root-face face 'tab-face 
                    do-face face none 
                    act-face face event 'on-click
                ]
            ] 
            show face/parent-face
        ]
    ] 
    resizer: make balancer [
        upper-limit: func [face pos] [
            min face/parent-face/size - face/size pos
        ]
    ] 
    window-manage: make face/feel [
        focus-ring-faces: none 
        drag-action: func [face event old-offset /local diff] [
            if face/parent-face/original-size [exit] 
            diff: face/parent-face/offset 
            face/parent-face/offset: face/parent-face/offset + event/offset - old-offset 
            face/parent-face/offset/y: 
            min 
            (face/parent-face/parent-face/size/y - face/size/y - second edge-size face/parent-face) 
            max 0 face/parent-face/offset/y 
            diff: face/parent-face/offset - diff 
            show face/parent-face 
            if face/tab-face [
                foreach fc focus-ring-faces [
                    fc/offset: fc/offset + diff
                ] 
                show focus-ring-faces
            ]
        ] 
        engage: func [face action event] [
            switch action [
                down [
                    old-offset: event/offset 
                    face/action face get-face face 
                    face/tab-face: get-tab-face face 
                    either all [face/tab-face within-face? face/tab-face face/parent-face] [
                        focus-ring-faces: get in root-face face 'focus-ring-faces
                    ] [
                        face/tab-face: none
                    ]
                ] 
                up [
                    face/tab-face: none
                ]
            ] 
            if find [over away] action [
                drag-action face event old-offset
            ]
        ]
    ] 
    window-resizer: make window-manage [
        drag-action: func [face event old-offset /local diff fpp new-size] [
            fpp: face/parent-face/parent-face 
            if face/parent-face/parent-face/original-size [exit] 
            new-size: max 100x100 fpp/size + event/offset - old-offset 
            if new-size <> fpp/size [
                resize/no-springs/no-show fpp new-size fpp/offset
            ] 
            show fpp/parent-face
        ]
    ] 
    progress: make face/feel [
        redraw: func [face act pos] [
            face/data: max 0 min 1 face/data 
            if face/data <> face/state [
                either face/size/x > face/size/y [
                    face/pane/size/x: max 1 face/data * face/size/x
                ] [
                    face/pane/size/y: max 1 face/data * face/size/y 
                    face/pane/offset: face/size - face/pane/size
                ] 
                face/state: face/data 
                if act = 'draw [show face/pane]
            ]
        ]
    ] 
    dropdown: make face/feel [
        over: redraw: detect: none 
        engage: func [face action event] [
            switch action [
                down [face/state: on act-face face event 'on-click] 
                up [if face/state [face/show-dropdown] face/state: off] 
                over [face/state: on] 
                away [face/state: off]
            ] 
            show face
        ]
    ]
] 
setup-face: func [
    "Sets up a face construct" 
    face 
    value 
    /no-show "Do not show change yet" 
    /local access show?
] [
    if all [
        access: get in face 'access 
        in access 'setup-face*
    ] [
        access/setup-face* face value 
        act-face face none 'on-setup
    ] 
    any [no-show show face] 
    face
] 
set-face: func [
    {Sets the primary value of a face. Returns face object (for show).} 
    face 
    value 
    /no-show "Do not show change yet" 
    /local access
] [
    if all [
        access: get in face 'access 
        in access 'set-face*
    ] [
        access/set-face* face value 
        act-face face none 'on-set
    ] 
    any [no-show show face] 
    face
] 
get-face: func [
    "Returns the primary value of a face." 
    face [object!] 
    /local access
] [
    if all [
        access: get in face 'access 
        in access 'get-face*
    ] [
        access/get-face* face
    ]
] 
clear-face: func [
    "Clears the primary value of a face." 
    face 
    /no-show "Do not show change yet" 
    /local access
] [
    if all [
        access: get in face 'access 
        in access 'clear-face*
    ] [
        access/clear-face* face 
        act-face face none 'on-clear
    ] 
    any [no-show show face] 
    face
] 
reset-face: func [
    "Resets the primary value of a face." 
    face 
    /no-show "Do not show change yet" 
    /local access
] [
    if all [
        access: get in face 'access 
        in access 'reset-face*
    ] [
        access/reset-face* face 
        act-face face none 'on-reset
    ] 
    any [no-show show face] 
    face
] 
search-face: func [
    "Searches the contents of a face for a value." 
    face 
    value 
    /no-show "Do not show change yet" 
    /local access
] [
    if all [
        access: get in face 'access 
        in access 'search-face*
    ] [
        access/search-face* face value 
        act-face face none 'on-search
    ] 
    any [no-show show face] 
    face
] 
attach-face: func [
    {Attaches the first face to the second, specifying what to do and when.} 
    from-face "Face to act with" 
    to-face "Face to act on" 
    what [word!] "What to act with" 
    when [word! block!] "When to act"
] [
    what 
    when 
    from-face 
    to-face 
    get in from-face what
] 
scroll-face: func [
    "Scrolls a face according to scroll values." 
    face 
    x-value [number! none!] "Value between 0 and 1" 
    y-value [number! none!] "Value between 0 and 1" 
    /step {x and y values are multiples of face step size instead of absolutes} 
    /no-show "Do not show changes yet." 
    /local access show? scroll
] [
    if all [
        access: get in face 'access 
        in access 'scroll-face*
    ] [
        if all [
            step 
            in access 'get-offset*
        ] [
            if all [x-value not zero? x-value] [
                x-value: 
                max 0 min 1 
                (face/scroll/step-unit face) * 
                x-value + 
                access/get-offset* face 'x
            ] 
            if all [y-value not zero? y-value] [
                y-value: 
                max 0 min 1 
                (face/scroll/step-unit face) * 
                y-value + 
                access/get-offset* face 'y
            ]
        ] 
        set/any 'show? access/scroll-face* face x-value y-value 
        act-face face none 'on-scroll 
        if value? 'show? [no-show: not show?]
    ] 
    any [no-show show face] 
    face
] 
resize-face: func [
    "Resize a face." 
    face 
    size [number! pair!] 
    /x "Resize only width" 
    /y "Resize only height" 
    /no-show "Do not show change yet" 
    /local access
] [
    if all [
        access: get in face 'access 
        in access 'resize-face*
    ] [
        access/resize-face* face size x y 
        act-face face none 'on-resize
    ] 
    any [no-show show face] 
    face
] 
move-face: func [
    "Move a face." 
    face 
    offset [number! pair!] 
    size 
    /scale {Keeps the lower right corner at the original position} 
    /no-show "Do not show change yet"
] [
    face/offset: face/offset + offset 
    if scale [
        resize/no-show face face/size face/size - offset
    ] 
    any [no-show show face] 
    face
] 
set 'enable-face func [
    {Enables a face or a panel of faces with TABBED flag.} 
    face 
    /no-show "Do not show change yet." 
    /local flags
] [
    either any [
        flag-face? face panel 
        flag-face? face compound
    ] [
        deflag-face face disabled 
        if flag-face? face detabbed [
            deflag-face face detabbed 
            flag-face face tabbed
        ] 
        traverse-face face [enable-face/no-show face]
    ] [
        if flag-face? face disabled [
            deflag-face face disabled 
            if flag-face? face detabbed [
                deflag-face face detabbed 
                flag-face face tabbed
            ] 
            restore-feel face 
            restore-font face 
            either all [
                in face 'access 
                in face/access 'enable-face*
            ] [
                face/access/enable-face* face
            ] [
                remove/part 
                find/reverse 
                tail face/effect 
                first disabled-effect 
                length? disabled-effect
            ]
        ]
    ] 
    any [no-show show face]
] 
enable-face: func [
    {Enables a face or a panel of faces with DISABLED flag.} 
    face 
    /no-show "Do not show change yet." 
    /local flags
] [
    if flag-face? face disabled [
        deflag-face face disabled 
        if flag-face? face detabbed [
            deflag-face face detabbed 
            flag-face face tabbed
        ] 
        restore-feel face 
        restore-font face 
        either all [
            in face 'access 
            in face/access 'enable-face*
        ] [
            face/access/enable-face* face
        ] [
            remove/part 
            find/reverse 
            tail face/effect 
            first disabled-effect 
            length? disabled-effect
        ] 
        act-face face none 'on-enable
    ] 
    if any [
        flag-face? face panel 
        flag-face? face compound
    ] [
        traverse-face face [enable-face/no-show face]
    ] 
    any [no-show show face]
] 
disable-face: func [
    {Disables a face or a panel of faces with ACTION flag.} 
    face [object!] 
    /no-show "Do not show change yet."
] [
    if same? face get-tab-face face [
        validate-face face 
        unfocus face
    ] 
    if all [
        not flag-face? face disabled 
        flag-face? face action
    ] [
        if flag-face? face tabbed [
            deflag-face face tabbed 
            flag-face face detabbed
        ] 
        flag-face face disabled 
        save-feel face make face/feel [over: engage: detect: none] 
        save-font face make face/font [] 
        either all [
            in face 'access 
            in face/access 'disable-face*
        ] [
            face/access/disable-face* face
        ] [
            either block? face/effect [
                append face/effect copy disabled-effect
            ] [
                face/effect: copy disabled-effect
            ]
        ] 
        act-face face none 'on-disable
    ] 
    if any [
        flag-face? face panel 
        flag-face? face compound
    ] [
        traverse-face face [disable-face/no-show face]
    ] 
    any [no-show show face]
] 
insert-actor-func: func [face actor fn] [
    if in face 'actors [
        if none? get in face/actors actor [
            face/actors/:actor: make block! []
        ] 
        insert/only tail face/actors/:actor :fn
    ]
] 
remove-actor-func: func [face actor fn /local act] [
    if in face 'actors [
        any [
            none? act: get in face/actors actor 
            remove find act :fn
        ]
    ]
] 
act-face: func [[catch] face event actor] [
    unless in face 'actors [
        throw make error! join "Actors do not exist for " describe-face face
    ] 
    unless find first face/actors actor [
        throw make error! reform ["Actor" actor "not found"]
    ] 
    if ctx-vid-debug/debug [
        print ["Face:" describe-face face] 
        print ["Actor:" actor]
    ] 
    if block? get in face/actors actor [
        foreach act get in face/actors actor [
            act face get-face face event actor
        ]
    ]
] 
ctx-access: context [
    data: context [
        set-face*: func [face value] [face/data: value] 
        get-face*: func [face] [face/data] 
        clear-face*: 
        reset-face*: func [face] [set-face* face false]
    ] 
    data-default: make data [
        reset-face*: func [face] [set-face* face face/default]
    ] 
    data-state: make data [
        set-face*: func [face value] [face/data: face/state: value]
    ] 
    data-number: make data [
        set-face*: func [face value] [
            unless number? value [
                make error! reform [face/style "must be set to a number"]
            ] 
            face/data: value
        ] 
        clear-face*: 
        reset-face*: func [face] [face/data: 0]
    ] 
    data-find: context [
        set-face*: func [face value] [
            all [series? face/data value: find head face/data value face/data: value]
        ] 
        get-face*: func [face] [all [series? face/data face/data/1]] 
        clear-face*: 
        reset-face*: func [face] [all [series? face/data face/data: head face/data]]
    ] 
    data-pick: context [
        set-face*: func [face value] [
            all [in face 'picked insert clear head face/picked value]
        ] 
        get-face*: func [face] [get in face 'picked] 
        clear-face*: 
        reset-face*: func [face] [all [in face 'picked clear face/picked]]
    ] 
    text: context [
        set-face*: func [face value] [
            face/text: value 
            face/line-list: none
        ] 
        get-face*: func [face] [face/text] 
        clear-face*: func [face] [
            if face/para [face/para/scroll: 0x0] 
            if string? face/text [clear face/text] 
            face/line-list: none
        ] 
        reset-face*: func [face] [
            if face/para [face/para/scroll: 0x0] 
            face/text: copy "" 
            face/line-list: none 
            set-face* face face/default
        ]
    ] 
    button: context [
        disable-face*: func [face /local tmp] [
            if face/disabled-colors [
                tmp: face/colors 
                face/colors: face/disabled-colors 
                face/disabled-colors: tmp 
                face/color: first face/colors
            ] 
            if face/font [
                face/font/color: face/color - 50
            ] 
            face/edge: make face/edge disabled-normal-edge
        ] 
        enable-face*: func [face /local tmp] [
            if face/disabled-colors [
                tmp: face/disabled-colors 
                face/disabled-colors: face/colors 
                face/colors: tmp 
                face/color: first face/colors
            ] 
            face/edge: make face/edge normal-edge
        ]
    ] 
    toggle: make data-state [
        disable-face*: func [face /local tmp] [
            if face/disabled-colors [
                tmp: face/colors 
                face/colors: face/disabled-colors 
                face/disabled-colors: tmp 
                face/color: first face/colors
            ] 
            if face/font [
                face/font/color: face/color - 50
            ] 
            face/edge: make face/edge disabled-normal-edge
        ] 
        enable-face*: func [face /local tmp] [
            if face/disabled-colors [
                tmp: face/disabled-colors 
                face/disabled-colors: face/colors 
                face/colors: tmp 
                face/color: first face/colors
            ] 
            face/edge: make face/edge normal-edge
        ]
    ] 
    field: make text [
        get-face*: func [face] [
            case [
                flag-face? face hide [face/data] 
                flag-face? face integer [any [attempt [to-integer face/text] 0]] 
                flag-face? face decimal [any [attempt [to-decimal face/text] 0]] 
                true [face/text]
            ]
        ] 
        set-face*: func [face value] [
            if face/para [face/para/scroll: 0x0] 
            face/text: all [value form value] 
            either flag-face? face hide [
                face/data: all [value form value] 
                face/text: all [value head insert/dup copy "" "*" length? face/data]
            ] [
                either any [
                    flag-face? face integer 
                    flag-face? face decimal
                ] [
                    face/data: 
                    case [
                        none? value [0] 
                        integer? value [value] 
                        decimal? value [value] 
                        all [series? value empty? value] [0] 
                        error? try [to-decimal value] [0] 
                        equal? to-integer value to-decimal value [to-integer value] 
                        true [to-decimal value]
                    ] 
                    face/text: form face/data
                ] [
                    face/data: all [value not empty? face/text copy face/text]
                ]
            ] 
            if system/view/focal-face = face [
                ctx-text/unlight-text 
                system/view/caret: at face/text index? system/view/caret
            ] 
            ctx-text/set-text-body face form face/text 
            face/line-list: none
        ] 
        clear-face*: func [face] [
            if face/para [face/para/scroll: 0x0] 
            if string? face/text [ctx-text/clear-text face] 
            if flag-face? face hide [clear face/data] 
            ctx-text/set-text-body face form face/data 
            face/line-list: none
        ] 
        scroll-face*: func [face x y /local edge para size] [
            edge: any [attempt [2 * face/edge/size] 0] 
            para: face/para/origin + face/para/margin 
            size: negate face/text-body/size - face/size + edge + para 
            if x [face/para/scroll/x: x * size/x] 
            if y [face/para/scroll/y: y * size/y] 
            face/para/scroll
        ] 
        disable-face*: func [face /local tmp] [
            tmp: face/colors 
            face/colors: face/disabled-colors 
            face/disabled-colors: tmp 
            face/font/color: 80.80.80 
            face/edge: make face/edge disabled-field-edge
        ] 
        enable-face*: func [face /local tmp] [
            tmp: face/disabled-colors 
            face/disabled-colors: face/colors 
            face/colors: tmp 
            face/effect: none 
            face/edge: make face/edge field-edge
        ]
    ] 
    image: context [
        set-face*: func [face value] [
            if any [image? value none? value] [
                face/image: value
            ]
        ] 
        get-face*: func [face] [face/image] 
        clear-face*: func [face] [face/image: none] 
        reset-face*: func [face] [set-face* face face/default]
    ] 
    compound: context [
        blk: none 
        set-panel: func [face value] [
            i: 0 
            foreach f get-pane face [
                case [
                    find f/flags 'input [
                        unless empty? value [
                            unless flag-face? face transparent [
                                set-face f value/1
                            ] 
                            value: next value
                        ]
                    ] 
                    find f/flags 'panel [
                        value: set-panel f value
                    ]
                ]
            ] 
            value
        ] 
        set-face*: func [face value] [
            if block? get-pane face [
                if object? value [value: extract/index third value 2 2] 
                if block? value [set-panel face value]
            ]
        ] 
        get-panel: func [face /local pane] [
            foreach f get-pane face [
                case [
                    find f/flags 'input [
                        append/only blk 
                        either flag-face? face transparent [
                            unless flag-face? f disabled [get-face f]
                        ] [
                            get-face f
                        ]
                    ] 
                    find f/flags 'panel [
                        get-panel f
                    ]
                ]
            ]
        ] 
        get-face*: func [face /local var transparent] [
            if block? get-pane face [
                blk: make block! 6 
                get-panel face
            ] 
            blk
        ] 
        clear-face*: func [face] [
            if block? get-pane face [
                foreach f get-pane face [
                    if any [find f/flags 'input find f/flags 'panel] [
                        clear-face/no-show f
                    ]
                ]
            ]
        ] 
        reset-face*: func [face] [
            if block? get-pane face [
                foreach f get-pane face [
                    if any [find f/flags 'input find f/flags 'panel] [
                        reset-face/no-show f
                    ]
                ]
            ]
        ]
    ] 
    panel: make compound [
        blk: none 
        setup-face*: func [face value /local err panel-size pane panes sizes user-size? word] [
            either block? value [
                if empty? value [
                    insert/only insert value 'default make block! []
                ]
            ] [
                value: reduce ['default make block! []]
            ] 
            face/setup: value 
            face/real-size: none 
            face/panes: make block! length? value 
            sizes: make block! length? value 
            parse value [
                any [
                    set word word! 
                    opt string! 
                    set pane block! (
                        face/add-pane face word pane 
                        insert tail sizes face/panes/2/size
                    )
                ]
            ] 
            face/panes: head face/panes 
            user-size?: pair? face/size 
            panel-size: 0x0 
            unless flag-face? face scrollable [
                either user-size? [
                    panel-size: face/size 
                    if face/edge [panel-size: panel-size - (face/edge/size * 2)]
                ] [
                    foreach size sizes [
                        panel-size/x: max size/x panel-size/x 
                        panel-size/y: max size/y panel-size/y
                    ] 
                    face/size: max any [face/size 0x0] panel-size 
                    if face/edge [face/size: panel-size + (face/edge/size * 2)]
                ]
            ] 
            foreach [word pane] face/panes [pane/size: panel-size]
        ] 
        set-find-var: func [pane var value] [
            foreach f pane [
                if all [
                    find f/flags 'input 
                    f/var = var 
                    set-face f value
                ] [return true]
            ] 
            false
        ] 
        set-panel-pane: func [[catch] face value /local p old-tab-face tab-face] [
            if all [not empty? head face/panes any-word? value] [
                tab-face: get-tab-face face 
                if tab-face [
                    either within-face? tab-face face [
                        old-tab-face: face/pane/tab-face: tab-face
                    ] [
                        face/pane/tab-face: none
                    ]
                ] 
                either p: find head face/panes value [
                    face/pane: first next face/panes: p
                ] [
                    throw make error! reform ["Could not find pane" value "in" describe-face face]
                ] 
                if all [
                    tab-face 
                    old-tab-face
                ] [
                    focus 
                    any [
                        face/pane/tab-face 
                        find-flag face tabbed 
                        root-face face
                    ]
                ] 
                true
            ]
        ] 
        set-face*: func [face value] [
            if set-panel-pane face value [exit] 
            if block? get-pane face [
                if object? value [value: extract/index third value 2 2] 
                if block? value [set-panel face value]
            ]
        ]
    ] 
    tab-panel: make panel [
        set-face*: func [face value] [
            either word? value [
                set-face face/pane/2 value 
                do-face face/pane/2 none
            ] [
                set-face/no-show face/pane/1 value
            ]
        ] 
        get-face*: func [face] [
            get-face face/pane/2
        ] 
        reset-face*: func [face] [
            set-face* face face/default
        ] 
        setup-face*: func [face value /local action tabs panes] [
            face/setup: value 
            face/real-size: none 
            tabs: make block! [] 
            panes: make block! [] 
            action: get in face 'action 
            unless block? face/setup [
                face/setup: 
                either all [function? :action not empty? second :action] [
                    second :action
                ] [
                    make block! []
                ]
            ] 
            use [b s t w] [
                t: none 
                parse face/setup [
                    any [
                        set w word! 
                        set s string! 
                        opt [set t tuple!] 
                        [set b block! | set b word! (b: get b)] (
                            repend tabs [w s t] 
                            append/only append panes w b
                        )
                    ]
                ]
            ] 
            face/pane: layout/styles/tight 
            compose/only [
                space 0 
                tab-selector setup (tabs) [set-face face/parent-face/pane/1 get-face face] 
                pad 0x-2 
                tab-panel-frame fill 1x1 setup (panes)
            ] 
            copy face/styles 
            face/tab-selector: face/pane/pane/1 
            reverse face/pane/pane 
            panes: none 
            face/size: max any [face/size 0x0] face/pane/size 
            face/pane: face/pane/pane 
            set-parent-faces face
        ]
    ] 
    face-construct: make data-default [
        setup-face*: func [face setup /local tab-face] [
            face/setup: setup 
            tab-face: get-tab-face face 
            any [none? tab-face within-face? tab-face face tab-face: none] 
            unfocus 
            face/pane: none 
            any [face/setup get in face 'do-setup exit] 
            clear face/lo 
            face/do-setup face face/setup 
            face/pane: layout/tight face/lo 
            face/real-size: none 
            face/pane/real-size: none 
            face/size: face/pane/size 
            face/pane: face/pane/pane 
            set-parent-faces face 
            ctx-resize/align face 
            if all [face/show? tab-face] [
                focus any [find-flag face tabbed root-face face]
            ]
        ]
    ] 
    selector: make face-construct [
        set-face*: func [face value /local f v words] [
            face/data: value 
            foreach f face/pane [
                set-face/no-show f false
            ] 
            unless value [show face exit] 
            value: to-word value 
            words: copy face/setup 
            remove-each w words [not word? w] 
            f: find words value 
            if found? f [
                v: pick face/pane index? f 
                set-face v true
            ]
        ] 
        clear-face*: func [face /local i] [
            foreach f face/pane [set-face/no-show f false] 
            face/data: none
        ] 
        reset-face*: func [face] [
            set-face face first face/setup
        ]
    ] 
    multi-selector: make face-construct [
        set-selectors: func [face /local values] [
            foreach f face/pane [
                set-face/no-show f found? find face/data f/var
            ]
        ] 
        set-face*: func [face value /local f] [
            face/data: value 
            foreach f face/pane [
                set-face/no-show f false
            ] 
            if empty? face/data [show face exit] 
            set-selectors face
        ] 
        key-face*: func [face event] [
            case [
                find [left up] event/key [
                    tab-face: find-flag/reverse tab-face tabbed 
                    if tab-face [set-tab-face tab-face]
                ] 
                find [right down] event/key [
                    tab-face: find-flag tab-face tabbed 
                    if tab-face [set-tab-face tab-face]
                ]
            ]
        ] 
        clear-face*: func [face /local i] [
            foreach f face/pane [set-face/no-show f false]
        ] 
        reset-face*: func [face] [
            face/data: copy face/default 
            set-selectors face
        ]
    ] 
    selector-nav: context [
        key-face*: func [face event /local tab-face] [
            case [
                find [left up] event/key [
                    tab-face: 
                    either head? find face/parent-face/pane face [
                        last face/parent-face/pane
                    ] [
                        find-flag/reverse get-tab-face face tabbed
                    ]
                ] 
                find [right down] event/key [
                    tab-face: 
                    either tail? next find face/parent-face/pane face [
                        first face/parent-face/pane
                    ] [
                        find-flag get-tab-face face tabbed
                    ]
                ] 
                find [#" " #"^M"] event/key [
                    either event/shift [
                        click-face/alt face
                    ] [
                        click-face face
                    ]
                ]
            ] 
            if tab-face [set-tab-face tab-face]
        ]
    ] 
    system/view/vid/vid-face/access: data
] 
--- "VID Text Editing Context" 
ctx-text: [
    view*: system/view 
    hilight-text: func [face begin end] [
        highlight-start: begin 
        highlight-end: end
    ] 
    hilight-all: func [face] [
        either empty? face/text [unlight-text] [
            highlight-start: head face/text 
            highlight-end: tail face/text
        ]
    ] 
    unlight-text: does [
        highlight-start: highlight-end: none
    ] 
    hilight?: does [
        all [
            object? focal-face 
            string? highlight-start 
            string? highlight-end 
            not zero? offset? highlight-end highlight-start
        ]
    ] 
    hilight-range?: has [start end] [
        start: highlight-start 
        end: highlight-end 
        if negative? offset? start end [start: end end: highlight-start] 
        reduce [start end]
    ] 
    store-hilight: func [face] [
        face/text-body/caret: caret 
        face/text-body/highlight-start: highlight-start 
        face/text-body/highlight-end: highlight-end
    ] 
    get-hilight: func [face] [
        highlight-start: face/text-body/highlight-start 
        highlight-end: face/text-body/highlight-end 
        caret: face/text-body/caret
    ] 
    clear-hilight: func [face] [
        face/text-body/highlight-start: face/text-body/highlight-end: none
    ] 
    left-hilight?: does [lesser? index? highlight-start index? highlight-end] 
    left-hilight: does [
        either left-hilight? [highlight-start] [highlight-end]
    ] 
    right-hilight: does [
        either left-hilight? [highlight-end] [highlight-start]
    ] 
    text-edit-face?: func [face] [
        any [
            flag-face? face 'text-edit 
            flag-face? face 'full-text-edit
        ]
    ] 
    set 'focus func [
        "Focuses key events on a specific face." 
        face 
        /keep "Reinstate caret position and selection" 
        /no-show "Do not show change yet." 
        /local root
    ] [
        unfocus/new face 
        any [face return face] 
        case [
            text-edit-face? face [
                focal-face: face
            ] 
            flag-face? face 'compound [
                traverse-face face [
                    all [
                        text-edit-face? face 
                        focal-face: face 
                        break
                    ]
                ]
            ]
        ] 
        if focal-face [
            unless string? focal-face/text [
                focal-face/text: either focal-face/text [form focal-face/text] [copy ""] 
                focal-face/line-list: none
            ] 
            either any [keep flag-face? focal-face keep] [
                get-hilight focal-face
            ] [
                unless caret [caret: tail focal-face/text]
            ] 
            if none? focal-face/line-list [
                if focal-face/para [focal-face/para/scroll: 0x0] 
                caret: tail focal-face/text
            ] 
            if flag-face? focal-face field [hilight-all focal-face]
        ] 
        set in root-face face 'focal-face focal-face 
        act-face face none 'on-focus 
        any [no-show show face] 
        set-tab-face face
    ] 
    set 'unfocus func [
        "Removes the current key event focus." 
        /new new-face "New face being unfocused." 
        /local root tmp-face
    ] [
        tmp-face: focal-face 
        focal-face: none 
        if tmp-face [
            validate-face tmp-face 
            if root: root-face tmp-face [
                if any [
                    none? new-face 
                    equal? root root-face new-face
                ] [
                    set in root 'focal-face none
                ]
            ] 
            store-hilight tmp-face
        ] 
        caret: none 
        unlight-text 
        if tmp-face [
            show tmp-face 
            act-face tmp-face none 'on-unfocus
        ] 
        tmp-face
    ] 
    copy-selected-text: func [face /local start end] [
        if all [
            hilight? 
            not flag-face? face hide
        ] [
            set [start end] hilight-range? 
            attempt [write clipboard:// copy/part start end] 
            true
        ]
    ] 
    copy-text: func [face] [
        unless copy-selected-text face [
            hilight-all face 
            copy-selected-text face
        ]
    ] 
    delete-selected-text: func [/local face start end] [
        if hilight? [
            face: focal-face 
            set [start end] hilight-range? 
            if flag-face? face hide [remove/part at face/text index? start index? end] 
            remove/part start end 
            caret: start 
            face/line-list: none 
            unlight-text 
            true
        ]
    ] 
    clear-text: func [face] [
        caret: head clear face/text 
        unlight-text 
        face/line-list: none
    ] 
    view*/vid/word-limits: use [cs] [
        cs: charset { ^-
^M/[](){}"} 
        reduce [cs complement cs]
    ] 
    next-word: func [str /local s ns] [
        set [s ns] vid/word-limits 
        any [all [s: find str s find s ns] tail str]
    ] 
    back-word: func [str /local s ns] [
        set [s ns] vid/word-limits 
        any [all [ns: find/reverse back str ns ns: find/reverse ns s next ns] head str]
    ] 
    end-of-line: func [str /local nstr] [
        either nstr: find str newline [nstr] [tail str]
    ] 
    beg-of-line: func [str /local nstr] [
        either nstr: find/reverse str newline [next nstr] [head str]
    ] 
    tab-size: 4 
    tab-offset?: func [pos-start pos-end /local offset tabs] [
        tabs: 0 
        repeat i offset: offset? pos-start pos-end [
            if #"^-" = pick pos-start i [
                tabs: tabs + 1
            ]
        ] 
        tabs * tab-size + offset - tabs
    ] 
    line-height: func [face /local l-info] [
        either zero? line-info/size/y [
            insert head caret #"X" 
            textinfo face l-info: make line-info [] 0 head caret 
            remove head caret 
            l-info/size/y
        ] [
            line-info/size/y
        ]
    ] 
    set-text-body: func [face caret /local ft lines font para edge] [
        any [face/font return none] 
        any [ft: face/text-body return none] 
        unless all [face/text caret] [return ft/lines: none] 
        lines: parse/all face/text "^/" 
        textinfo face line-info caret 
        any [line-info/size return none] 
        para: face/para 
        font: face/font 
        edge: face/edge 
        ft/size: size-text face 
        ft/line-height: line-height face 
        ft/area: face/size - (any [attempt [edge/size * 2] 0]) - para/origin - para/margin 
        ft/paras: length? lines 
        ft/para: ft/paras - length? parse/all caret "^/" 
        ft/para-start: index? beg-of-line caret 
        ft/para-end: index? end-of-line caret 
        ft/lines: round ft/size/y / ft/line-height 
        ft/line: 1 + round line-info/offset/y - para/scroll/y / ft/line-height 
        ft/line-start: index? line-info/start 
        ft/line-end: ft/line-start + line-info/num-chars 
        if empty? face/text [para/scroll: 0x0] 
        if ft/line = 1 [para/scroll/y: 0] 
        if line-info/start = caret [para/scroll/x: 0] 
        para/scroll/y: max min 0 ft/area/y - ft/size/y min 0 para/scroll/y 
        para/scroll/x: max min 0 ft/area/x - ft/size/x min 0 para/scroll/x 
        ft/v-scroll: abs para/scroll/y / max 1 ft/size/y - ft/area/y 
        ft/h-scroll: abs para/scroll/x / max 1 ft/size/x - ft/area/x 
        ft/v-ratio: min 1 ft/area/y / max 1 ft/size/y 
        ft/h-ratio: min 1 ft/area/x / max 1 ft/size/x 
        ft
    ] 
    set 'clear-fields func [
        "Clear all text fields faces of a layout." 
        panel [object!]
    ] [
        unless all [in panel 'type panel/type = 'face] [exit] 
        unfocus 
        foreach face panel/pane [
            if all [series? face/text flag-face? face field] [
                clear face/text 
                face/line-list: none
            ]
        ]
    ] 
    next-field: func [face /local item] [
        all [
            item: find face/parent-face/pane face 
            while [
                if tail? item: next item [item: head item] 
                face <> first item
            ] [
                if all [object? item/1 flag-face? item/1 tabbed] [return item/1]
            ]
        ] 
        none
    ] 
    back-field: func [face /local item] [
        all [
            item: find face/parent-face/pane face 
            while [face <> first item: back item] [
                if all [object? item/1 flag-face? item/1 tabbed] [return item/1] 
                if head? item [item: tail item]
            ]
        ] 
        none
    ] 
    keymap: [
        #"^H" back-char 
        #"^-" tab-char 
        #"^~" del-char 
        #"^M" enter 
        #"^A" all-text 
        #"^C" copy-text 
        #"^X" cut-text 
        #"^V" paste-text 
        #"^T" clear-tail 
        #"^[" escape
    ] 
    base-keys: make bitset! 64#{AQAAAP//////////////f/////////////////////8=} 
    nav-keys: make bitset! ["^-"] 
    ctrl-keys: union nav-keys make bitset! [#"^H" #"^M" #"^~" #" "] 
    integer-keys: make bitset! [#"0" - #"9"] 
    sign-key: make bitset! [#"-" #"+"] 
    decimal-keys: make bitset! [#"0" - #"9" #"." #","] 
    keys-to-insert: func [face /local base] [
        base: case [
            flag-face? face integer [integer-keys] 
            flag-face? face decimal [decimal-keys] 
            true [base-keys]
        ] 
        if flag-face? face sign [base: union base sign-key] 
        base
    ] 
    insert-char: func [face char] [
        delete-selected-text 
        unless same? head face/text head caret [caret: at face/text index? caret] 
        face/dirty?: true 
        if error? try [caret: insert caret char] [append caret char]
    ] 
    caret-highlight: func [event] [
        switch/default event/key [
            left [left-hilight] 
            right [right-hilight] 
            up [left-hilight] 
            down [right-hilight]
        ] [
            caret
        ]
    ] 
    auto-tab-move: func [face event caret? new-face caret-pos] [
        if flag-face? face auto-tab [
            if caret? [
                act-face face event 'on-tab 
                focus/no-show new-face 
                caret: caret-pos 
                return true
            ]
        ]
    ] 
    move: func [event ctrl plain] [
        either event/shift [
            any [highlight-start highlight-start: caret]
        ] [
            if hilight? [
                caret: caret-highlight event
            ] 
            unlight-text
        ] 
        caret: either event/control ctrl plain 
        if event/shift [either caret = highlight-start [unlight-text] [highlight-end: caret]]
    ] 
    move: func [event ctrl-move-to move-to hilight-func] [
        either event/shift [
            any [highlight-start highlight-start: caret] 
            caret: either event/control ctrl-move-to move-to 
            either caret = highlight-start [unlight-text] [highlight-end: caret]
        ] [
            either hilight? [
                caret: hilight-func 
                unlight-text
            ] [
                caret: either event/control ctrl-move-to move-to
            ]
        ]
    ] 
    move-y: func [face delta /local pos tmp tmp2] [
        tmp: offset-to-caret face delta + pos: caret-to-offset face caret 
        tmp2: caret-to-offset face tmp 
        either tmp2/y <> pos/y [tmp] [caret]
    ] 
    edit-text: func [
        face event action 
        /local key liney swap-text tmp tmp2 page-up page-down face-size face-edge
    ] [
        key: event/key 
        face-size: face/size - face-edge: either face/edge [2 * face/edge/size] [0x0] 
        if flag-face? face hide swap-text: [
            tmp: face/text 
            face/text: face/data 
            face/data: tmp 
            caret: either error? try [index? caret] [tail face/text] [
                at face/text index? caret
            ]
        ] 
        textinfo face line-info 0 
        liney: line-info/size/y 
        if char? key [
            either find keys-to-insert face key [
                either all [
                    not hilight? 
                    in face 'max-length 
                    integer? get in face 'max-length 
                    face/max-length > -1
                ] [
                    either flag-face? face auto-tab [
                        if all [
                            not hilight? 
                            face/max-length < index? caret
                        ] [
                            act-face face event 'on-tab 
                            focus face: find-style face face/style 
                            caret: head caret
                        ] 
                        insert-char face key
                    ] [
                        if face/max-length > length? face/text [
                            insert-char face key
                        ]
                    ]
                ] [
                    insert-char face key
                ]
            ] [
                key: either all [
                    block? face/keycode 
                    tmp: find face/keycode key 
                    either tmp/2 = 'control [event/control] [true]
                ] [
                    if flag-face? face hide swap-text 
                    action face key 
                    none
                ] [
                    select keymap key
                ]
            ]
        ] 
        if word? key [
            page-up: [move-y face face-size - liney - liney * 0x-1] 
            page-down: [move-y face face-size - liney * 0x1] 
            do select [
                back-char [
                    if all [flag-face? face auto-tab not hilight? head? caret] [
                        focus/no-show find-style/reverse face face/style 
                        unlight-text 
                        caret: tail caret
                    ] 
                    if all [not delete-selected-text not head? caret] [
                        either event/control [
                            tmp: caret 
                            remove/part caret: back-word tmp tmp
                        ] [
                            remove caret: back caret
                        ]
                    ] 
                    face/dirty?: true
                ] 
                del-char [
                    if all [not delete-selected-text not tail? caret] [
                        either event/control [
                            remove/part caret next-word caret
                        ] [
                            remove caret
                        ]
                    ] 
                    face/dirty?: true
                ] 
                left [
                    any [
                        auto-tab-move 
                        face 
                        event 
                        head? caret 
                        find-style/reverse face face/style 
                        tail caret 
                        move event [back-word caret] [back caret] :left-hilight
                    ]
                ] 
                right [
                    any [
                        auto-tab-move 
                        face 
                        event 
                        tail? caret 
                        find-style face face/style 
                        head caret 
                        move event [next-word caret] [next caret] :right-hilight
                    ]
                ] 
                up [move event page-up [move-y face liney * 0x-1] :left-hilight] 
                down [move event page-down [move-y face liney * 0x1] :right-hilight] 
                page-up [move event [head caret] page-up :left-hilight] 
                page-down [move event [tail caret] page-down :right-hilight] 
                home [move event [head caret] [beg-of-line caret] :left-hilight] 
                end [move event [tail caret] [end-of-line caret] :right-hilight] 
                enter [
                    either flag-face? face return [
                        if flag-face? face hide swap-text 
                        act-face face event 'on-return 
                        if empty? face/text [clear-face face]
                    ] [
                        insert-char face newline
                    ]
                ] 
                copy-text [copy-text face unlight-text] 
                cut-text [copy-text face delete-selected-text face/dirty?: true] 
                paste-text [
                    delete-selected-text 
                    face/line-list: none 
                    face/dirty?: true 
                    caret: insert caret read clipboard://
                ] 
                clear-tail [
                    remove/part caret end-of-line caret 
                    face/dirty?: true
                ] 
                all-text [hilight-all face] 
                tab-char [
                    case [
                        any [
                            flag-face? face full-text-edit 
                            flag-face? compound-face? face full-text-edit
                        ] [
                            either event/control [
                                act-face face event 'on-tab 
                                if empty? face/text [clear-face face]
                            ] [
                                insert-char face tab
                            ]
                        ] 
                        any [
                            flag-face? face tabbed 
                            flag-face? compound-face? face tabbed
                        ] [
                            act-face face event 'on-tab 
                            if empty? face/text [clear-face face]
                        ] 
                        true [
                            insert-char face tab
                        ]
                    ]
                ] 
                escape [
                    if flag-face? face hide swap-text 
                    unfocus
                ]
            ] key
        ] 
        if face: focal-face [
            if flag-face? face hide [
                unlight-text 
                insert/dup clear face/data "*" length? face/text 
                do swap-text
            ] 
            tmp: any [caret-to-offset face caret caret-to-offset face caret: tail face/text] 
            tmp: tmp - (face-edge / 2) 
            tmp2: face/para/scroll 
            all [tmp/x < 0 tmp2/x < 0 face/para/scroll/x: tmp2/x - tmp/x] 
            all [tmp/y < 0 tmp2/y < 0 face/para/scroll/y: tmp2/y - tmp/y] 
            action: face-size - tmp - face/para/margin 
            if action/x < 5 [face/para/scroll/x: tmp2/x + action/x - 5] 
            if action/y < liney [face/para/scroll/y: tmp2/y + action/y - liney] 
            set-text-body face caret 
            act-face face event 'on-key 
            show face
        ]
    ] 
    edit: make face/feel [
        redraw: func [face act pos] [
            if all [in face 'colors block? face/colors] [
                face/color: pick face/colors face <> focal-face
            ]
        ] 
        engage: func [face act event] [
            switch act [
                down [
                    either equal? face focal-face [unlight-text] [focus/no-show face] 
                    unless flag-face? face keep [
                        caret: offset-to-caret face event/offset
                    ] 
                    show face 
                    act-face face event 'on-click 
                    set-text-body face caret
                ] 
                over [
                    if not-equal? caret offset-to-caret face event/offset [
                        unless highlight-start [highlight-start: caret] 
                        highlight-end: caret: offset-to-caret face event/offset 
                        show face
                    ]
                ] 
                key [
                    edit-text face event get in face 'action
                ]
            ]
        ]
    ] 
    swipe: make face/feel [
        engage: func [face act event] [
            switch act [
                down [
                    either equal? face focal-face [unlight-text] [focus/no-show face] 
                    unless flag-face? face keep [
                        caret: offset-to-caret face event/offset
                    ] 
                    show face 
                    set-text-body face caret 
                    face/action face get-face face
                ] 
                up [
                    if highlight-start = highlight-end [unfocus]
                ] 
                over [
                    if not-equal? caret offset-to-caret face event/offset [
                        unless highlight-start [highlight-start: caret] 
                        highlight-end: caret: offset-to-caret face event/offset 
                        show face
                    ]
                ] 
                key [
                    if 'copy-text = select keymap event/key [
                        copy-text face unlight-text
                    ]
                ]
            ]
        ]
    ]
] 
ctx-text: context bind ctx-text system/view 
foreach word [hilight-text hilight-all unlight-text] [
    set word get in ctx-text word
] 
--- "VID Functions" 
set-parent-faces: func [
    {Sets parent-face correctly for all subfaces in a face.} 
    face 
    /parent pf
] [
    if parent [
        face/parent-face: pf 
        face/level: pf/level + 1
    ] 
    case [
        function? get in face 'pane [] 
        all [in face 'panes block? face/panes] [
            foreach [w p] face/panes [
                either object? p [
                    set-parent-faces/parent p face
                ] [
                    foreach fc p [
                        set-parent-faces/parent fc face
                    ]
                ]
            ]
        ] 
        block? face/pane [
            foreach fc face/pane [
                set-parent-faces/parent fc face
            ]
        ] 
        object? face/pane [
            set-parent-faces/parent face/pane face
        ]
    ]
] 
click-face: func [
    "Simulate a mouse click" 
    face 
    /alt 
    /local down up
] [
    alt: to-logic alt 
    down: pick [alt-down down] alt 
    up: pick [alt-up up] alt 
    if all [in face 'feel face/feel in face/feel 'engage] [
        face/feel/engage face down none 
        face/feel/engage face up none
    ]
] 
describe-face: func [
    {Small dump of face characteristics for error messages.} 
    face
] [
    either object? face [
        to-string reduce [
            "'" 
            any [
                all [
                    in face 'style 
                    face/style
                ] 
                all [
                    in face 'var 
                    face/var
                ]
            ] 
            "' named: '" 
            face/text 
            "' at: " 
            face/offset 
            " size: " 
            face/size
        ]
    ] [
        reform ["Unknown face" type? face]
    ]
] 
root-face: func [
    "Finds the root face for a given face." 
    face
] [
    while [
        all [
            face 
            face/parent-face 
            in face 'style 
            face/style <> 'window
        ]
    ] [
        face: face/parent-face
    ] 
    face
] 
find-face: func [
    {Returns the pane in which a face exists at the given index.} 
    [catch] 
    face 
    /panes idx 
    /local f fpp
] [
    fp: face/parent-face 
    fpp: 
    either panes [
        pick get in fp 'panes idx
    ] [
        get in fp 'pane
    ] 
    case [
        'window = attempt [get in face 'style] [
            f: find system/view/screen-face/pane face 
            if none? f [
                err-face: face 
                throw make error! reform [
                    "Window" 
                    describe-face face 
                    "does not belong to screen-face."
                ]
            ]
        ] 
        iterated-face? fp [
            f: face
        ] 
        block? fpp [
            f: find fr: fpp face 
            if none? f [
                err-face: face 
                throw make error! reform [
                    "Face" 
                    describe-face face 
                    "has incorrect parent-face."
                ]
            ]
        ] 
        object? fpp [
            f: face
        ] 
        none? fpp [
            err-face: face 
            throw make error! reform [
                "Parent-face for face" 
                describe-face face 
                "has no pane."
            ]
        ]
    ] 
    f
] 
next-pane-face: func [
    "Returns the next face in a pane." 
    [catch] 
    face [object!]
] [
] 
next-face: func [
    "Returns the face after this one in the pane." 
    [catch] 
    face [object!] 
    /deep "Traverse deeply into subpanes." 
    /panes idx "Traverse all panes in a panel." 
    /local f fp fpi root-face val
] [
    idx: any [idx 2] 
    f: false 
    if face/parent-face [
        f: 
        either panes [
            find-face/panes face idx
        ] [
            find-face face
        ]
    ] 
    either deep [
        either iterated-face? face [
            fp: iterated-pane face 
            if fp [return fp]
        ] [
            either all [panes in face 'panes] [
                fpi: face/panes/:idx 
                if all [block? fpi not empty? fpi] [return fpi/1] 
                if object? fpi [return fpi]
            ] [
                if all [block? face/pane not empty? face/pane] [return face/pane/1] 
                if object? face/pane [return face/pane]
            ]
        ] 
        if any [object? f tail? next f] [
            fp: face 
            root-face: none 
            return until [
                until [
                    fp: fp/parent-face 
                    any [
                        all [none? fp/parent-face root-face: fp] 
                        block? get in fp/parent-face 'pane
                    ]
                ] 
                any [
                    root-face 
                    either panes [next-face/deep/panes fp idx + 2] [next-face fp]
                ]
            ]
        ] 
        second f
    ] [
        either object? f [
            f
        ] [
            unless tail? next f [second f]
        ]
    ]
] 
get-tip-face: func [
    {Returns the last face in the innermost pane of a face.} 
    face 
    /local fp fpp tip-face
] [
    if iterated-face? face [return get-tip-face iterated-pane face] 
    if object? face/pane [return get-tip-face face/pane] 
    if none? face/pane [return face] 
    if all [block? face/pane empty? face/pane] [return face] 
    fp: last face/pane 
    tip-face: none 
    until [
        fpp: get in fp 'pane 
        case [
            object? :fpp [fp: :fpp] 
            all [block? :fpp not empty? :fpp] [fp: last :fpp] 
            true [tip-face: fp]
        ] 
        tip-face
    ]
] 
back-face: func [
    "Returns the face before this one in the pane." 
    [catch] 
    face 
    /deep 
    /local f fpp
] [
    f: false 
    either face/parent-face [
        f: find-face face
    ] [
        return get-tip-face face
    ] 
    either deep [
        if object? f [return face/parent-face] 
        if head? f [return face/parent-face] 
        if get in first back f 'pane [return get-tip-face first back f] 
        first back f
    ] [
        either object? f [f] [first back f]
    ]
] 
traverse-face: func [
    {Traverses a pane for a face deeply and lets you perform a function on each face.} 
    face [object!] 
    action 
    /local func-act last-face
] [
    unless get in face 'pane [exit] 
    if all [block? face/pane empty? face/pane] [exit] 
    last-face: get-tip-face face 
    func-act: func [face] action 
    until [
        face: next-face/deep face 
        func-act face 
        same? last-face face
    ]
] 
ascend-face: func [
    {Traverses through parent faces and performs an action on each parent.} 
    face [object!] 
    action 
    /local func-act
] [
    func-act: func [face] action 
    while [face/parent-face] [
        func-act face/parent-face 
        face: face/parent-face
    ]
] 
over-face: func [
    {Returns the face the mouse is currently hovering over.} 
    face [object!] {The face we are checking where the mouse is hovering.} 
    offset [pair!] "The current mouse offset in relation to the face." 
    /local fc
] [
    fc: face 
    until [
        face: back-face/deep face 
        any [
            all [
                face/style <> 'highlight 
                face/size <> 0x0 
                face/show? 
                inside? offset face/win-offset 
                inside? face/win-offset + face/size offset
            ] 
            fc = face
        ]
    ] 
    face
] 
within-face?: func [
    {Returns whether a face exists inside the pane of another face.} 
    child [object!] 
    parent [object!] 
    /local result
] [
    result: false 
    traverse-face parent [result: any [result face = child]] 
    to-logic result
] 
find-relative-face: func [
    {Returns the next face from specific criteria relative to this one.} 
    [catch] 
    face 
    criteria 
    /reverse "Search backwards" 
    /local f same result
] [
    f: face 
    until [
        face: either reverse [
            back-face/deep face
        ] [
            next-face/deep face
        ] 
        unless object? face [
            err-face: face 
            throw make error! "Found face is not an object."
        ] 
        any [
            face = f 
            either error? set/any 'result try [do bind criteria 'f] [
                probe disarm result 
                throw make error! "FIND-RELATIVE-FACE error"
            ] [
                result
            ]
        ]
    ] 
    if any [
        face <> f
    ] [
        face
    ]
] 
find-style: func [
    {Finds a face with a particular style relative to this face.} 
    face 
    style 
    /reverse 
    /local blk
] [
    blk: compose/deep [all [in face 'style face/style = (to-lit-word style)]] 
    either reverse [
        find-relative-face/reverse face blk
    ] [
        find-relative-face face blk
    ]
] 
iterated-face?: func [[catch] face] [
    if none? face [
        throw make error! "Iterated face does not exist."
    ] 
    if flag-face? face iterated [
        if none? get in face 'pane [
            throw make error! reform [
                "Iterated face" describe-face face "has no pane function."
            ]
        ] 
        true
    ]
] 
compound-face?: func [face] [
    compound-face: face 
    ascend-face face [
        all [
            flag-face? face 'compound 
            compound-face: face
        ]
    ] 
    compound-face
] 
visible-face?: func [face] [
    while [all [face/show? face/parent-face]] [
        face: face/parent-face
    ] 
    face/show?
] 
iterated-pane: func [face] [face/pane face 1] 
get-pane: func [face] [
    either object? face/pane [
        face/pane/pane
    ] [
        face/pane
    ]
] 
focus-default-input: func [
    {Focuses the first INPUT face with DEFAULT flag set.} 
    face 
    /local input-face
] [
    traverse-face face [
        all [
            flag-face? face default 
            flag-face? face input 
            flag-face? face tabbed 
            input-face: face 
            break
        ]
    ] 
    if input-face [
        set-tab-face focus input-face
    ] 
    input-face
] 
focus-first-input: func [
    "Focuses the first TABBED INPUT face in a face." 
    face 
    /local input-face
] [
    traverse-face face [
        all [
            flag-face? face input 
            flag-face? face tabbed 
            input-face: face 
            break
        ]
    ] 
    if input-face [
        describe-face input-face 
        set-tab-face focus input-face
    ] 
    input-face
] 
focus-first-false: func [
    "Focuses the first FALSE button" 
    face
] [
    input-face: find-flag face close-false 
    if input-face [
        set-tab-face focus input-face
    ] 
    input-face
] 
flag-face: func [
    "Sets a flag in a VID face." 
    face [object!] 
    'flag
] [
    unless in face 'flags [exit] 
    if none? face/flags [
        face/flags: copy [flags]
    ] 
    unless find face/flags 'flags [
        face/flags: copy face/flags insert face/flags 'flags
    ] 
    unless find face/flags flag [
        append face/flags flag
    ]
] 
flag-face?: func [
    "Checks a flag in a VID face." 
    face [object!] 'flag
] [
    all [
        in face 'flags 
        face/flags 
        find face/flags flag
    ]
] 
find-flag: func [
    {Finds a face with a particular flag relative to this face.} 
    face 
    'flag 
    /reverse 
    /local blk
] [
    blk: compose [flag-face? face (flag)] 
    either reverse [
        find-relative-face/reverse face blk
    ] [
        find-relative-face face blk
    ]
] 
save-flags: func [
    "Saves the flags in SAVED-FLAGS for the face." 
    face
] [
    if block? face/flags [
        face/saved-flags: copy face/flags
    ]
] 
restore-flags: func [
    "Restores the flags from SAVED-FLAGS for the face." 
    face
] [
    if block? face/saved-flags [
        face/flags: copy face/saved-flags
    ]
] 
save-face: func [
    {Saves the content of a face being edited and which is FOCAL-FACE.} 
    face 
    /no-show "Do not show change yet."
] [
    if all [
        access: get in face 'access 
        in access 'save-face*
    ] [
        access/save-face* face
    ] 
    unless no-show [show face] 
    face
] 
ctx-validate: context [
    result: true 
    all-result: true 
    val-face: none 
    valid: none 
    validate?: func [face /local valid] [all [valid: get in face 'valid object? :valid :valid]] 
    show-indicator: func [face] [
        val-face: next-face face 
        all [
            val-face 
            in val-face 'style 
            val-face/style = 'valid-indicator 
            set-face val-face valid/result
        ]
    ] 
    validate-init-face-func: func [face] [
        either flag-face? face panel [
            traverse-face face [
                validate-init-face-func face
            ]
        ] [
            if valid: validate? face [
                valid/result: 
                either flag-face? face disabled [
                    'not-required
                ] [
                    pick 
                    either valid/required [
                        [valid required]
                    ] [
                        [valid not-required]
                    ] 
                    result: to-logic valid/action face
                ] 
                show-indicator face 
                if 'invalid = valid/result [all-result: false]
            ]
        ] 
        act-face face none 'on-init-validate
    ] 
    set 'validate-init-face func [
        "Initializes a face or panel for validation" 
        face
    ] [
        all-result: true 
        validate-init-face-func face 
        all-result
    ] 
    validate-face-func: func [face /no-show] [
        either flag-face? face panel [
            traverse-face face [
                either no-show [
                    validate-face-func/no-show face
                ] [
                    validate-face-func face
                ]
            ]
        ] [
            if valid: validate? face [
                valid/result: 
                either flag-face? face disabled [
                    'not-required
                ] [
                    if system/view/focal-face = face [do-face face none] 
                    pick 
                    either valid/required [
                        [valid invalid]
                    ] [
                        [valid not-required]
                    ] 
                    result: to-logic valid/action face
                ] 
                any [no-show show-indicator face] 
                if 'invalid = valid/result [all-result: false]
            ]
        ] 
        act-face face none 'on-validate
    ] 
    set 'validate-face func [
        "Performs validation on a face" 
        face 
        /no-show "Do not show change yet."
    ] [
        all-result: true 
        either no-show [
            validate-face-func/no-show face
        ] [
            validate-face-func face
        ] 
        all-result
    ] 
    set 'init-enablers func [
        "Sets the fields that belongs to the enablers" 
        face
    ] [
        traverse-face face [
            all [
                in face 'style 
                face/style = 'enabler 
                nf: next-face face 
                either get-face face [
                    enable-face nf
                ] [
                    disable-face nf
                ]
            ]
        ]
    ]
] 
save-feel: func [
    {Saves the FEEL object for a face and places a different one in its place.} 
    face 
    new-feel
] [
    face/saved-feel: face/feel 
    face/feel: new-feel
] 
restore-feel: func [
    {Restores the FEEL object stored in SAVED-FEEL for a face.} 
    face
] [
    if face/saved-feel [face/feel: face/saved-feel]
] 
save-font: func [
    {Saves the common FONT object for a face and places a different one in its place.} 
    face 
    new-font
] [
    face/saved-font: face/font 
    face/font: new-font
] 
restore-font: func [
    {Restores the FONT object stored in SAVED-FONT for a face.} 
    face
] [
    if face/saved-font [face/font: face/saved-font]
] 
set-face-path: func [
    {Sets the face path for a specific panel with the PANEL flag.} 
    [catch] 
    face 
    path 
    /no-show "Do not show change yet."
] [
    unless flag-face? face panel [
        throw make error! "SET-FACE-PATH: Face does not have PANEL flag."
    ] 
    all [
        in face 'access 
        in face/access 'set-face-path*
    ] [
        access/set-face-path* face
    ] 
    unless no-show [show face] 
    face
] 
get-face-path: func [
    {Gets the face path for a specific panel with the PANEL flag.} 
    [catch] 
    face
] [
    unless flag-face? face panel [
        throw make error! "GET-FACE-PATH: Face does not have PANEL flag."
    ] 
    all [
        in face 'access 
        in face/access 'get-face-path*
    ] [
        face/access/get-face-path* face
    ]
] 
freeze-face: func [
    "Freezes a face or a panel of faces." 
    face 
    /no-show "Do not show change yet."
] [
    if same? face get-tab-face face [
        unfocus 
        unset-tab-face face
    ] 
    either any [flag-face? face panel iterated-face? face] [
        save-flags face 
        flag-face face frozen 
        deflag-face face tabbed 
        traverse-face face [
            freeze-face/no-show face
        ]
    ] [
        unless flag-face? face frozen [
            save-flags face 
            deflag-face face tabbed 
            flag-face face frozen 
            save-feel face make face/feel [over: engage: detect: none] 
            act-face face none 'on-freeze
        ]
    ] 
    unless no-show [show face]
] 
thaw-face: func [
    "Thaws a face or a panel of faces." 
    face 
    /no-show "Do not show change yet."
] [
    either flag-face? face panel [
        restore-flags face 
        traverse-face face [thaw-face/no-show face]
    ] [
        if flag-face? face frozen [
            restore-flags face 
            restore-feel face 
            act-face face none 'on-thaw
        ]
    ] 
    unless no-show [show face]
] 
get-default-face: func [
    "Gets the default face for a window." 
    window
] [
    find-relative-face window [
        all [in face 'default face/default]
    ]
] 
set-default-face: func [
    {Sets a face as the default face in a window. Clears existing default face.} 
    face 
    parent 
    /local old-face
] [
    old-face: get-default-face parent
] 
dirty-face?: func [
    {Detects if a face or any of its subfaces are dirty.} 
    face 
    /local result
] [
    result: false 
    traverse-face face [
        all [
            flag-face? face changes 
            in face 'dirty? 
            result: result and face/dirty?
        ]
    ] 
    result
] 
clean-face: func [
    "Cleans dirty face and all its subfaces." 
    face
] [
    traverse-face face [
        all [
            in face 'dirty? 
            face/dirty?: false
        ]
    ]
] 
adjust-face-scrollers: func [
    face 
    pane 
    /local fo fs fps fpsd
] [
    fo: face/offset 
    fs: face/size 
    fps: face-size face/parent-face 
    foreach fc pane [
        if fc/style = 'scroller [
            fc/ratio: divide max 1 fps/(fc/axis) max 1 max fps/(fc/axis) fs/(fc/axis)
        ]
    ]
] 
edge-size: func [face] [
    any [
        all [
            in face 'edge 
            object? face/edge 
            in face/edge 'size 
            face/edge/size
        ] 
        0x0
    ]
] 
face-size: func [face] [
    face/size - (2 * edge-size face)
] 
face-span: func [face] [
    face/size + face/offset
] 
--- "REBOL/View: Built-In Images" 
load-stock: func [
    {Load and return stock image. (Keep cache after first load)} 
    name 
    /block size 
    /local image
] [
    unless image: find system/view/vid/image-stock name [
        make error! reform ["Image not in stock:" name]
    ] 
    either block [
        block: copy [] 
        loop size [
            unless image? second image [change next image load second image] 
            append block second image 
            image: skip image 3
        ] 
        return block
    ] [
        unless image? second image [change next image load second image] 
        return second image
    ]
] 
load-stock-block: func [
    {Load a block of stock image names. Return block of images.} 
    block /local list
] [
    list: copy [] 
    foreach name block [append list load-stock name] 
    list
] 
system/view/vid/image-stock: [
    logo 64#{
R0lGODlhZAAYANQdAAICAoWFhcPDw0RERCUlJaWlpePj42NjYxQUFJSUlNTU1DQ0
NLW1tfX19XNzc1JSUgsLC4yMjMvLy0tLSy0tLaurq+zs7GxsbBwcHJubm93d3T09
Pb29vf7+/nx8fFpaWiwAAAAAZAAYAAAF/yCBjGRpnmiqrifmWF0sx9LE3ogI7Hzv
/8CgcOjbCGZIWQFBJEKYzah02nvAklgJgeobcb/gKnYcU0C/3rB6SriSsZVwmrcZ
2O8bjHBx7w8oPxAbg4QbgEEVWAYcFQwKYx8+gnaHQHMAEBpYDRlBHGNxPgQNWAJ6
RUkaBxA8ghJJEqKkHZ1Bl5lkAUBHWAw/BGQcrD0ZSBynksVIEz3AMbWWZ5iaHTUT
DrMKQJ8dFhcH4AcDv7MJAxPcHVs8GG4dBsi7SL48o89Ct9T0AI8dGsM9uGloYq/D
gR0eYjSINwCJhx4YJlQC8ACJhTMFof3IF0MABQoeZu0LqLBAhpMFLv+Qi8HAQQAY
DR72+IBkQz1NFsbtgGAASaWM+KThwmJhwbYxI3cURCJAGoALMxbySEijB4Oa9WZp
7CKUmjGjR2MYGDs2wcp3EhRkW7cDqgypOyLIMAAw0QybSrUG7TFUwARqBpiFNYAA
gmGAzWY52NEwhswdB3zymCBDF49+MsACAGqrK0sAjd/F4yGQ4KyDACjI0Eh5Buod
DwK8BrAASQOMejvz1beDVwfLPrhZ8ODAg/EHZwUkyOD18WYkEhD/KAA9cQwNBSpU
KDCRYwcOjGVYGA3A97xfZBSw3ZEuhtkgDpKorDdG5w7v+67GiPCj/YxQzRhgwYAD
GiBABE4BQNN2PJrdp8wMhDVTXw+XAFDHH/Xc0eAOC0zg4YcebnifCdLxhdlbAmQQ
QQIM9JQEcDtN8MCMND4gTYVr5AhEa29gYQYYOOooJA9y9WibfVwEOeSQCRj5FnJy
JLjkkiEZqQGUYUAgAg5cdunlCAPoR1QCW35ZAgEhAAAh/h9PcHRpbWl6ZWQgYnkg
VWxlYWQgU21hcnRTYXZlciEAADs=
} 0 
    icon-image 64#{
R0lGODlhMAAwAOUhAAICAneCkT1IT2BhYiYsLLy8uVBbZGJpfoWNo0FCQi04OxgZ
G01PUaenpml2g2JyelJcal9ldJCcsa6aeujo5SEiInN8kS8yNIqKiUVPVzZARWts
b0xVYFpmchMTE4yVr2FreP7+/MzMyJ+pv5iYlrKyrvLy6nJycoKLnnuGmTtGSQ4O
DsbGxJmguENJUyoxNVddZGZoaSMlKgoLC8XFvomTpzM6QFVVVW95idbS0nx8ekdH
RWdwgDtASBofIFdgbCwAAAAAMAAwAAAG/8CJcEgsGo/IpHLJbDqf0Kh0WrxZGdis
dsvteneXmXEXiw0GsLK6vIlt3ubzQA1Xy+flwQVgvNw6HCoZPCARDg44iTgBATg8
PxwcHQ8OKTUoOIcdMDAGMIYOFntGFQkqBDIqBpEGED8QEAatHAIvLxouLhwPFg6A
GS4ZkRzAHCAEfEWlNgQKNgIcq9GrBiCIPKEpKRYWKAgOPxkZP9Q/HRkGOMikCQYC
AjYqGuLiEDzaES4KCrY2LhEIRkjAIQuQABUuIP1AMUpZggcGMtjgt++CAUQGbHjY
uAIAgBkeKmjggQJFChzhNGhQEalDjYZESpnjcKHCC2fpDLzw4LGnT/+PHmxkcPDB
QqAe0IZKgDmkFIxzBC74A2EBhoyOP7N6nPGCRw0cwyLiWJosZgIeHTQ00wAiAAQf
WuP2rADQgQFIBgJ8YCqkFI4Mtl4YSPEDrtzDCxaeQxcAwYuyTRNAmGjDBlrDhw/7
oAqBAwQHKB6zyyBPAYcDNg6D9IAVwIIKrQFoSMGDww8cLyH3TRBoYgQOsX962NCg
wYkZMk40KEBiD9AOKVZ55TuhFAcNLwTgEHC4QoEQIXLo+A4+RIkKPXvUAJEBhDrd
1RMAJtABxwLNJUKYMFF+fwgKDPS0QCE2GCMDfKXsowJtmfmQH38UlECBfv/t4BMH
DiTUwYGjZQD/wQc/NJiffjrIQEJ5GPDUkwsIrJIBeuxEAAEIEqSGH3giIFNBDBgM
cJ9PMqAgQDAwOgTCAQ/UgN6NIdDw40daeWDUDz9w6FAmICDwZFwOgkfDknKtEN1d
Vpp1EkBgcjnil5ktYMFBAhRpJg4g1GDjT0922WSaWr0QXQZxIpiABQ9kGcFPFzTA
QnMA6MnmYQag8IoBZUbmQAReoeCTd+UVsMACa/Ip3AEgCIBOpbvB8ApuB3rEAHgQ
7uBBqIe98JdUgcYIjAHr9bQDrP8lMCt4LIjq0w8paHCBM3Cxwx5CerXqwYngkbDC
AuSJYKxHPmwjgALLNusQD+4IcEALFgg4/0CPPK2QwBk7BNfTDJEGAIMGE4lrViys
BCABBz7Jm5kBCNzzlwYK6BtZNObgkEILI2SQmVzqWZBOAOdsKOgDPHRc6D3JTpyV
ehJ08AMIPHD8g5yRtfXBByg0gkNAPGyJ2A8StJACCNQAygGq8aElizDCGGBwBjbj
mYFeEiCQAji6FAR0KSogpAum2GDTGAIHuPDCAjOAVIENEFhwUgoSSFCD0xac08OL
giprwzw84MBNI9jYbZIFdvPNQwSbjMPDAb6gk4EGAlQZ9zsGQGfJNg6AYHIHgKig
QA9IiXMXLUgJ8sPfDE+dAC62OVBD2gjQSXksqwiAFCsnH9CBLLJ8/kN0NBCwLIQH
F9wCzQ+84GAyMcAIw3kPLvQwzw8yZoC5Bj18/kPn9xnR6EbYZ6/99tx3z9EM8Iks
/vhUlG/++einz0QQACH+H09wdGltaXplZCBieSBVbGVhZCBTbWFydFNhdmVyIQAA
Ow==
} 0 
    btn-up 64#{
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAOCAYAAADjXQYbAAAAE3RFWHRTb2Z0d2Fy
ZQBSRUJPTC9WaWV3j9kWeAAAAHFJREFUeJxt0KsNQCEMhWFmYgY2ZhM2QCBqEBgS
DJfT5PC8JL/pV0yNGc85Z0d9y5od9jcXCK21Wa1VFxQ5QKWUnnNeSEAAETkRPxAg
xrgQ2wwQQniRvw7EkP1iSkl7EAMGOJAD5L3XiHo+DgnPfe/Df37VC78nAOT0AAAA
AElFTkSuQmCC
} 0 
    btn-dn 64#{
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAOCAYAAADjXQYbAAAAE3RFWHRTb2Z0d2Fy
ZQBSRUJPTC9WaWV3j9kWeAAAAE9JREFUeJxjYAACFxcXIyD+j4SNGJAlNm/eDMdw
BegSyApQJC9duvT/4cOHYIwiCZIYKEmYAqyuhWHijYUJvnz5EkUSHHwgQRjGGr7o
AQ8AhL78UJZD9twAAAAASUVORK5CYII=
} 0 
    btn-hover 64#{
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAOCAYAAADjXQYbAAAAE3RFWHRTb2Z0d2Fy
ZQBSRUJPTC9WaWV3j9kWeAAAAFFJREFUeJxjYCAG/Ls/6z8MY0j8uVQFxygKYJIg
NmmSMOPQ2WDw63jifxBGZ4PBz33e/0EYnU1Y8scW0/8gjM4mXhIZo4TS0+kM/2EY
bzjDAAB5cpSRQutBMQAAAABJRU5ErkJggg==
} 0 
    exclamation 64#{
R0lGODlhMAAwAIfOAC4iBpaSioJmEpqKVlZOOlpGDuLe2q6KGr6yjkY+JrKWTkY2
Crqmar62praWNjYuFpp6FqamojYuCt7Srsqyam5WDsKmTqqOMrqaQpJ2KtLChr66
to5uFm5qVlJCCrquhraysj4uCrqmYjIqCrKieqaCFs66em5eJmZSDv7++rKOIk5K
MraaPnpeEraSKr6iQtbGnsquXopuEr62mrqiXk4+Cs7GqsLCunZyYqKemoaGemJa
Subm3raaNj42Gq6uqjYuEtbSws62ctbCkpJ2FlJGGraWMsauZi4mBp6akopqEk5G
KrqeTko+FsKuar66rqKCFjouCnZeEr6+vlZGDqqmmrq6ukI2CjIqDrqqeqaGGmZW
GrKSIr6iSqaegrqaNt7WvpqWkmJODrKOHr6ylkpCJkY6CrqqcjoyFqJ+Fqqqps62
araumrqiVsaqVnJuXtK+go6KemZiTo52MraiZu7q3rqugr62opqWjlpSPsK2inJa
EtbGilJONtrKmnp2ZtbGkoZqEl5KDuLi3r66qp5+FrqeQr6+to5yFnJqWlZCDra2
sj4yCjYqBtK+empWDlJKNnpiEraWKsqyYsbCvnpyZoqGfrKurtrSvs66dsqyZjIm
BraSJsKmSuLavrqymtrGjrKKGrqmbqqmojYuDm5WEq6OMlJCDrqmZqaCGmpSDv7+
/rqaPsquYopuFr62nlI+CtLGqmJeSurm3raaOj42HpZ2FrqWMopqFr66sjouDrqq
fqqGGrKSJsKiSrqaOkpCKko6CjoyGs62brqiWrqeRr6+upJyFra2tkIyCjYqCn5i
EraWLjImCv///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAACH5BAEAAM4ALAAAAAAwADAAAAj/AJ0JHEiwoMGDCBMqXMiw
ocOHEBfCAKTBRKaLGDNq3Mhxo5AjXXqxIWjDDyhHazRNmqSppcuXMGPKdBmjEycI
AwgO4QOHghsLQIMKHUq0KFFftwotO0FQyLBWnb7cYkb1ltWrWLNq3TqVUwkBgooQ
dGLhxS0VY9KqXcu2rVu2B1K5QrFgCUEEhr4w4zIm1IFQgAMLHky48IEDvCAsO6Xs
DUFjIrr29Vu4suXAh0sgUnWlVo6Cd1gxc8GXcuVVqFPPgfC3MmLFpzbhsGJQBFVO
k1sTTp26zB5ehjNzQMHIh5qDMzCMLq17MG/UZQRpCZ64BaxmOBYdnMKAmSROaE07
/38effrgwwegKBETRdiPhIfaeMctXvDzVeUJH+ZlS0owAAEYo5Adv4wWXnOA1fEc
AGIAJxh6aQQiSBQJILPQE/IxQ99hg2HCmwEAVIDgfkTs8V8AUzD0gWguHDhYLLxR
AoAU5x1WiAAF6JKHQ7kQM19ugunBWxUACPDgYakcU8ECWCTx0Ae0LNdXc3TwFgcA
MhyZ2DKKKNMHRIeccVtagynAWwebHHNkCRyokkwteER0RzFjimcKbwRcAQFmr0Xi
ASmJROTMBllM1eIYuvGSQmpoKAIFn1DMxQgwowjqDCF0ajglYAfYQAklNwCgioP7
9VcDEJVY6owxdow5GWCuhP8AAADKBNLaYeqJEQIkx6nagGjfbTpBHbPwwEMQy5Tg
1wFa2LJHDUj8kaKqxpBx24Ge8DaIMq74xUshEkaxQgSqDmSMj5r6BYa2ALSA5DGl
mOGDJdOWa8wrVElS2rqpDTIjYjdS0Ygc2pU70BTo0scvav5KcYBmnMFpMEFT3NGD
EfqOwYEys3YcyJaxvWHhxObapmkquOxRSil7CFBIpMQJEwbJFN/hgJTivWZdM5bQ
RvPBomCM26a4uqJrAuT+TNATLG5YqhTQ6jCy0gJNsYvQZB4W4YTAXFIv1YMyMdqG
zZoIgA4Cgk2QHQ58h9YBNxagDCQgqF1QLjRI4gJuqSBG8sgVWHxmd0FksMAJFwdA
YB0Ssgxu0BSoIBq3BA9E4LPjA31yAQQC6IqFY5gbREIGFQQzwg6hI+TFFk0QkPrr
sMcuO8kBAQAh/h9PcHRpbWl6ZWQgYnkgVWxlYWQgU21hcnRTYXZlciEAADs=
} 0 
    help 64#{
R0lGODlhMAAwAIfXAAYWEoaSjiJiSlZiXi46NsbOyhI+LlaGcqaqqm6Kfg4qHj5i
VoaqnhpSOnKaipqqoh4uJubq6hIiGi5WRqa6sj52XjJmUm52dmKGdpa2qhI2Jgoi
FhZKNipWRoKGgn6ekkJOSrq6ukp2ZlZ6bvb29jJuVkJaUoqimtLe2hoqIp6yqmJy
aiJCNh5aQq7GvmaSfhZGMl6Oepaypq66sg4iHkp+at7i3goeFipiTl5qZl6GdnKS
ho6qnnqikiY2Mp62rn6SioKmlpqeni5KQhpCMqa2rg4yJkpqXhpWQnqeku7y7kZ2
YjpmVn6CghI6LgomGiJKOiZeSkJWTvr+/jpuWk5aVnaWihZCLlqKdnaejpauphom
Iqa+tjJqUm6CemKOfhI6KhpOOn6ik7bGwhYyJmqWhlKCceLq5i5qUm6Wh5KypqK6
sZaalj5uWjpGQs7W0jpSSrK2so6WllJuZsLGwmqGfIKOilZqYiIyLrK+uuLm5vL2
9i5COkJ2ZlaCco6imtre3pamnkpWUnZ+egoaFaqururu7BYmHnJ6eiZaR0JSSvj6
+kJeVh5eRuLm4pGuoio6Nn6WjlJeWj5KRlqGdg4uIhpWPnaajBYiHqq6tkJ2YhY2
Kg4iGhpKOLa+ukp6aTZuWoammhouJqKyrmZybmqSgpqyqrK6tk5+bg4eGSpmTmJq
aV6KekZ6ZjpyXDZqVoKilhoyKnKWij5yXkZSTiZiSlpiXhY+LlaGdg4qIoqqnhpS
Ppqqph4uKpq2qhI2KgoiGoKGhkZaUtbe2maSghZGNpayqg4mHio2MqK2roKSioKm
mpqinqa2shIyJh5WQg4mGipeSv7+/hZCMpqupqq+tjJqVv///wAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAACH5BAEAANcALAAAAAAwADAAAAj/AK8JHEiwoMGDCBMqXMiw
ocOEM0Zp0QUriwNZlz6c4PWwo8BTRdToWibmUpoyL76wooTLDyUrgU55VHhqjQwe
y7KkIbbSjBlUqGrU+NSq1RIdJ2Ya9JTJ16Nll4hRQtVqFhVQ1qyVAOXK1ayuoKjo
4Kj0Wp41xnRl+WJGEyg0qgQ0mjtXQC1VqrpkhdslktKzaoKUaWstLt3DiO3irdUC
RwKPZx8lidGqhGHEmA8L2NzoWaI6DyNnwaIJjdzMqDG3sPS5IeAsuFxdTk17bgsk
uzoAYWhTDBbZtYPbbrErzARmCjNlWPZFkyrh0FeHKTZH4Q9daT6ZRg0q1JhhjhwV
/1AxYlcL1C2IF4OiDCEFNT1wgTqN2dQUafjz43+zwHzm1Z1MwwhCvjBQSh/PZeaC
fgzit4cJYZyHWAvPhDENEQEY1Ixk8tF3mAMNhmgDGQ38t0sxTtxhkAyhlNFKgphF
wOAidADSYA5OSHjYahzcwoJBuvTAiise0oUKgzbgAQAAhTAoxBO7ZIZEJwY4YwdB
yYTigBldoPYBg6QAcIwBXjCIAAAc/BfGLRqsQBA1YhDzImrRwCEJInLE4cMNneAw
DIMXoPlfA9NoIAxBPGQRQwW1oPZMMc48cQMANxhgAQoMKtHLDWGYWCgfBMHiACVE
prZacRxw0IYhMw4AwC9IeP/qTCwEZTEYKNA1UgMJM9oCwBMRemrEMQQ58IIZ1kBX
yxkMGkILAMBwoOOEu1xRCQ0EyfIFKskKB6J+ERAgprSmNmBAJaIQdAkrqJQAHRcM
CgKAAsGaGgYYCkBC0AeU1DCfcNXotwgAG9RrKge/HAMCQSccUAMVjQbHhCIgVDwJ
AAZM+58lMDgDTA4EPYDKJ8AFJ8IRwkih8iad1kbcLbnc4EFBZrTiChrCMavfEOSa
+kwnv0CzhUE7aOKKNUVmpgeDyIChMbUwVHJDFQctcTSMqTnCtBHP+HwvNBIEc5AO
WGGNmtb6IcO1qbtMI7UbCP1x82xnb931xggDc0gTCWH+UEstSSMGw5KEA5Djf0iE
YYAChAiy0CvCcQzG5GBM49+EiVtLCARsLBQJDumllyviFkq9xSAMhZBAFJYgEfro
w1kShrU3HLLKQ3UksssulrwuXHrP7MLBubXf3lEdHYQRBu/PiG4qhcVN8wvjWxjf
UQhAdNBJMZ0s33ro4FNoyS6dwABGJcCkAsEgIZTFzBxQTDNNMRx038DuuzcQBgcw
3PJLJdBIBSYE0bmyDMQOjCDCLQxggFvIT35XMAAYfuGMXDyBExJwA98MaJAA3IEF
GgihBpxhhEpUQgHH4EQqUlAFsXFQIXZYgTD4EItj0EAUkABBDmb2wh768IcPCQgA
If4fT3B0aW1pemVkIGJ5IFVsZWFkIFNtYXJ0U2F2ZXIhAAA7
} 0 
    info 64#{
R0lGODlhMAAwAIcuAKKns7a3uqywvIeRq3J8mbO0uLS3wqGovYWPqV1qjVBdgrGz
tra5w6mww5egtnmEoVRihzlJc0lWd7GytpujuYONqGZylEpZgDlIcjVDakhUdKqx
w2dzlFBehEFQejZFbjRDamh1lVFfhUNTezxMdzlJdDhIcjtLdjpKdWdzk2VwkGRv
jU1ZfTdHcP///4+Tnio2VTZFbYeJjhcdLjE/Yw8THS88Xyo1VBkgMzJAZEtXekVO
Zz9HXD9GXC85Uy47XTdGb7W4w+Tm63N5iTRCaUdTcrGytbO3waivwuPk6Wdpbxwk
OThHcTA+YkNNarCxtKquu56mu5WetYKMp+Lk6BQaKTJAZThHcDNBZyw5WSYxTTtD
WbCxs6istYCLpn6IpXWAnmRwki05WyMtSBwkOBkgMltgbIePoldkiUhXfz9PeS06
XCMsRhgfMRIWIzg7Rba2t3N8lBceLzc6Qra2tnB4jjZEbG93jDRCaCw4WR4mPDNC
aDVEays3VyUvSyQuSSgzUDA9YTZEbTdHbzJAZhgeMG93izA+YSQuSBkfMg8THm1z
hycyTx0lOxIYJWhufRsjNzk9SHp9h7a3t////wAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAACH5BAEAAJQALAAAAAAwADAAAAj/ACkJHEiwoMGDCBMqXFgQ
QACGECMaFDCAQAGJGBkaOIAggYIJGUMaZLDBwQMIESSAFCmSJIUKFi5EyKCSZUaX
MEWMiPCB5kqbDHGG0EkCBU+fQBcKJYqi6dGaSQ8uHVG0qdOeUKMOnFrV6lWkWilx
9Ur26U+gY8mWxXq25YaXQ6mqnWvWZtqmKVKsWMGixVqwN99WiNu1qYvDLl7A+PA3
a8S7VhG7kDGDhtq6jwUTnitZhiIbdNlChOwVhqLTispgmWtUtELSXnXs6NHDxw/G
rDFL1cyUNQohiIf88Ov7aJG2Ao8ggdvbN/DDShpl8N0UQwYaTtpCiSJlioXmzhEr
/6mymjoGLGK0bOEysMsUL2BSgA8Pnbz5DGL+NCpjhuAZNCKkoUZh1D3nwnjlzWXd
D2wk4sYbdBQUBwYYRBABdV4ZiCBrC7IxgyJzRGhQHRl8UCGGTWlon1odfhhiQneU
eCKGKiZoVYsgigijjBcWKN6KN2bAoIs6KhSjiT2yVqNXOL4Y0ZEzzrVkdUJ6mGNG
UCZJ1pRNFilRllL+uFqXNoFJlhioKaIHCGQCZaZVfMDghx+A0NDTkFdG9SaLVRIZ
FiV7Bomnk38G2uafAr15KKKJ8ojCoow2+sGkfeYZaUF3YJEBeg1aemlBhtAghh+J
ePppQYto0YgjhJ560COQRA3ipasGSTIrrbjmWlBAACH+H09wdGltaXplZCBieSBV
bGVhZCBTbWFydFNhdmVyIQAAOw==
} 0 
    stop 64#{
R0lGODlhMAAwAIeeACYKCpqGhnoiIn5WVlI+PtbOzlIWFpYqKsqKiq5aWpZCQjoi
Iu7q6mYeHrqurnpGRj4SEr5ycmZSUqZCQoomJoZ2dubOzlYmJpY+PtKqqjIWFvb2
9qqenl4aGs6amnY2NjIODppWVnY6OrpqanIeHpI6Or5+foIiImJKSlYeHp4qKpZS
UkYuLr6+vmpeXt7a2koWFq5OTubi4v7+/opCQi4ODrKKiloaGs6SkrZiYp5CQvby
8rq2tpImJqI2NtbCwv76+raqqtKiopJqanYqKsZ+fp4yMk42NioODp6GhnomJnpq
alpGRtrW1lYaGrZeXvLu7m4eHkYSEsJ6enZWVqpKSpZ6etaurvr6+q6iojoSErpu
bnIiIoImJl5OTkYyMnJiYvLm5pJCQqY+PioKCpaKin4iIoJaWlZCQtbS0lYWFpoq
Ko6CgjoeHoZCQurW1lYuLppeXppmZsa+vqpGRtKenloiIuLe3urm5qY6OnZmZsqO
jpZGRrqysr52dmZWVpI+Pp4uLq5SUs6WlpIqKtKmpsaCgpJGRrJaWj4iIvLq6moe
HkISEo4mJtaqqvr29q6enmIaGjYODsJ+fppSUk4WFqJCQr62tqIyMr5ubnYiIoYm
JmJOTkoyMv///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAACH5BAEAAJ4ALAAAAAAwADAAAAj/AD0JHEiwoMGDCBMqXMiw
ocOHECMWLDQIgaEiGDNqLDIlQo4YEhVmqLNnkp9MKFOqzLQlh6A8OkIevCIEx5QR
TxDp3MlTpyA6mA4okEmQ5p4IiKpMGMO0qVOmeXwEOtAIEFFPRiMIGoMpkNevYMGq
WHOAEAU+Mh0JObq1ayAVcOPKnUvW7CGJavdkaut1rl+/ZHtQWAEx716uff8qjhuY
AqUWDQ3zfbu48tgDgkNAVigZMWXLlRvH4bz2sFvQqMk2ojD6oBCSWj2jnq36hJyD
g/ZMQSR7Nu1GZkgMMYhg0gign+NOCDPjkRsKa+ZumTHjhxJCigmZaXDDoKEIT8Yk
/5a7ZgWQGU3sUJBL59EMGW2kbFLcQ1MHGAYnZeKdXO4mK9QF0QF2KvjwxgxAoAGA
E40o1ogmNzCS335jLLaGAFlQV0EUB6hwhYYAMDKfgySoocWEvFV2ABFpIIiCACYE
CEANAkRHookoVlgZISJAMQMeVGAxwwsaAMBhZY2UeGJB+qVoWSNnUEfdBp0AMOCT
SuYI2hpdJCGlHgDAsB6WODJJYWo2fAlAjaAlWSZBTepoWQ7nTdkJm2QuCeeZlk2g
yAxQ/OHeHReMiWSWZjq5WCAWUCcBAEtQd8kNBC7mpp4DxWmZB9SVAYAWDUBCHRuL
dGgponsq+td0M8yBBACaEP/CRQEIcoLnX5dqqRgdO7yXCAANdHjABwzMwAAcm9jo
VyNRGCCJQTepKpcRBwLBBABqNAhXIwOcV0AK2pK3xiYNwACCQS29pNiHM1QQ4ohw
jRsAdRxEUulYazxoIhkGPfGTD4pRUAkAAEhya7wCSEJwJYaqZkYHEBBsUAJjSKWs
XAeYscgiXZg61wEnbGyGqaoJEEnECxzkgCUHHLDGxb79VTLEAKSMkAMYNEKIyzEr
NnPELCzkQAk689wzeVQJQPMXDTkgRtEw+6aafREf8VAfh0B9NFkUQKgFAARE1MfT
O0cd2gFd3/A1GiHxcAgFjfRASA+N1G333XdTcEIUJgJL4AVRbndhhgCakGD44Ygj
vkgHlSj8x1We8EADCQ104IQamGeuOeYGVMIICAC4ALlAPDxggBQQaKH66qyvLkkN
AIAx+uy012677QEBACH+H09wdGltaXplZCBieSBVbGVhZCBTbWFydFNhdmVyIQAA
Ow==
} 0 
    check 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
FHRFWHRBdXRob3IAcm9zcy1naWxsLmNvbf6SRqsAAAA3SURBVHjaTc65EQAwCANB
CqABg91/m4xkvss2O9Gd6GFm7rdElD5SiUcVqAY0oBrQgGpAA2h/BlFFDzHRV5dq
AAAAAElFTkSuQmCC
} 0 
    check-on 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
FHRFWHRBdXRob3IAcm9zcy1naWxsLmNvbf6SRqsAAABCSURBVHjaTc7BDQAgDAJA
vyQuYKX7r6mlVuV3CSG0/qf1oZjNyZJQCqAkgC5BgEsGJEK2lZBOLRXTCYmkXz2E
/p8LyQ8NqaRJSfoAAAAASUVORK5CYII=
} 0 
    check-down 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
FHRFWHRBdXRob3IAcm9zcy1naWxsLmNvbf6SRqsAAAA7SURBVHjaTc6xDQAwCANB
BqANAvYfNLIJhO+usSy6Ez2VmfsIGBGtQpSIiFKDaiQ0yIQGENeIp/jaPy+mIA1e
lWREdgAAAABJRU5ErkJggg==
} 0 
    check-down-on 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
FHRFWHRBdXRob3IAcm9zcy1naWxsLmNvbf6SRqsAAABDSURBVHjaTc4xDgAgCANA
xw6uEuD/D5WCot0uaZqO+WfMVRFRbRGtAFoE1FJIwI5QSAmQcOrW3J2K6QIV0MKR
Pf0/NzMuDBIfO4TgAAAAAElFTkSuQmCC
} 0 
    check-hover 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
FHRFWHRBdXRob3IAcm9zcy1naWxsLmNvbf6SRqsAAABRSURBVHjaTc5bCgAhCAXQ
0Kv9tIFq3P82x0czdBHhoKBt3Gmjd/WIF0IH3nI251p7P58SJe2FXwlTpAoGDmnB
OCRSMCYXEMfAfAQRB1Fs3n++ODQI8bWz6M4AAAAASUVORK5CYII=
} 0 
    check-hover-on 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
FHRFWHRBdXRob3IAcm9zcy1naWxsLmNvbf6SRqsAAABVSURBVHjaTc4JCsAwCATA
EI8g5AM5/P8369q0REQYVtDS7yq9NY2SaIYOYmQ2xpxr2afEK22W+GWAKx8BzgRp
Ju4EiewNONUQM44x0RGLBGrF5v3nA6/+B2n+wZJbAAAAAElFTkSuQmCC
} 0 
    radio 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
AXRSTlMAQObYZgAAABR0RVh0QXV0aG9yAHJvc3MtZ2lsbC5jb23+kkarAAAAQ0lE
QVR42l3OMQ4AIAhDUfa/dFXx/tdUCSTEbi9NoGYvgFVAUhmNMecSDcuDJNyJKrFv
iQqpxJNR2HFFiXrR8G1pOw+IpAoH/3HUSAAAAABJRU5ErkJggg==
} 0 
    radio-on 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
AXRSTlMAQObYZgAAABR0RVh0QXV0aG9yAHJvc3MtZ2lsbC5jb23+kkarAAAAVElE
QVR42l3OwQ7AIAgDUI5KL72K8P+/uepmYsaJlyYFszUA7AxA8hgcI2ISF2ZuQnD3
zMSOhN5blkIwQuitPs0VvTKooC3UbqEKtNc5ceH3y/XnA/+XCIHUfbDCAAAAAElF
TkSuQmCC
} 0 
    radio-down 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
AXRSTlMAQObYZgAAABR0RVh0QXV0aG9yAHJvc3MtZ2lsbC5jb23+kkarAAAARklE
QVR42l3OwQoAIAgDUO+D3Qzr/z+0MkfRbg9RZ7YDwBSApAy6e2vEg4gkChE4o0Tv
a7hUOBLGXoQw8goLehEXX5en5wQYOAjRqD4UZwAAAABJRU5ErkJggg==
} 0 
    radio-down-on 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
AXRSTlMAQObYZgAAABR0RVh0QXV0aG9yAHJvc3MtZ2lsbC5jb23+kkarAAAAVElE
QVR42l3OSw7AIAgEUJfIJOwkg/c/aEFjazq7lwmf1ioA2glgZsewMYa74QK5iISq
ksSuVHuXiCxTnnjlJZGYNYhcIIW5thgZkTgn+OH3y/XnA6vXB5sQqqAAAAAAAElF
TkSuQmCC
} 0 
    radio-hover 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
AXRSTlMAQObYZgAAABR0RVh0QXV0aG9yAHJvc3MtZ2lsbC5jb23+kkarAAAAXUlE
QVR42lXOMQ4AIQhEUZMBLKYisXL1/tdcwLVYKl5+orSWQ7LdIX34NX126+a8wIRo
kbvP+TxLhZmiBBYkIocV1kYq2kG2RpPEBuoVV0XsuF+IQD7ULe6/287+AnsyBs+g
3sRlAAAAAElFTkSuQmCC
} 0 
    radio-hover-on 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAMAAABFNRROAAAAYFBMVEXs6dgAAADl
lwD4tDX5vkv6x2H80nr+35omfAgAmQAiwCAAM2YcUYAAZplkh9x/nbmLqeW7mVVv
eWesqJm5tanHxbLJx7rV0MTX1Mrk4tnp6OHw8Or09PD6+vj///////8AldVgAAAA
AXRSTlMAQObYZgAAABR0RVh0QXV0aG9yAHJvc3MtZ2lsbC5jb23+kkarAAAAZElE
QVR42lWOMQ7AIAwDkQg4xFOkslSF/z+zpC1DPeV0kuOUIiTTDtmPvpn9REV1bsCE
lAc5MM3sKsJQgFlrClmSR50Lmo4cFG7B6xKrXKo6JD8tXgoGJH8vXCRviC3u/tv2
3jcP8wWPGnMh1wAAAABJRU5ErkJggg==
} 0 
    arrow 64#{
iVBORw0KGgoAAAANSUhEUgAAAA0AAAANBAMAAACAxflPAAAAMFBMVEXs6dh4n+yW
tu+lvO6sxPK2yfG7zfXF1PXQ2/X///8AAAAAAAAAAAAAAAAAAAAAAADu3bw7AAAA
AXRSTlMAQObYZgAAABR0RVh0QXV0aG9yAHJvc3MtZ2lsbC5jb23+kkarAAAAQ0lE
QVR42mNgmAkEExgYOF2AwJOBYUpHe3laygQgXV4GpoHctBAgXQ6j0yB0GZB2AdJA
KhVKh4Hp0BAXkwlw86DmAwClWyTDYcm/OAAAAABJRU5ErkJggg==
} 0 
    radio-off-up 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA2ElEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGx4SHIJi7pq1a8D8nvYeMM3J
y4nVLKyCyIajG4xiC5BjYWIBF8JmCRNcFguDkOEgLSfOnMCiEyGEYQGy6xHKiGN9
//wdIzFgWAAzihjXw9Ti8wVOC2CaKaWHsQWwdE5MECEnVXT1GEGEL1eia0bnk5wP
iPEFPteDHIA1J4MkQPkBVgyA+OhJEd1gbK4H6cNpAUgSW8YBiaMDXIaD1OG1AGYQ
LovwGQzTO0oPfAgAAH/ONhrtcRpHAAAAAElFTkSuQmCC
} 0 
    radio-on-up 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA90lEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGx4SHIJi7pq1a8D8nvYeMM3J
y4nVLKyCyIajG4xiC5BjYWIBF8JmCRNcFguDkOEgLSfOnMCiEyHEgmBCWMiuR5br
3FWGzGUod+tC4YM43z9//4/uC5w+QHY9uuEgw5DF8PkCpwUgQ6gBhrEFsHQOCiZs
EYoshpxU0YMVbz5Ajmh0jch8mAXoKQikBm8cIPsC2UBkNsxwZDFkNlYfgBSA8gOs
GADx0ZMiusHYXA/Sh9MCkCQo44BoQgCX4SB9eC2AGYzLInwGw/SO0gMfAgBp2UFc
z5JNMAAAAABJRU5ErkJggg==
} 0 
    radio-off-down 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA00lEQVRIDe1UsQ6D
QAjVxsWhU/1LOzr4BzrcWP/STg6OGowYfQeUpoNJ4y0I93gPyGGSXOfsCaSeAspn
OUm47tV9zDcBGjGKWUKqAJIXj+LA27/7xQ9NWGx+z0Wu7JC1OntyJGY8xsdhnCSR
GydIFkkkTBtaKbzFIoF99RvK+UFdIDQSYICnesZaXagCnPyr/WMBfueeEdVVrcKi
EVlbqbKsF1/vgacLq3rSFdebLmgf+DdAPj5FJJaqpzxVgC6lxaE4Ho2ccKYAE2lC
FjHnXvb8Ccw8KjjUv4OCCQAAAABJRU5ErkJggg==
} 0 
    radio-on-down 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA8ElEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGy4iLIJi7pu3b8D8nvYeMM3J
y4nVLBYUXVAOsuHoBsPUo4t///z9PzZLmGAasNHohmBT09HTgU0YLobhA2TXw1UB
GSd/bUPmMpizeaHwQRxsvsDpA2TXoxsOMgxZDJ8vcFoAMoQaYBhbAEvnoGDCFqHI
YhUlFThDE2vmgKUk5IjGaQJQAmYByfkA2Re4LIAZjkseqw9AikG+gBUDID56UkQ3
GJvrQfpwWgCSBGUcEE0I4DIcpA+vBTCDcVmEz2CY3lF64EMAAFpTRBaYeG/RAAAA
AElFTkSuQmCC
} 0 
    radio-off-over 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA2ElEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGx4SHIJi7pq1a8D8nvYeMM3J
y4nVLKyCyIajG4xiC5BjYWIBF8JmCRNcFguDkOEgLSfOnMCiEyGEYQGy6xHKiGN9
//wdIzFgWAAzihjXw9Ti8wVOC2CaKaWHsQWwdE5MECEnVXT1GEGEL1eia0bnk5wP
iPEFPteDHIA1J4MkQPkBVgyA+OhJEd1gbK4H6cNpAUgSW8YBiaMDXIaD1OG1AGYQ
LovwGQzTO0oPfAgAAH/ONhrtcRpHAAAAAElFTkSuQmCC
} 0 
    radio-on-over 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAA90lEQVRIDWNgGAUD
HQKMxDggOyf7PzZ1U6dMJagfrwJcBqNbhs8inBagGx4SHIJi7pq1a8D8nvYeMM3J
y4nVLKyCyIajG4xiC5BjYWIBF8JmCRNcFguDkOEgLSfOnMCiEyHEgmBCWMiuR5br
3FWGzGUod+tC4YM43z9//4/uC5w+QHY9uuEgw5DF8PkCpwUgQ6gBhrEFsHQOCiZs
EYoshpxU0YMVbz5Ajmh0jch8mAXoKQikBm8cIPsC2UBkNsxwZDFkNlYfgBSA8gOs
GADx0ZMiusHYXA/Sh9MCkCQo44BoQgCX4SB9eC2AGYzLInwGw/SO0gMfAgBp2UFc
z5JNMAAAAABJRU5ErkJggg==
} 0 
    check-off-up 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAdklEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEgsJDsElRZI41XyA
y9ZRC3CFDFx8NIjgQYGLMRpEuEIGLk7zIMJaFuEquODOIoGBUrSC9H3//J3s4hqk
H724BomNgoENAQDhcAxcmkCxRAAAAABJRU5ErkJggg==
} 0 
    check-on-up 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAuUlEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEgsJDsElRZI41XyA
y1ayLejcVcYAwoQA2RYQMhgmT5YFMJeXu3XBzMFJk2UBTtOwSJBsASmuB9lH0AJi
IxOL48FCBC2AhTOyRTAxXIYiixO0AKSYFAORDQexceZkdIXkWkKUD9AtI4WP1Qe4
Ci5SDIapRSlaQYLfP38nu7gG6UcvrkFio2BgQwAAq0ch0Op9qFEAAAAASUVORK5C
YII=
} 0 
    check-off-down 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAdklEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEhMRFsElRZI41XyA
y9ZRC3CFDFx8NIjgQYGLMRpEuEIGLk7zIMJaFuEquODOIoGBUrSC9H3//J3s4hqk
H724BomNgoENAQDXJQucNhMGBQAAAABJRU5ErkJggg==
} 0 
    check-on-down 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAuUlEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEhMRFsElRZI41XyA
y1ayLTj5axsDCBMCZFtAyGCYPFkWwFxuzuYFMwcnTZYFOE3DIkGyBaS4HmQfQQuI
jUwsjgcLEbQAFs7IFsHEcBmKLE7QApBiUgxENhzExpmT0RWSawlRPkC3jBQ+Vh/g
KrhIMRimFqVoBQl+//yd7OIapB+9uAaJjYKBDQEA3VIikPQxHKoAAAAASUVORK5C
YII=
} 0 
    check-off-over 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAdklEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEgsJDsElRZI41XyA
y9ZRC3CFDFx8NIjgQYGLMRpEuEIGLk7zIMJaFuEquODOIoGBUrSC9H3//J3s4hqk
H724BomNgoENAQDhcAxcmkCxRAAAAABJRU5ErkJggg==
} 0 
    check-on-over 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAuUlEQVRIDWNgGAUD
HQKM6A7Izsn+jy5GLL+nvYeBk5cTxUwmYjUTUgcyHBtgwSYIEgsJDsElRZI41XyA
y1ayLejcVcYAwoQA2RYQMhgmT5YFMJeXu3XBzMFJk2UBTtOwSJBsASmuB9lH0AJi
IxOL48FCBC2AhTOyRTAxXIYiixO0AKSYFAORDQexceZkdIXkWkKUD9AtI4WP1Qe4
Ci5SDIapRSlaQYLfP38nu7gG6UcvrkFio2BgQwAAq0ch0Op9qFEAAAAASUVORK5C
YII=
} 0 
    arrow-up 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAYElEQVQ4Ee2QwQ4A
EAxDx4/7dOYwQbRzcCGWLIS2e5nIr2s3kJS89rHKmlTbregqRjKXMmwEzmTU4xGu
iFZvjYtOU9VMZ0boY4SMBP7BSYSOUiJCSGBpeu5oOvm/vrOBAjwmCgA8sTKWAAAA
AElFTkSuQmCC
} 0 
    arrow-down 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAe0lEQVQ4Ee1QQQ7A
IAhz2cf42XjafNlGE5IZBeSw7DKbEA2lpVrKwn9/4JCnX5PCzIBt6DwNGEYwtXuk
EI4cnqVfLc7c0gx6KV3dLCG8qVmAK0uZ6UC6m0Aq+pShJpMQvqTmLKebTmdSB1L2
SU1hNiHEp9Qr6WC28OEP3ItvFAjuOlTvAAAAAElFTkSuQmCC
} 0 
    arrow-left 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAASUlEQVQ4EWNgGAXD
JgTqqeUTkEH/oZgiM5ENoshAbAaRZSA+g/AayERRQJChGZ9LyTAOoQWbwQhZCljI
BlNgDKZWkMGjYKiEAACQmiRajiKaMAAAAABJRU5ErkJggg==
} 0 
    arrow-right 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAU0lEQVQ4Ee3QywoA
IAhEUenH+/Qei7sZxEUJERjEIMJBxqzeVw307GvHAvdPgwHJaxhI8xhWSGcXbtnF
R55exOxeFkHsAMhjSMFrCDANAqx81MAEzW0kWprqwgUAAAAASUVORK5CYII=
} 0 
    arrow-pop 64#{
iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAiklEQVQ4Ec3QAQ6A
IAgFUGrdu6NXLJmBfKDNrdxKQXxDiYj265s21mlSgz4Fj8ptqh0KJjO0K6BFbKzw
DESHUZ4iEB5qLbn7m+pXB4sOa1HUYU0wVf8Hozd0H93ccHjn6MpDcYbxfgTyPkJR
PgU9FGJcnHXINTwEkfnOOv8q+EQdpqfegP1UsJoOnozwCqsthHqPAAAAAElFTkSu
QmCC
} 0 
    blocked 64#{
iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAATUlEQVQoFY3PMQ4A
IAhDUfH+d0Y6kJCmIAwO+J+JdvpxdWVqGTsZx94UaGM8zmCMGXzjClZxgnUMcHGI
4b9l4gq0MRSDMWbwjStYxQAPyJQMEQGHQacAAAAASUVORK5CYII=
} 0 
    tab 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAIAAABvFaqvAAAAqklEQVQ4EWPcsW0n
AzUAEzUMAZnBgmmQva0dpiCayMHDh9BE0F1EjCkPnz5k52RDMwjFRXBTFi1bhKYO
maumpgbkAs36+f0XXBzhIiJNAeq8desWRD+yu6AGEW8KxAhMs0AGkWoKVrMYv3/+
DpHAHy4QNZgkJLyADoQaRJ4pcHMvXb6ECGy4KKkMoClALVQwCGLxqEGEI2A0jIZi
GDE+ePiQsLuJUEG16AcARvMy42wzfesAAAAASUVORK5CYII=
} 0 
    tab-on 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAIAAABvFaqvAAAAoklEQVQ4EWPcsW0n
Ayqwt7VDFcDCO3j4EJooExqfGFMePn3IzsmGppEFmQ83hZOXE1kcjb1//36gCNCs
n99/waUQLiLSFKBOR0dHiH5kd0ENIt4UiBGYZoEMItUUrGYxfv/8HSKBP1wgajBJ
SHjdunUL6jXyTAGaC/Qj0JRLly8hAhvTNiJFgKYAVVLBIIh9owYRDvfRMBoNI8Ih
QFjF4EtHACtxJCSUm4qAAAAAAElFTkSuQmCC
} 0 
    validation-not-validated 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAIUlEQVRIDe3QAQ0A
AADCoPdP7ewBESgMGDBgwIABAwY+MAkYAAGvX7w8AAAAAElFTkSuQmCC
} 0 
    validation-valid 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAi0lEQVRIDe1TSQqA
MAyM4pN9hn9W5tAyCTGpolikOWjbOFslIqO+voHpEQOb7JVnFcU518ZLC6V2SyNw
D77OEyTuO0/Q4L7jBI3ukWDBQ9UFsMKdbPw5iESiniPizwGPOxM6BNmRn6CgmByi
dl++C96xAIBMykScks/NOhcAwIo0kgPq/wN0Rv3mBg6Fnxoa60sNyQAAAABJRU5E
rkJggg==
} 0 
    validation-invalid 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAmElEQVRIDe1QSQqA
MAyMvsr/n/yVMuDA0Ga7iKDm0JZklmbM/vp2ArvZUSVQYZZIQImbmYvrYEoiPzCa
qHiEQd81wCATyGbgaoUGAHlCSuZ73I593KkBAJVJJt4yyEwqcXBXHHfWsxFV+XPz
LKpwA0+cQtmMprxdg45ABwMT1wADFeDP0dfqYBQ/vVVgGl6NDibi/v2XJHACfMwp
KmRPo2gAAAAASUVORK5CYII=
} 0 
    validation-not-required 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAU0lEQVRIDWNgGAWj
ITAaAowkBMF/NLWk6EXTislFNxykApsYpk4iRPAZhE8ObDQTERZQpGToW0Cs97GF
NTYxDPNISWroBpKiF8PiUYHREBhJIQAAloIIA53MRq4AAAAASUVORK5CYII=
} 0 
    validation-required 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAATUlEQVRIDWNgGAWj
ITAaAowkBMF/NLVE6SVKEdBgdMNhdhHUT1ABHsOJsoQJpopW9NC3gJg4AIUeTSMZ
Fj3olhDrOJj+UXo0BEZsCAAAsYkFDM9z81MAAAAASUVORK5CYII=
} 0 
    validation-attention 64#{
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAdUlEQVRIDe2RQQ5A
EQxE65/K/Vdu5WdiIZFRMsSqXYig7zHMoiKBZwkUs6rIvp0mFQ72UnACXwpO4RAk
DKwUeCY8GpECZ5fEGhXMDivrVMCeqsDRM/0DbI5RKWL6AsBRCrB19tEV3JJ0nTMb
43KOxlYkcDmBH83oD2ipZrtxAAAAAElFTkSuQmCC
} 0 
    standard-edge 64#{
iVBORw0KGgoAAAANSUhEUgAAAAYAAAAGCAIAAABvrngfAAAAJ0lEQVQImWP8//8/
AxJgZGRkQuMzMDCwQDiNjY1wCRRVUIBmFnYAACaIB42fCS51AAAAAElFTkSuQmCC
} 0 
    corner 64#{
iVBORw0KGgoAAAANSUhEUgAAAAQAAAAECAYAAACp8Z5+AAAAG0lEQVQIHWP8DwQM
UMAIBEzIHDAbWQVMEoUGAITxCAR1UjwNAAAAAElFTkSuQmCC
} 0 
    checker-board 64#{
iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAIAAAACUFjqAAAAE3RFWHRTb2Z0d2Fy
ZQBSRUJPTC9WaWV3j9kWeAAAABZJREFUeJxjYEAF/1EBw0BKDya3oAIAfaqVa81d
ZBAAAAAASUVORK5CYII=
} 0
] 
comment [
    old-base: system/options/binary-base 
    system/options/binary-base: 64 
    repend system/view/vid/image-stock [
        'radio-off-up read/binary %../resources/images/radio-off-up.png 0 
        'radio-on-up read/binary %../resources/images/radio-on-up.png 0 
        'radio-off-down read/binary %../resources/images/radio-off-down.png 0 
        'radio-on-down read/binary %../resources/images/radio-on-down.png 0 
        'radio-off-over read/binary %../resources/images/radio-off-over.png 0 
        'radio-on-over read/binary %../resources/images/radio-on-over.png 0 
        'check-off-up read/binary %../resources/images/check-off-up.png 0 
        'check-on-up read/binary %../resources/images/check-on-up.png 0 
        'check-off-down read/binary %../resources/images/check-off-down.png 0 
        'check-on-down read/binary %../resources/images/check-on-down.png 0 
        'check-off-over read/binary %../resources/images/check-off-over.png 0 
        'check-on-over read/binary %../resources/images/check-on-over.png 0 
        'arrow-up read/binary %../resources/images/arrow-up.png 0 
        'arrow-down read/binary %../resources/images/arrow-down.png 0 
        'arrow-left read/binary %../resources/images/arrow-left.png 0 
        'arrow-right read/binary %../resources/images/arrow-right.png 0 
        'arrow-pop read/binary %../resources/images/arrow-pop.png 0 
        'blocked read/binary %../resources/images/blocked.png 0 
        'tab read/binary %../resources/images/tab.png 0 
        'tab-on read/binary %../resources/images/tab-on.png 0 
        'validation-not-validated read/binary %../resources/images/validation-not-validated.png 0 
        'validation-valid read/binary %../resources/images/validation-valid.png 0 
        'validation-invalid read/binary %../resources/images/validation-invalid.png 0 
        'validation-not-required read/binary %../resources/images/validation-not-required.png 0 
        'validation-required read/binary %../resources/images/validation-required.png 0 
        'validation-attention read/binary %../resources/images/validation-attention.png 0
    ] 
    system/options/binary-base: old-base 
    unset 'old-base
] 
foreach [name data flags] system/view/vid/image-stock [
    unless all [word? name binary? data integer? flags] [
        print ["Invalid image-stock for " name] 
        wait 3 quit
    ]
] 
logo.gif: load-stock 'logo 
system/view/vid/radio.bmp: load-stock 'radio 
system/view/vid/radio-on.bmp: load-stock 'radio-on 
system/view/vid/icon-image: load-stock 'icon-image 
btn-up.png: load-stock 'btn-up 
btn-dn.png: load-stock 'btn-dn 
exclamation.gif: load-stock 'exclamation 
help.gif: load-stock 'help 
info.gif: load-stock 'info 
stop.gif: load-stock 'stop 
checker-board.png: load-stock 'checker-board 
standard-edge.png: load-stock 'standard-edge 
--- "VID Text Content Formatting Context" 
ctx-content: [
    capitalize: func [face /local t] [
        t: face/text 
        forall t [
            if head? t [uppercase/part t 1] 
            if find [#" " #"-"] first t [uppercase/part t 2]
        ]
    ] 
    all-caps: func [face] [
        uppercase face/text
    ] 
    numeric-range: func [
        face range 
        /local val min-val max-val
    ] [
        unless any [
            flag-face? face integer 
            flag-face? face decimal
        ] [exit] 
        val: any [attempt [to-decimal face/text] 0] 
        min-val: first range 
        max-val: second range 
        if min-val [val: max min-val val] 
        if max-val [val: min max-val val] 
        if flag-face? face integer [val: to-integer val] 
        face/data: val 
        insert clear head face/text mold val
    ] 
    numeric-step: func [face event step-size] [
    ] 
    zero-pad: func [
        face digits
    ] [
        unless any [
            flag-face? face integer 
            flag-face? face decimal
        ] [exit] 
        change head face/text system/words/format/pad reduce [negate digits] face/text "0"
    ] 
    substitute: none 
    context [
        buffer: make string! 100 
        set 'substitute func [
            face event substitutions 
            /local lb lc txt
        ] [
            txt: copy face/text 
            either all [
                find make bitset! [#"a" - #"z" #"A" - #"Z" #"0" - #"9"] event/key
            ] [
                append buffer event/key
            ] [
                clear buffer
            ] 
            foreach [word completion] :substitutions [
                if word = buffer [
                    lb: length? buffer 
                    lc: length? completion 
                    txt: remove/part at txt subtract index? system/view/caret lb lb 
                    insert txt copy completion 
                    clear buffer 
                    change head clear face/text head txt 
                    caret: add index? txt lc
                ]
            ]
        ]
    ] 
    encrypt: func [face event] [
        face
    ] 
    auto-complete: func [face event texts /local found-text new-text start-text] [
        if find [left right up down #"^H" #"^-"] event/key [exit] 
        start-text: copy/part face/text index? system/view/caret 
        found-text: none 
        forall texts [
            if string? texts/1 [
                if find/match texts/1 start-text [found-text: copy texts/1 break]
            ]
        ] 
        texts: head texts 
        unless found-text [exit] 
        insert clear head face/text found-text 
        highlight-start: system/view/caret 
        highlight-end: tail highlight-start
    ] 
    trim-text: func [face] [
        insert clear head face/text trim face/text
    ]
] 
ctx-content: context bind bind ctx-content ctx-text system/view 
--- "List Context" 
ctx-list: context [
    data*: fspec*: soc*: sod*: dfilt*: didx*: dsort*: dadis*: out*: none 
    list-map: [data 0 filtered 0 sorted 0] 
    get-list-type: does [
        if empty? data* [return object!] 
        if first data* [return type? first data*]
    ] 
    get-count: func [face] [
        length? face/data-filtered
    ] 
    set-vars: func [face] [
        data*: face/data 
        fspec*: face/filter-spec 
        didx*: face/data-index 
        dfilt*: face/data-filtered 
        dsort*: face/data-sorted 
        soc*: face/sort-column 
        sod*: face/sort-direction 
        cor*: face/column-order 
        dadis*: face/data-display 
        out*: face/output
    ] 
    set-filtered: func [face /local i j spec-func] [
        set-vars face 
        clear dfilt* 
        insert clear didx* array/initial length? data* list-map 
        repeat i length? didx* [didx*/:i/data: i] 
        either any [none? fspec* empty? fspec*] [
            insert dfilt* data*
        ] [
            spec-func: 
            either object! = get-list-type [
                func [row] [do bind fspec* row]
            ] [
                func [row] any [fspec* [true]]
            ] 
            i: j: 0 
            foreach row data* [
                i: i + 1 
                if spec-func row [
                    j: j + 1 
                    insert/only tail dfilt* row 
                    didx*/:i/filtered: j
                ]
            ]
        ] 
        set-sorting face
    ] 
    set-sorting: func [face /local op col] [
        set-vars face 
        insert clear head dsort* dfilt* 
        if all [sod* soc*] [
            op: get select [asc lesser? desc greater?] sod* 
            switch to-word get-list-type [
                object! [
                    sort/compare dsort* func [a b] [op get in a soc* get in b soc*]
                ] 
                block! [
                    col: index? find face/row soc* 
                    sort/compare dsort* func [a b] [op pick a col pick b col]
                ]
            ] [
                either 'desc = sod* [sort/reverse dsort*] [sort dsort*]
            ]
        ] 
        set-columns face
    ] 
    set-columns: func [face /local def] [
        set-vars face 
        clear dadis* 
        def: extract face/columns 2 
        foreach idx face/column-order [
            append dadis* index? find def idx
        ] 
        set-output face
    ] 
    set-output: func [face /local val] [
        set-vars face 
        face/output: clear head face/output 
        foreach row dsort* [
            insert/only tail face/output make block! length? dadis* 
            foreach col dadis* [
                set/any 'val either block? row [pick row col] [row] 
                insert tail last face/output 
                case [
                    not value? 'val [
                        copy ""
                    ] 
                    object? val [
                        form get in val pick next first val col
                    ] 
                    any-block? val [
                        form pick val col
                    ] 
                    true [
                        form val
                    ]
                ]
            ]
        ]
    ] 
    get-cell: func [face row col /local r] [
        set-vars face 
        either col <= length? dsort* [
            r: pick dsort* row
        ] [
            unset 'r
        ] 
        col: pick dadis* col 
        case [
            not value? 'r [
                copy ""
            ] 
            object? r [
                form get in r pick next first r col
            ] 
            any-block? r [
                form pick r col
            ] 
            true [
                r
            ]
        ]
    ]
] 
--- "Scroller Management for VID" 
ctx-scroll: context [
    v-scroller-face: 
    h-scroller-face: 
    v-scroll-val-func: 
    h-scroll-val-func: 
    v-scroll-face-func: 
    h-scroll-face-func: 
    v-redrag-val-func: 
    h-redrag-val-func: 
    step-unit: 
    tmp: 
    none 
    assign-scrollers: func [face] [
        tmp: none 
        all [
            none? v-scroller-face 
            tmp: next-face face 
            in tmp 'style 
            tmp/style = 'scroller 
            v-scroller-face: tmp
        ] 
        all [
            none? h-scroller-face 
            tmp 
            tmp: next-face tmp 
            in tmp 'style 
            tmp/style = 'scroller 
            h-scroller-face: tmp
        ]
    ] 
    set-scrollers: func [face] [
        if object? v-scroller-face [set-face v-scroller-face v-scroll-val-func face] 
        if object? h-scroller-face [set-face h-scroller-face h-scroll-val-func face]
    ] 
    set-redrag: func [face] [
        if object? v-scroller-face [v-scroller-face/redrag v-redrag-val-func face] 
        if object? h-scroller-face [h-scroller-face/redrag h-redrag-val-func face]
    ] 
    set-face-scroll: func [face x y] [
        if x [h-scroll-face-func face x] 
        if y [v-scroll-face-func face y] 
        set-scrollers face
    ] 
    h-scroll-val-func: func [face] [
        either iterated-face? face [
            face/subface/offset/x / face/subface/size/x - face/size/x
        ] [
            face/pane/offset/x / face/pane/size/x - face/size/x
        ]
    ] 
    v-scroll-val-func: func [face] [
        either iterated-face? face [
            face/subface/offset/y / face/subface/size/y - face/size/y
        ] [
            face/pane/offset/y / face/pane/size/y - face/size/y
        ]
    ] 
    h-scroll-face-func: func [face x /local edge fp] [
        edge: 2 * any [attempt [face/edge/size] 0] 
        fp: either iterated-face? face [face/subface] [face/pane] 
        if all [x fp/size/x > face/size/x] [
            fp/offset/x: face/size/x - edge/x - fp/size/x * x
        ]
    ] 
    v-scroll-face-func: func [face y /local edge] [
        edge: 2 * any [attempt [face/edge/size] 0] 
        if all [y face/pane/size/y > face/size/y] [
            face/pane/offset/y: face/size/y - edge/y - face/pane/size/y * y
        ]
    ] 
    h-redrag-val-func: func [face] [
        either iterated-face? face [
            face/size/x / face/subface/size/x
        ] [
            face/size/x / face/pane/size/x
        ]
    ] 
    v-redrag-val-func: func [face] [
        either iterated-face? face [
            face/size/y / face/subface/size/y
        ] [
            face/size/y / face/pane/size/y
        ]
    ]
] 
--- "VID Focus Ring Indication" 
ctx-focus-ring: context [
    focus-edge: func [side] [
        make get-style 'face [
            size: 2x2 
            color: svvc/focus-ring-color 
            edge: none 
            style: 'highlight 
            var: side 
            flags: [] 
            show?: false 
            feel: none
        ]
    ] 
    set 'make-focus-ring does [
        reduce [
            focus-edge 'top 
            focus-edge 'left 
            focus-edge 'right 
            focus-edge 'bottom
        ]
    ] 
    set 'set-focus-ring func [face /tab-face tf /root rf /no-show /local edge offset top left right bottom fp sides] [
        any [face return face] 
        tab-face: any [tf get-tab-face face] 
        any [tab-face return face] 
        top: left: right: bottom: none 
        sides: [top left right bottom] 
        set sides get in any [rf root-face face] 'focus-ring-faces 
        if any [not in top 'style 'highlight <> get in top 'style] [return face] 
        if tab-face/style = 'window [hide :sides return face] 
        bottom/size/x: top/size/x: tab-face/size/x + 4 
        top/offset: tab-face/offset - 2 
        left/offset: tab-face/offset - 2x0 
        right/size/y: left/size/y: tab-face/size/y 
        right/offset: tab-face/size * 1x0 + tab-face/offset 
        bottom/offset: tab-face/size * 0x1 - 2x0 + tab-face/offset 
        fp: tab-face/parent-face 
        while [all [fp fp/style <> 'window]] [
            edge: any [all [in fp 'edge fp/edge fp/edge/size] 0x0] 
            offset: edge + fp/offset 
            top/offset: top/offset + offset 
            left/offset: left/offset + offset 
            right/offset: right/offset + offset 
            bottom/offset: bottom/offset + offset 
            fp: fp/parent-face
        ] 
        unless no-show [
            foreach side sides [set in get side 'show? true] 
            show :sides
        ] 
        face
    ] 
    set 'unset-focus-ring func [face /local f fc] [
        f: root-face face 
        foreach fc get in f 'focus-ring-faces [hide fc]
    ]
] 
--- "VID Menu Face" 
ctx-menu: context [
    content: none 
    menu-face: none 
    set 'make-menu-face does [
        make get-style 'face [
            size: 0x0 
            color: svvc/window-background-color 
            font: make font [color: black shadow: none size: 12] 
            edge: make face/edge [color: svvc/window-background-color size: 2x2 effect: 'bevel] 
            style: 'menu 
            flags: [scrollable] 
            show?: false 
            pop-face: none 
            feel: none 
            access: make object! [
                key-face*: func [face event] [
                    key-face face/pane/1 event
                ] 
                above: func [face] [face/offset/y < 0] 
                below: func [face] [(face/offset/y + face/size/y) > face/parent-face/size/y] 
                scroll-face*: func [face x y /local dir step-size move y-size] [
                    dir: pick [-1 1] positive? y 
                    y-size: pop-face/size/y - (2 * second edge-size pop-face) 
                    move: does [face/offset/y: y-size * dir + face/offset/y] 
                    any [
                        all [above face below face move] 
                        case [
                            above face [
                                if positive? dir [move]
                            ] 
                            below face [
                                if negative? dir [move]
                            ]
                        ]
                    ] 
                    face/offset/y: max face/offset/y (pop-face/win-offset/y + y-size - face/size/y + (2 * second edge-size face)) 
                    face/offset/y: min face/offset/y pop-face/win-offset/y
                ]
            ]
        ]
    ] 
    get-menu-face: func [face] [
        get in root-face face 'menu-face
    ] 
    set 'set-menu-face func [fc content size offset] [
        any [menu-face: get-menu-face fc exit] 
        any [block? content object? content make error! "Menu face is not of the correct type."] 
        menu-face/pane: 
        either block? content [
            layout/tight content
        ] [
            content
        ] 
        ctx-resize/do-align menu-face none 
        menu-face/pop-face: fc 
        menu-face/size: any [size menu-face/pane/size] 
        menu-face/win-offset: menu-face/offset: offset 
        menu-face/pane: menu-face/pane/pane 
        ctx-resize/align-contents menu-face 
        focus menu-face 
        show menu-face
    ] 
    set 'unset-menu-face func [pop-face] [
        any [menu-face: get-menu-face pop-face exit] 
        hide menu-face 
        focus pop-face 
        menu-face/pane: none 
        menu-face/size: menu-face/offset: 0x0
    ]
] 
--- "VID Tool Tip Face" 
ctx-tool-tip: context [
    set 'make-tool-tip does [
        make get-style 'face [
            size: 0x0 
            color: white 
            font: make font [color: black shadow: none size: 12] 
            edge: make face/edge [color: black size: 1x1] 
            style: 'tool-tip 
            flags: [] 
            show?: false 
            feel: none
        ]
    ] 
    tip-content: none 
    tool-tip-face: none 
    test-tip-face: 
    make make-tool-tip [show?: true size: 1000x40] 
    set 'get-tool-tip func [face] [
        any [face: root-face face return none] 
        foreach fc any [get in face 'pane []] [
            if fc/style = 'tool-tip [return fc]
        ]
    ] 
    set 'set-tool-tip func [fc offset /local sz] [
        any [tool-tip-face: get-tool-tip fc exit] 
        any [get in fc 'tool-tip ascend-face fc [all [get in face 'tool-tip fc: face break]]] 
        any [tip-content: get in fc 'tool-tip exit] 
        all [any-function? :tip-content tip-content: tip-content fc] 
        any [block? tip-content object? tip-content tip-content: form tip-content] 
        either string? tip-content [
            tool-tip-face/pane: none 
            tool-tip-face/text: copy test-tip-face/text: copy tip-content 
            tool-tip-face/real-size: none 
            tool-tip-face/size: 6 + size-text test-tip-face
        ] [
            tool-tip-face/pane: 
            either block? tip-content [
                layout/tight tip-content
            ] [
                tip-content
            ] 
            tool-tip-face/size: tool-tip-face/pane/size
        ] 
        root: root-face fc 
        tool-tip-face/offset: max 0x0 offset + 0x25 
        sz: tool-tip-face/offset + tool-tip-face/size 
        if sz/x > root/size/x [tool-tip-face/offset/x: root/size/x - tool-tip-face/size/x] 
        if sz/y > root/size/y [tool-tip-face/offset/y: tool-tip-face/offset/y - 50] 
        show tool-tip-face
    ] 
    set 'unset-tool-tip func [face] [
        any [tool-tip-face: get-tool-tip face exit] 
        hide tool-tip-face 
        tool-tip-face/pane: none
    ]
] 
--- "VID Keyboard Navigation" 
ctx-key-nav: context [
    set 'get-tab-face func [[catch] face [object!]] [
        get in root-face face 'tab-face
    ] 
    set 'unset-tab-face func [face [none! object!] /local rf] [
        any [face exit] 
        rf: root-face face 
        if in rf 'tab-face [
            rf/tab-face/tab-face?: none 
            rf/tab-face: none 
            unset-focus-ring face
        ] 
        face
    ] 
    set 'set-tab-face func [face [object!] /local rf] [
        any [flag-face? face tabbed return face] 
        rf: root-face face 
        if all [
            in rf 'tab-face 
            object? rf/tab-face 
            in rf/tab-face 'tab-face?
        ] [
            rf/tab-face/tab-face?: none 
            face/tab-face?: true 
            rf/tab-face: face 
            set-focus-ring face
        ] 
        face
    ] 
    set 'get-default-face func [face] [
        find-relative-face face [all [in face 'default face/default]]
    ] 
    nav-event: none 
    set 'key-face func [
        {Performs a keyboard action on a face. Returns face object (for show).} 
        face 
        event 
        /no-show "Do not show change yet" 
        /local access
    ] [
        if all [
            access: get in face 'access 
            in access 'key-face*
        ] [
            access/key-face* face event
        ] 
        any [no-show show face] 
        face
    ] 
    key-navigate: func [event /local tab-face] [
        nav-event: none 
        if event/type <> 'key [return event] 
        any [event/face return event] 
        tab-face: get-tab-face event/face 
        if key-filter [
            switch 
            key-face
        ] 
        event
    ] 
    key-navigate: func [event /local default-face f hidden? tab-face] [
        nav-event: none 
        if event/type <> 'key [return event] 
        unless event/face [return event] 
        if all [
            system/view/focal-face 
            flag-face? system/view/focal-face full-text-edit 
            event/face = root-face system/view/focal-face
        ] [
            return event
        ] 
        tab-face: get-tab-face event/face 
        switch/default event/key [
            #"^-" [
                if flag-face? tab-face input [
                    validate-face tab-face
                ] 
                until [
                    tab-face: 
                    any [
                        either event/shift [
                            find-flag/reverse tab-face tabbed
                        ] [
                            find-flag tab-face tabbed
                        ] 
                        tab-face
                    ] 
                    hidden?: false 
                    ascend-face tab-face [hidden?: any [hidden? face/size/x = 0 face/size/y = 0]] 
                    not hidden?
                ] 
                either flag-face? tab-face input [
                    focus tab-face
                ] [
                    unfocus 
                    set-tab-face tab-face
                ]
            ] 
            #" " [
                if system/view/focal-face [return event] 
                either in tab-face/access 'key-face* [
                    key-face tab-face event
                ] [
                    either event/shift [
                        click-face/alt tab-face
                    ] [
                        click-face tab-face
                    ]
                ]
            ] 
            #"^M" [
                if in tab-face/access 'key-face* [
                    key-face tab-face event
                ]
            ]
        ] [
            key-face tab-face event
        ] 
        event
    ]
] 
--- "DevBase: GUI Resizing" 
ctx-resize: context [
    *fo: 
    *fs: 
    *fa: 
    *fps: 
    *fpis: 
    *fpa: 
    *mtl: 
    *mbr: 
    *maxs: 
    *mins: 
    center: 
    top: 
    bottom: 
    left: 
    right: 
    none 
    screen-origin: 50x50 
    window-origin: 20x20 
    face-origin: 0x0 
    win-pos: 0x0 
    aspect: func [
        [catch] 
        size
    ] [
        unless pair? size [throw make error! reform ["Aspect error, size is" size]] 
        if zero? size/y [return 0] 
        size/x / size/y
    ] 
    set-vars: func [
        face 
        parent
    ] [
        *fo: face/offset 
        *fs: any [face/real-size face/size] 
        either parent [
            set [*mtl *mbr] any [get in face 'origin face-origin] 
            if all [parent/edge parent/edge/size] [*mbr: *mbr + (2 * parent/edge/size)] 
            *fps: parent/size
        ] [
            set [*mtl *mbr] screen-origin 
            *fps: system/view/screen-face/size
        ] 
        *fpis: *fps - *mtl - *mbr 
        *fa: face/aspect-ratio 
        *fpa: aspect *fpis 
        *mins: face/min-size 
        *maxs: face/max-size 
        set [horizontal vertical center top bottom left right] false
    ] 
    set-faces: func [
        face
    ] [
        face/win-offset: win-pos 
        face/offset: *fo 
        face/size: max 0x0 face/real-size: *fs 
        face/aspect-ratio: *fa
    ] 
    get-resize-face*: func [
        face
    ] [
        all [face: get in face 'access get in face 'resize-face*]
    ] 
    do-align: func [
        face 
        parent 
        /local fo
    ] [
        set-vars face parent 
        if pair? get in face 'fill [
            either flag-face? face fixed [
                if face/fill/x = 1 [*fs/x: *fps/x - *fo/x] 
                if face/fill/x = -1 [*fs/x: *fs/x + *fo/x *fo/x: 0] 
                if face/fill/y = 1 [*fs/y: *fps/y - *fo/y] 
                if face/fill/y = -1 [*fs/y: *fs/y + *fo/y *fo/y: 0]
            ] [
                if face/fill/x = 1 [*fs/x: *fps/x - *mbr/x - *fo/x] 
                if face/fill/x = -1 [*fs/x: *fs/x + *fo/x *fo/x: *mtl/x] 
                if face/fill/y = 1 [*fs/y: *fps/y - *mbr/y - *fo/y] 
                if face/fill/y = -1 [*fs/y: *fs/y + *fo/y *fo/y: *mtl/y]
            ]
        ] 
        if get in face 'align [set bind face/align self true] 
        if *mins [*fs: max *mins *fs] 
        if *maxs [*fs: min *maxs *fs] 
        if zero? *fa [*fa: aspect *fs] 
        either center [
            *fo: *fps - *mtl - *mbr - *fs / 2 + *mtl
        ] [
            case [
                all [top bottom] [
                    *fo/y: *fps/y - *mtl/y - *mbr/y - *fs/y / 2 + *mtl/y
                ] 
                top [*fo/y: *mtl/y] 
                bottom [*fo/y: *fps/y - *mbr/y - *fs/y]
            ] 
            case [
                all [left right] [
                    *fo/x: *fps/x - *mtl/x - *mbr/x - *fs/x / 2 + *mtl/x
                ] 
                left [*fo/x: *mtl/x] 
                right [*fo/x: *fps/x - *mbr/x - *fs/x]
            ]
        ] 
        if parent [win-pos: win-pos + (fo: *fo) + edge-size parent] 
        debug-align :face 
        set-faces face 
        face/line-list: none 
        align-contents face parent 
        ctx-text/set-text-body face face/text 
        act-face face none 'on-align 
        if parent [win-pos: win-pos - fo - edge-size parent]
    ] 
    align-contents: func [
        face 
        parent 
        /local r pane panes
    ] [
        in-level 
        (pane: face/pane face 1) 
        panes: get in face 'panes 
        case [
            all [
                parent 
                r: get-resize-face* face
            ] [r face face/size none none] 
            block? :panes [foreach [w p] head panes [either object? p [do-align p face] [foreach fc p [do-align fc face]]]] 
            object? :pane [do-align pane face] 
            block? :pane [foreach fc pane [do-align fc face]]
        ] 
        out-level
    ] 
    set 'boo false 
    irk: func [face] [if boo [print ['--- face/style face/size face/real-size *fs]]] 
    do-resize: func [
        face 
        diff 
        /local n-diff fo *fs* *fo*
    ] [
        n-diff: 0x0 
        set-vars face face/parent-face 
        if get in face 'spring [set bind face/spring self true] 
        *fs*: *fs 
        *fo*: *fo 
        *fs: *fs + n-diff: diff 
        *fo: *fo + diff 
        if any [left right] [*fs/x: *fs*/x n-diff/x: 0] 
        if any [top bottom] [*fs/y: *fs*/y n-diff/y: 0] 
        if get in face 'fixed-aspect [
            switch face/fill [
                0x1 [
                    *fs/x: *fs/y * *fa
                ] 
                1x0 [
                    *fs/y: *fs/x / *fa
                ] 
                1x1 [
                    either *fpa > *fa [
                        *fs/x: *fs/y * *fa
                    ] [
                        *fs/y: *fs/x / *fa
                    ]
                ]
            ]
        ] 
        unless left [*fo/x: *fo*/x] 
        unless top [*fo/y: *fo*/y] 
        if *mins [*fs: max *mins *fs] 
        if *maxs [*fs: min *maxs *fs] 
        if all [left right] [
            *fo/x: *fps/x - *mtl/x - *mbr/x - *fs/x / 2 + *mtl/x
        ] 
        if all [top bottom] [
            *fo/y: *fps/y - *mtl/y - *mbr/y - *fs/y / 2 + *mtl/y
        ] 
        if face/parent-face [win-pos: win-pos + (fo: *fo) + edge-size face/parent-face] 
        debug-resize :face diff 
        set-faces face 
        if n-diff <> 0x0 [face/line-list: none] 
        resize-contents face n-diff 
        ctx-text/set-text-body face face/text 
        act-face face none 'on-resize 
        if face/parent-face [win-pos: win-pos - fo - edge-size face/parent-face]
    ] 
    resize-contents: func [
        face 
        diff 
        /local r pane panes
    ] [
        in-level 
        (pane: face/pane face 1) 
        panes: get in face 'panes 
        case [
            r: get-resize-face* face [r face face/size none none] 
            block? :panes [foreach [w p] head panes [either object? p [do-resize p diff] [foreach fc p [do-resize fc diff]]]] 
            object? :pane [do-resize pane diff] 
            block? :pane [foreach fc pane [do-resize fc diff]]
        ] 
        out-level
    ] 
    access: make object! [resize-face*: none] 
    access/resize-face*: resize-face*: func [
        {Initialize face layout alignment. Accessed through resize-face.} 
        face [object!] "The face that has been resized (must be VID face)" 
        size [pair! number!] "The new size (apparently = face/size)" 
        x [logic! none!] "Resize only width" 
        y [logic! none!] "Resize only height"
    ] [
        align-contents face face/parent-face 
        add-resize-face* face
    ] 
    add-resize-face*: func [
        {Build and assign runtime resize accessor resize-face*.} 
        face [object!] "The face (must be VID face)"
    ] [
        if in face 'access [
            use [last-size] copy/deep [
                last-size: face/size 
                face/access: make any [face/access ctx-access/data] [
                    resize-face*: func [face size x y] [
                        size: max size any [get in face 'min-size 0x0] 
                        if get in face 'max-size [size: min size face/max-size] 
                        size: (1x1 * size) - last-size 
                        if x [size: size * 1x0] 
                        if y [size: size * 0x1] 
                        face/size: last-size + size 
                        ctx-text/set-text-body face face/text 
                        if object? face/pane [do-resize face/pane size] 
                        if block? face/pane [foreach fc face/pane [do-resize fc size]] 
                        last-size: face/size 
                        face
                    ]
                ]
            ]
        ] 
        face
    ] 
    handler: insert-event-func [
        if all [not event/face/parent-face 'resize = event/type] [
            resize-face event/face event/face/size 
            set-focus-ring event/face
        ] 
        event
    ] 
    resize: func [
        "Resize a face and its contents." 
        face [object!] "The face" 
        size [pair!] "The new size" 
        offset [pair!] "The new offset" 
        /no-show "Do not show change yet." 
        /no-springs "Ignore springs in face." 
        /local diff pane-spring spring
    ] [
        diff: size - any [face/real-size face/size] 
        face/offset: offset 
        if no-springs [
            spring: face/spring face/spring: none 
            if object? face/pane [
                pane-spring: face/pane/spring 
                face/pane/spring: none
            ]
        ] 
        do-resize face diff 
        if no-springs [
            face/spring: spring 
            if object? face/pane [
                face/pane/spring: pane-spring
            ]
        ] 
        any [no-show show face] 
        face
    ] 
    align: func [
        "Align a face and its contents." 
        face [object!] "The face" 
        /no-show "Do not show change yet." 
        /local diff
    ] [
        if face/parent-face [
            win-pos: face/parent-face/win-offset
        ] 
        do-align face face/parent-face 
        any [no-show show face] 
        face
    ]
] 
resize: get in ctx-resize 'resize 
align: get in ctx-resize 'align 
resizable?: func [
    {Check a face to see if it is supposed to be resizable.} 
    face [object!] "The face"
] [
    not none? any [
        flag-face? face resize 
        face/options = 'resize 
        all [block? face/options find face/options 'resize] 
        ctx-resize/get-resize-face* face 
        not empty? intersect any [get in face 'spring []] [horizontal vertical]
    ]
] 
flag-resize: func [
    "Flag a VID face with 'resize if appropriate." 
    face [object!] "The face"
] [
    all [
        in face 'flags 
        resizable? face 
        flag-face face resize
    ]
] 
--- "VID Window Functions" 
make-window: func [pane /options opts] [
    if object? pane [
        if ctx-vid-debug/debug [dump-face pane] 
        return pane
    ] 
    layout/parent 
    pane 
    make 
    get-style 'resizable-window 
    [
        color: svvc/window-background-color 
        feel: make object! [
            redraw: none 
            detect: get in system/view/window-feel 'detect 
            engage: none 
            over: none
        ] 
        options: any [
            all [opts unique append copy options opts] 
            options
        ] 
        valid: make object! [
            action: 
            result: none 
            required: false
        ]
    ]
] 
vid-window?: func [face /local fc fcr] [
    fc: root-face face 
    all [
        in fc 'style 
        fc/style = 'window 
        fc/pane 
        block? fc/pane 
        4 <= length? fc/pane 
        in fc 'focus-ring-faces 
        fcr: fc/focus-ring-faces 
        fcr/1/style = 'highlight 
        fcr/1/style = fcr/2/style 
        fcr/2/style = fcr/3/style 
        fcr/3/style = fcr/4/style
    ]
] 
window-open?: func [face /local win] [
    win: find system/view/screen-face/pane face 
    if win [first win]
] 
do-window: func [face changes /local win] [
    if win: window-open? face [
        set in first win 'changes changes 
        show win 
        true
    ]
] 
activate-window: func [face] [do-window face [activate]] 
maximize-window: func [face] [do-window face [maximize]] 
display-window: func [face title /event fnc] [
    unless activate-window face [
        view/new/title center-face face title 
        if fnc [insert-event-func fnc]
    ]
] 
get-parent: func [face word /local pf] [
    unless pf: face/parent-face [return if in face :word [face]] 
    until [
        any [
            all [in pf :word get in pf :word] 
            none? pf/parent-face 
            pf: pf/parent-face
        ]
    ] 
    if in pf :word [pf]
] 
make-pane: func [pane /local res] [
    get in make either object? pane [pane] [layout/tight pane] [color: none] 'pane
] 
set-pane: func [face lo /no-show] [
    face/pane: lo 
    unless no-show [show face]
] 
clear-pane: func [face] [clear face/pane] 
popup?: func [window] [
    found? find system/view/pop-list window
] 
key-sense: func [face event] [
    if face: find-key-face face event/key [
        if get in face 'action [do-face face event/key] 
        none
    ]
] 
detect-func: func [face event /local cf] [
    case [
        word? event [] 
        event/type = 'time [
            all [
                face/then 
                face/tool-tip-show-delay < difference now/precise face/then 
                face/then: now/precise 
                set-tool-tip mouse-over-face event/offset
            ]
        ] 
        event/type = 'move [
            mouse-over-face: over-face face face/win-offset + event/offset 
            face/then: now/precise 
            unset-tool-tip get-tool-tip face
        ] 
        event/type = 'down [
            cf: event/face/menu-face 
            if cf/pane [
                unless within? event/offset win-offset? cf cf/size [
                    unset-menu-face event/face
                ]
            ]
        ] 
        find [scroll-page scroll-line] event/type [
            all [
                cf: mouse-over-face 
                until [
                    any [
                        flag-face? cf scrollable 
                        none? cf: cf/parent-face
                    ]
                ] 
                if all [cf not flag-face? cf disabled] [
                    scroll-face/step cf event/offset/x event/offset/y
                ]
            ]
        ] 
        event/type = 'key [
            key-sense face event 
            ctx-key-nav/nav-event: event
        ]
    ]
] 
system/view/popface-feel: make object! [
    mouse-over-face: none 
    redraw: none 
    detect: func [face event] [
        foreach evt-func event-funcs [
            unless event? evt-func: evt-func face event [
                return either evt-func [event] [none]
            ]
        ] 
        event
    ] 
    over: none 
    engage: none 
    event-funcs: reduce [
    ] 
    close-events: [close] 
    inside?: func [face event] [face = event/face] 
    process-outside-event: func [event] [
        either event/type = 'resize [event] [none]
    ] 
    pop-detect: func [face event] [
        either inside? face event [
            either find close-events event/type [
                hide-popup none
            ] [
                detect-func face event 
                event
            ]
        ] [
            process-outside-event event
        ]
    ]
] 
system/view/wake-event: func [port] bind bind [
    event: pick port 1 
    if none? event [
        if debug [print "Event port awoke, but no event was present."] 
        return false
    ] 
    either pop-face [
        if in pop-face/feel 'pop-detect [event: pop-face/feel/pop-detect pop-face event] 
        do event 
        if nav-event [key-navigate nav-event] 
        found? all [
            pop-face <> pick pop-list length? pop-list 
            (pop-face: pick pop-list length? pop-list true)
        ]
    ] [
        do event 
        if nav-event [key-navigate nav-event] 
        empty? screen-face/pane
    ]
] in system/view 'self ctx-key-nav 
system/view/window-feel: make object! [
    mouse-over-face: none 
    cf: none 
    redraw: none 
    detect: func [face event] bind [
        detect-func face event 
        event
    ] ctx-key-nav 
    over: none 
    engage: none
] 
init-window: func [
    "Initializes a window for first display." 
    [catch] 
    face 
    /focus focus-face
] [
    if all [
        in face 'style 
        face/style = 'window
    ] [
        err-face: none 
        init-enablers face 
        validate-init-face face 
        any [
            err-face 
            all [focus-face system/words/focus focus-face true] 
            focus-default-input face 
            focus-first-input face 
            focus-first-false face
        ]
    ] 
    face
] 
view: func [
    "Displays a window face." 
    view-face [object!] 
    /new "Creates a new window and returns immediately" 
    /offset xy [pair!] "Offset of window on screen" 
    /options opts [block! word!] "Window options [no-title no-border resize]" 
    /title text [string!] "Window bar title" 
    /local scr-face
] bind [
    scr-face: system/view/screen-face 
    if find scr-face/pane view-face [return view-face] 
    either any [new empty? scr-face/pane] [
        view-face/text: any [
            view-face/text 
            all [system/script/header system/script/title] 
            copy ""
        ] 
        new: all [not new empty? scr-face/pane] 
        append scr-face/pane view-face
    ] [change scr-face/pane view-face] 
    if all [
        system/view/vid 
        view-face/feel = system/view/vid/vid-face/feel
    ] [
        view-face/feel: window-feel
    ] 
    if offset [view-face/offset: xy] 
    if options [view-face/options: opts] 
    if title [view-face/text: text] 
    init-window view-face 
    show scr-face 
    if new [do-events] 
    view-face
] system/view 
unview: func [
    "Closes window views, except main view." 
    /all "Close all views, including main view" 
    /only face [object!] "Close a single view" 
    /local pane
] bind [
    pane: head system/view/screen-face/pane 
    either only [remove find pane face] [
        either all [clear pane] [remove back tail pane]
    ] 
    if system/words/all [not empty? pane pane/1/focal-face] [
        focus/keep pane/1/focal-face
    ] 
    show system/view/screen-face
] system/view 
set 'show-popup func [face [object!] /window window-face [object!] /away /local no-btn feelname] bind [
    if find pop-list face [exit] 
    window: either window [feelname: copy "popface-feel-win" window-face] [
        feelname: copy "popface-feel" 
        if none? face/options [face/options: copy []] 
        if not find face/options 'parent [
            repend face/options ['parent none]
        ] 
        system/view/screen-face
    ] 
    if any [face/feel = system/words/face/feel face/feel = window-feel] [
        no-btn: false 
        if block? get in face 'pane [
            no-btn: foreach item face/pane [if get in item 'action [break/return false] true]
        ] 
        if away [append feelname "-away"] 
        if no-btn [append feelname "-nobtn"] 
        face/feel: get bind to word! feelname 'popface-feel
    ] 
    insert tail pop-list pop-face: face 
    append window/pane face 
    init-window face 
    show window
] system/view 
hide-popup: func [/timeout /local focal-win-face win-face] bind [
    if not find pop-list pop-face [exit] 
    win-face: any [pop-face/parent-face system/view/screen-face] 
    remove find win-face/pane pop-face 
    remove back tail pop-list 
    if timeout [pop-face: pick pop-list length? pop-list] 
    focal-win-face: win-face 
    if all [focal-win-face = system/view/screen-face not empty? focal-win-face/pane] [
        focal-win-face: focal-win-face/pane/1
    ] 
    describe-face fff: focal-win-face 
    if all [focal-win-face <> system/view/screen-face focal-win-face/focal-face] [
        focus/keep focal-win-face/focal-face
    ] 
    show win-face
] system/view 
inform: func [
    {Display an exclusive focus panel for alerts, dialogs, and requestors.} 
    panel [object!] 
    /offset where [pair!] "Offset of panel" 
    /title ttl [string!] "Dialog window title" 
    /timeout time 
    /event evt-func "Event Function" 
    /local sv old-focus
] [
    sv: system/view 
    panel/text: copy any [ttl "Dialog"] 
    panel/offset: either offset [where] [sv/screen-face/size - panel/size / 2] 
    panel/feel: sv/popface-feel 
    show-popup panel 
    if event [insert sv/popface-feel/event-funcs :evt-func] 
    either time [if none? wait time [hide-popup/timeout]] [do-events] 
    if event [remove find sv/popface-feel/event-funcs :evt-func]
] 
--- "VID Extension Kit Dialog Management" 
ctx-dialog: context [
    layout-content: none 
    call-back: none 
    set-dialog-value: func [face value /local win] [
        win: root-face face 
        win/data: value 
        either popup? win [hide-popup] [unview/only win]
    ] 
    dialog-use: func [face /local pnl] [
        pnl: back-face face/parent-face 
        if true [
            unfocus 
            vals: get-face pnl 
            either all [block? vals equal? reduce [none] unique vals] [
            ] [
                set-dialog-value face get-face pnl
            ]
        ]
    ] 
    bind-face-func: func [content call-back] [
        traverse-face content [
            if get in face 'action [bind second get in face 'action 'call-back] 
            if get in face 'alt-action [bind second get in face 'alt-action 'call-back] 
            if get in face 'actors [
            ]
        ]
    ] 
    set 'tool func [title [string!] type [word! block!] content [any-type!] call-back [any-function!] /local lo] [
        if word? type [
            foreach window system/view/screen-face/pane [
                all [lo: find-style window type break]
            ]
        ] 
        layout-content: any [all [lo lo/parent-face] make-window either block? type [type] [reduce [type]]] 
        bind-face-func layout-content :call-back 
        if content [set-face/no-show layout-content/pane/1 content] 
        either lo [
            show layout-content
        ] [
            view/new/title layout-content title
        ]
    ] 
    set 'tool-color func [content output-func] [tool "Color Tool" 'layout-color content :output-func] 
    make-button-group: func [buttons] [compose/deep [btn-group [across bar return (buttons)]]] 
    set 'request func [title [string!] type [word! block!] content [any-type!] button-group [word! block!]] [
        layout-content: either block? type [type] [reduce [type]] 
        layout-content: 
        make-window 
        append 
        layout-content 
        either word? button-group [
            button-group
        ] [
            make-button-group button-group
        ] 
        call-back: none 
        bind-face-func layout-content :call-back 
        if content [set-face/no-show layout-content/pane/1 content] 
        inform/title layout-content title 
        layout-content/data
    ] 
    set 'request-dir func [where /title ttl] [request any [ttl "Get Directory"] 'layout-dir where 'use-cancel] 
    set 'request-color func [value /title ttl] [request any [ttl "Get Color"] 'layout-color value 'use-cancel] 
    set 'request-user func [user pass /title ttl] [request any [ttl "Enter User & Pass"] 'layout-user reduce [user pass] 'use-cancel] 
    set 'request-pass func [value /title ttl] [request any [ttl "Enter Password"] 'layout-pass value 'use-cancel] 
    set 'request-date func [/date value /title ttl] [request any [ttl "Enter Date"] 'layout-date any [value now/date] 'use-cancel] 
    set 'request-download func [urls /title ttl] [request any [ttl "Downloading..."] either block? urls ['layout-downloads] ['layout-download] urls 'cancel] 
    set 'request-value func [value /title ttl] [request any [ttl "Enter Value"] 'layout-value value 'use-cancel] 
    set 'request-text func [value /title ttl] [request any [ttl "Enter Text"] 'layout-text value 'use-cancel] 
    set 'request-rename func [value /title ttl] [request any [ttl "Enter New Name"] 'layout-rename value 'use-cancel] 
    set 'request-email func [target subject text /title ttl] [request any [ttl "Send Email"] 'layout-email reduce [target subject text] 'send-cancel] 
    set 'request-message func [target text /title ttl] [request any [ttl "Send Message"] 'layout-message reduce [target text] 'send-cancel] 
    set 'request-item func [data /title ttl] [request any [ttl "Select One Item"] 'layout-list data 'use-cancel] 
    set 'request-items func [data /title ttl] [request any [ttl "Select Item(s)"] 'layout-lists data 'use-cancel] 
    set 'request-find func [src /title ttl] [request any [ttl "Search for Text"] 'layout-find data 'use-cancel] 
    set 'request-replace func [src repl /title ttl] [request any [ttl "Search and Replace Text"] 'layout-replace reduce [src repl] 'use-cancel] 
    set 'question func [str /buttons btns /title ttl] [request any [ttl "Question"] 'layout-question str any [btns 'yes-no]] 
    set 'important-question func [str /buttons btns /title ttl] [request any [ttl "Question"] 'layout-warning str any [btns 'yes-no]] 
    set 'notify func [str /title ttl] [request any [ttl "Notification"] 'layout-notify str 'close] 
    set 'alert func [str /title ttl] [request any [ttl "Alert"] 'layout-alert str 'close] 
    set 'warn func [str /title ttl] [request any [ttl "Warning"] 'layout-warning str 'close] 
    set 'about-program func [/title ttl] [request any [ttl "About Program"] 'layout-about none 'close] 
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
        filter-list: [["*"] ["*.r" "*.reb" "*.rip"] ["*.txt"] ["*.jpg" "*.gif" "*.bmp" "*.png"]] 
        set 'request-file func [
            {Requests a file using a popup list of files and directories.} 
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
            either file [
                either block? name [picked: copy name] [picked: reduce [to-file name]]
            ] [
                unless keep [picked: copy []]
            ] 
            if none? picked [picked: copy []] 
            if file: picked/1 [where: first split-path file] 
            while [not tail? picked] [
                set [name file] split-path first picked 
                either name <> where [
                    remove picked
                ] [
                    change picked file 
                    picked: next picked
                ]
            ] 
            picked: head picked 
            if any [not where not exists? where] [where: clean-path %.] 
            unless keep [
            ] 
            either filter [
                filters: either block? filt [filt] [reduce [filt]]
            ] [
            ] 
            title-text: either title [copy title-text] ["Select a File:"] 
            button-text: either title [copy button-text] ["Select"] 
            if all [
                error? done: try [
                    filt-names: copy ["Normal" "REBOL" "Text" "Images"] 
                    filt-values: copy filter-list 
                    either filter [
                        insert head filt-names "Custom" 
                        insert/only filt-values filters
                    ] [
                        filt-names: at filt-names 1
                    ] 
                    done: local-request-file data: reduce [
                        title-text 
                        button-text 
                        clean-path where 
                        picked 
                        filt-names 
                        filt-values 
                        found? any [only] 
                        found? any [save]
                    ] 
                    if done [
                        dir-path: data/3 
                        picked: data/4
                    ] 
                    done
                ] 
                (get in disarm done 'code) = 328
            ] [
                done: false 
                read-dir/full either where [where] [dir-path]
            ] 
            if error? done [done] 
            if all [done picked any [path not empty? picked]] [
                either path [
                    done: insert copy picked copy dir-path 
                    either only [done/1] [head done]
                ] [
                    foreach file picked [insert file dir-path] 
                    either only [picked/1] [picked]
                ]
            ]
        ]
    ]
] 
--- "VID Extras" 
format: func [
    "Format a string according to the format dialect." 
    rules {A block in the format dialect. E.g. [10 -10 #"-" 4]} 
    values 
    /pad p 
    /local out val rule
] [
    p: any [p #" "] 
    unless block? :rules [rules: reduce [:rules]] 
    unless block? :values [values: reduce [:values]] 
    val: 0 
    foreach item rules [
        if word? :item [item: get item] 
        val: val + switch/default type?/word :item [
            integer! [abs item] 
            string! [length? item] 
            char! [1]
        ] [0]
    ] 
    out: make string! val 
    insert/dup out p val 
    foreach rule rules [
        if word? :rule [rule: get rule] 
        switch type?/word :rule [
            integer! [
                pad: rule 
                val: form first+ values 
                clear at val 1 + abs rule 
                if negative? rule [
                    pad: rule + length? val 
                    if negative? pad [out: skip out negate pad] 
                    pad: length? val
                ] 
                change out :val 
                out: skip out pad
            ] 
            string! [out: change out rule] 
            char! [out: change out rule]
        ]
    ] 
    unless tail? values [append out values] 
    head out
] 
face-size-text: func [face] [
    face/font/offset + 
    (any [all [face/edge face/edge/size * 2] 0]) + 
    (any [all [face/para face/para/origin] 0]) + 
    (any [all [face/para face/para/margin] 0]) + 
    size-text face
] 
face-size-from-text: func [face dir /local sz] [
    any [dir return face/size] 
    any [face/font return face/size] 
    if face/size/:dir = -1 [
        face/size/:dir: 1000 
        sz: face-size-text face 
        face/size/:dir: sz/:dir
    ] 
    face/size
] 
button-skin: func [face image color /local pos] [
    pos: 0x0 
    if face/font/align <> 'right [
        pos: face/size - image/size - any [all [face/edge face/edge/size * 2] 0x0]
    ] 
    make object! [
        effect: reduce [
            'draw reduce ['image pos image]
        ]
    ]
] 
--- "VID Face Object" 
stylize/master [
    WINDOW: FACE 100x100 with [
        font: none 
        access: ctx-access/compound 
        origin: ctx-resize/window-origin
    ] 
    RESIZABLE-WINDOW: WINDOW with [
        options: [resize] 
        access: make access ctx-resize/access 
        data: none 
        result: none 
        align: [center] 
        tool-tip-face: none 
        menu-face: none 
        sheet-face: none 
        focus-ring-faces: none 
        tool-tip-hide-delay: 0:00:00.2 
        tool-tip-show-delay: 0:00:01 
        then: none 
        rate: 0:00:01 
        init: [
            tab-face: any [tab-face self] 
            unless pane [pane: make block! []] 
            append pane focus-ring-faces: make-focus-ring self 
            append pane menu-face: make-menu-face self 
            append pane tool-tip-face: make-tool-tip 
            set-parent-faces self 
            ctx-resize/add-resize-face* self 
            ctx-resize/align/no-show self none 
            ctx-resize/resize/no-show self size offset 
            if ctx-vid-debug/debug [dump-face self]
        ]
    ]
] 
--- "VID Image" 
stylize/master [
    IMAGE: FACE with [
        size: color: image: none 
        feel: svvf/sensor 
        access: ctx-access/image 
        effect: [fit] 
        edge: [size: 0x0 color: black] 
        font: [size: 16 align: 'center valign: 'middle style: 'bold shadow: 2x2] 
        doc: [
            info: "Base style for images" 
            image: "loaded image data" 
            string: "text on top of image" 
            pair: "width and height of text area" 
            tuple: "colorize the image" 
            file: "load as image data" 
            url: "load as image data" 
            block: ["execute when clicked" "execute when alt-clicked"]
        ] 
        init: [
            if image? image [
                if none? size [size: image/size] 
                if size/y < 0 [size/y: size/x * image/size/y / image/size/x effect: insert copy effect 'fit] 
                if color [effect: join effect ['colorize color]]
            ] 
            if none? size [size: 100x100]
        ]
    ] 
    BACKDROP: IMAGE with [
        doc: [info: "image scaled to fill pane" pair: block: none]
    ] 
    BACKTILE: BACKDROP 
    doc [info: "Image tiled to fill pane"] 
    effect [tile-view] 
    LOGO-BAR: IMAGE with [
        update: does [
            self/pane/1/offset/y: self/size/y - 100 
            self/pane/2/size/y: self/size/y - 99 
            self
        ] 
        resize: func [siz /x /y] [
            either any [x y] [
                if x [size/x: siz] 
                if y [size/y: siz]
            ] [size: siz] 
            update
        ] 
        logo-vert: [
            size 24x100 origin 0x0 
            image logo.gif 100x100 effect [rotate 270]
        ] 
        init: [
            pane: reduce [
                make system/view/vid/vid-face [offset: 0x199 image: to-image layout logo-vert size: 24x100 edge: none] 
                make system/view/vid/vid-face [size: 24x200 effect: [gradient 0x1 50.70.140 0.0.0] edge: none]
            ] 
            if none? size [size: 24x300] 
            update self
        ]
    ] 
    ANIM: IMAGE with [
        frames: copy [] 
        rate: 1 
        feel: make feel [
            engage: func [face action event] [
                if action = 'time [
                    if empty? face/frames [exit] 
                    face/image: first face/frames 
                    if tail? face/frames: next face/frames [
                        face/frames: head face/frames
                    ] 
                    show face
                ]
            ]
        ] 
        words: [
            frames [append new/frames second args next args] 
            rate [new/rate: second args next args]
        ] 
        init: [
            if image? image [
                if none? size [size: image/size] 
                if size/y < 0 [size/y: size/x * image/size/y / image/size/x effect: insert copy effect 'fit] 
                if color [effect: join effect ['colorize color]]
            ] 
            if none? size [size: 100x100] 
            forall frames [change frames load-image first frames] 
            frames: head frames 
            image: all [not empty? frames first frames]
        ]
    ] 
    IMAGES: IMAGE with [
        images: make block! [] 
        access: make object! [
            set-face*: func [face image] [
                if none? image [
                    face/data: none 
                    face/image: false
                ] 
                if any [
                    logic? image 
                    integer? image
                ] [
                    face/data: image 
                    face/image: pick face/images image 
                    if face/image [face/image: get face/image]
                ] 
                if word? image [
                    all [
                        face/data: image 
                        face/image: select face/images image
                    ]
                ] 
                show face 
                image
            ] 
            get-face*: func [face] [face/data]
        ] 
        init: [
            if none? size [size: 100x100] 
            unless empty? images [
                set-face self data
            ]
        ]
    ]
] 
--- "Sensor specific styles for VID" 
stylize/master [
    SENSOR: BLANK-FACE with [
        feel: svvf/sensor 
        doc: [
            info: "Transparent sensor area" 
            pair: "Size of sensor"
        ] 
        init: [if none? size [size: 100x100]]
    ] 
    KEY: SENSOR 0x0 doc [info: "Keyboard action" pair: none]
] 
--- "Text faces for VID" 
stylize/master [
    BASE-TEXT: FACE with [
        text: "Text" 
        size: image: color: none 
        access: ctx-access/text 
        edge: none 
        flags: [text] 
        font: [color: black shadow: none colors: [0.0.0 40.40.40]] 
        xy: none 
        doc: [
            info: "Base text style" 
            string: "Text contents" 
            integer: "Width of text area" 
            pair: "Width and height of text area" 
            tuple: ["text color" "background color"] 
            block: ["execute when clicked" "execute when alt-clicked"]
        ] 
        init: [
            if all [not flag-face? self as-is string? text] [trim/lines text] 
            if none? text [text: copy ""] 
            change font/colors font/color 
            if none? size [size: -1x-1] 
            if size/x = -1 [
                size/x: first face-size-from-text self 'x
            ] 
            if size/y = -1 [
                size/y: second face-size-from-text self 'y
            ]
        ]
    ] 
    VTEXT: BASE-TEXT with [
        feel: ctx-text/swipe 
        font: [color: black shadow: 0x0 colors: svvc/font-color] 
        doc: [info: "Video text (light on dark)"] 
        insert init [
            if :action [feel: svvf/hot saved-area: true]
        ]
    ] 
    TEXT: VTEXT 
    svvc/body-text-color 
    shadow none 
    doc [info: "Document text"] 
    with [
        text: "Text" 
        words: compose [
            decimal (
                func [new args] [
                    flag-face new decimal 
                    args
                ]
            ) 
            integer (
                func [new args] [
                    flag-face new integer 
                    args
                ]
            ) 
            range (func [new args] [new/range: reduce second args args: next args])
        ] 
        numeric: func [face] [
            any [
                flag-face? face integer 
                flag-face? face decimal
            ]
        ] 
        access: make access [
            get-face*: func [face] [face/data] 
            set-face*: func [face value] [
                if face/para [face/para/scroll: 0x0] 
                either all [in face 'numeric face/numeric face] [
                    face/data: 
                    case [
                        integer? value [value] 
                        decimal? value [value] 
                        all [series? value empty? value] [0] 
                        error? try [to-decimal value] [0] 
                        equal? to-integer value to-decimal value [to-integer value] 
                        true [to-decimal value]
                    ] 
                    face/text: form face/data
                ] [
                    face/text: face/data: either value [form value] [copy ""]
                ] 
                face/line-list: none
            ]
        ]
    ] 
    BODY: TEXT "Body" with [
        spring: [bottom] 
        size: -1x-1 
        reflow: func [face /local old diff] [
            old: face/size 
            face/size/y: -1 
            sz: face-size-from-text face 'y 
            face/size/y: sz/y 
            if face/real-size [face/real-size: face/size] 
            faces: next find face/parent-face/pane face 
            if tail? faces [exit] 
            diff: face/size - old 
            foreach f faces [
                f/offset/y: f/offset/y + diff/y 
                f/win-offset/y: f/win-offset/y + diff/y
            ]
        ] 
        append init [
            insert-actor-func self 'on-resize :reflow 
            insert-actor-func self 'on-set :reflow
        ]
    ] 
    TXT: TEXT 
    BANNER: VTEXT "Banner" svvc/title-text-color bold font-size 24 center middle shadow 3x3 
    doc [info: "Video text title"] 
    VH1: BANNER "Video Text" svvc/title-text-color font-size 20 doc [info: "Video text heading"] 
    VH2: VH1 font-size 16 shadow 2x2 
    VH3: VH2 font [style: [bold italic]] 
    VH4: VH2 font-size 14 
    LABEL: VTEXT "Label" middle bold feel none doc [info: "label for dark background"] 
    VLAB: LABEL 72x24 right doc [info: "label for dark forms, right aligned"] 
    LBL: TEXT "Label" bold middle feel none doc [info: "label for light background"] 
    LAB: LBL 72x24 right doc [info: "label for light forms, right aligned"] 
    TITLE: BODY "Title" bold font-size 24 center middle doc [info: "document title"] 
    H1: BODY "Header" bold font-size 20 para [wrap?: none] doc [info: "document heading"] fill 1x0 
    H2: H1 font-size 16 
    H3: H2 font-size 14 
    H4: H3 font-size 12 
    H5: H4 font [style: [bold italic]] 
    TT: TXT font-name font-fixed doc [info: "typewriter text (monospaced)"] 
    CODE: TT "Code" bold doc [info: "source code text (monospaced)"]
] 
--- "VID Box" 
stylize/master [
    BOX: IMAGE doc [info: "shortcut for image"] 
    BAR: BLANK-FACE -1x3 fill 1x0 spring [bottom] with [
        edge: [size: 1x1 effect: 'bevel] 
        doc: [
            info: "horizontal separator" 
            integer: "width of bar" 
            pair: "size of bar" 
            tuple: "color of the bar"
        ] 
        init: [
            if data: color [edge: make edge [color: data + 20]] 
            if negative? size/x [size/x: 200]
        ]
    ] 
    ASPECT-BOX: BOX with [fixed-aspect: true] 
    DUMMY: BOX load-stock 'blocked 200x24 spring [bottom] effect [tile] with [
        access: make access [
            set-face*: func [face value] [value] 
            get-face*: func [face] [none] 
            clear-face*: func [face] []
        ]
    ]
] 
--- "VID Buttons" 
stylize/master [
    BUTTON: FACE 100x24 "Button" spring [bottom right] with [
        value: false 
        color: image: none 
        font: [align: 'center valign: 'middle shadow: 0x0 style: 'bold] 
        feel: svvf/button 
        effects: none 
        depth: 128 
        colors: svvc/action-colors 
        disabled-colors: none 
        access: ctx-access/button 
        doc: [
            info: "Rectangular, rendered buttons" 
            string: ["button label" "button down label"] 
            integer: "width of button" 
            pair: "width and height of button" 
            tuple: ["button color" "button down color"] 
            block: ["execute when clicked" "execute when alt-clicked"] 
            image: ["button background" "background when button down"]
        ] 
        init: [
            edge: make edge [] 
            if font [
                font/color: first font/colors 
                size: face-size-from-text self 'x
            ] 
            if color [colors: reduce [color color]] 
            disabled-colors: reduce [
                to-tuple array/initial 3 round ((colors/1/1 + colors/1/2 + colors/1/3) / 3) 
                to-tuple array/initial 3 round ((colors/2/1 + colors/2/2 + colors/2/3) / 3)
            ]
        ]
    ] 
    ACT-BUTTON: BUTTON with [
        on-click: none 
        text: "Action" 
        multi: make multi [
            block: func [face blk /local act] [
                act: make block! [] 
                if face/on-click [append act face/on-click] 
                if pick blk 1 [append act pick blk 1] 
                face/action: func [face value] act 
                if pick blk 2 [face/alt-action: func [face value] pick blk 2]
            ]
        ]
    ] 
    TRUE-BUTTON: ACT-BUTTON "True" with [
        default: true 
        on-click: [
            context [
                fp: face/parent-face 
                fpa: get in fp 'action 
                win: root-face face 
                error-face: none 
                result: true 
                validate-face/act win [
                    result: result and (found? find [valid not-required] face/valid/result) 
                    error-face: any [
                        error-face 
                        not found? find [invalid required] face/valid/result 
                        (set-tab-face focus face)
                    ]
                ] 
                all [
                    win/result: face/value: result 
                    clean-face win 
                    either popup? win [hide-popup] [unview/only win]
                ]
            ]
        ] 
        glow: func [face] [
            face/color: face/original-color * ((sine ((to-decimal now/time/precise) // 1 * 360)) * 5E-2 + 1) 
            face/effects/1/3: face/color + 32 
            face/effects/1/4: face/color - 32
        ] 
        feel: make feel [
            engage: func [face action event] bind [
                switch action [
                    time [face/glow face] 
                    down [face/state: on] 
                    alt-down [face/state: on] 
                    up [if face/state [do-face face face/text] face/state: off] 
                    alt-up [if face/state [do-face-alt face face/text] face/state: off] 
                    over [face/state: on] 
                    away [face/state: off]
                ] 
                cue face action 
                show face
            ] system/view/vid/vid-feel/button
        ] 
        original-color: none
    ] 
    SAVE-BUTTON: TRUE-BUTTON "Save" with [
    ] 
    FALSE-BUTTON: ACT-BUTTON "False" with [
        on-click: [
            context [
                win: root-face face 
                win/result: face/value: false 
                either popup? win [hide-popup] [unview/only win]
            ]
        ]
    ] 
    CLOSE-BUTTON: FALSE-BUTTON "Close" align [left right] spring [left right] 
    POP-BUTTON: ACT-BUTTON "..." with [
        content: none 
        on-click: [
            if face/content [
                inform make-window face/content
            ]
        ]
    ] 
    CHECK: SENSOR with [
        set [font edge para] none 
        feel: svvf/check-radio 
        access: ctx-access/data 
        images: load-stock-block [check-off-up check-on-up check-off-down check-on-down check-off-over check-on-over] 
        size: images/1/size 
        hover: off 
        append init [if none? data [data: false] text: none state: off]
    ] 
    CHECK-MARK: CHECK 
    CHECK-LINE: BASE-TEXT middle with [
        images: load-stock-block [check-off-up check-on-up check-off-down check-on-down check-off-over check-on-over] 
        size: as-pair -1 images/1/size/y 
        feel: svvf/check-radio 
        access: ctx-access/data 
        edge-size: none 
        hover: false 
        text: "Value" 
        pad: 5 
        access: make access [
            disable-face*: func [face] [
                face/font/color: 80.80.80 
                face/pane/effect: [brightness 1 contrast -1]
            ] 
            enable-face*: func [face] [
                face/pane/effect: none
            ]
        ] 
        access: make access ctx-access/selector-nav 
        insert init [
            pane: make-face/spec 'check compose [
                size: (images/1/size) 
                offset: 0x0 
                feel: edge: color: none 
                flags: copy []
            ] 
            para: make para [] 
            either font/align = 'right [
                para/margin/x: pane/size/x + pad
            ] [
                para/origin/x: pane/size/x + pad
            ]
        ] 
        append init [
            state: off 
            edge-size: edge-size? self 
            pane/offset/y: size/y - edge-size/y + 1 - pane/size/y / 2 
            all [font/align = 'right pane/offset/x: size/x - edge-size/x - 2 - pane/size/x] 
            if none? data [data: false]
        ]
    ] 
    RADIO: CHECK with [
        images: load-stock-block [radio-off-up radio-on-up radio-off-down radio-on-down radio-off-over radio-on-over] 
        size: images/1/size 
        related: 'default 
        saved-area: true
    ] 
    RADIO-LINE: CHECK-LINE with [
        images: load-stock-block [radio-off-up radio-on-up radio-off-down radio-on-down radio-off-over radio-on-over] 
        size: as-pair -1 images/1/size/y 
        related: 'default 
        append init [
            pane/saved-area: true
        ]
    ] 
    BUTTON-BOX: BUTTON with [
        edge: none 
        colors: reduce [
            120.120.120 
            140.140.140 
            100.100.100
        ] 
        feel: make feel [
            redraw: func [face act pos /local state] [
                state: either not face/state [face/blinker] [true] 
                face/color: pick face/colors pick [1 3] not state
            ] 
            over: func [face action event] [
                face/color: pick face/colors pick [1 2] not action 
                show face
            ]
        ] 
        effect: copy []
    ] 
    ARROW: BUTTON 20x20 with [
        font: none 
        text: none 
        init: [
            unless effect [
                effect: compose [fit arrow (svvc/glyph-color) 0.7 rotate (
                        select [up 0 right 90 down 180 left 270] data
                    )] 
                state: off
            ]
        ] 
        words: [up right down left [new/data: first args args]]
    ] 
    ICON-BUTTON: BUTTON 20x20 
    COLOR-BUTTON: BUTTON 30x30 with [
        font: none 
        text: none 
        spring: none 
        append init [
            access/set-face* self any [color black] 
            color: svvc/action-color
        ] 
        access: make access [
            set-face*: func [face value] [
                any [tuple? value exit] 
                face/data: value 
                face/effect: compose/deep [
                    draw [
                        pen black 
                        box 4x4 (subtract face-size face 5) 
                        fill-pen checker-board.png 
                        box 4x4 (subtract face-size face 5) 
                        fill-pen (value) 
                        box 4x4 (subtract face-size face 5)
                    ]
                ]
            ] 
            get-face*: func [face] [face/data]
        ]
    ] [
        tool-color get-face face func [value] [
            set-face face value 
            act-face face event 'on-change
        ]
    ] 
    FOLD-BUTTON: BUTTON right fill 1x0 spring [bottom] with [
        fold: func [face /local fc axis tab-face] [
            any [fc: next-face face return false] 
            axis: pick [x y] face/size/y >= face/size/x 
            if fc/size/:axis > 0 [face/next-face-size: fc/size/:axis] 
            either face/folded [
                fc/size/:axis: fc/real-size/:axis: face/next-face-size 
                fc/show?: true 
                face/next-face-spring: fc/spring 
                face/effect/draw/image: arrow-down.png
            ] [
                fc/size/:axis: fc/real-size/:axis: 0 
                fc/show?: false 
                fc/spring: append copy [] pick [right bottom] axis = 'x 
                face/effect/draw/image: arrow-right.png
            ] 
            face/folded: not face/folded 
            faces: next find face/parent-face/pane fc 
            unless tail? faces [
                diff: next-face-size 
                if fc/size/:axis = 0 [diff: negate diff] 
                foreach f faces [
                    if f/style <> 'highlight [
                        f/offset/:axis: f/offset/:axis + diff 
                        f/win-offset/:axis: f/win-offset/:axis + diff
                    ]
                ]
            ] 
            tab-face: get-tab-face fc 
            set-tab-face 
            either within-face? tab-face fc [
                either visible-face? tab-face [
                    tab-face
                ] [
                    unfocus 
                    face
                ]
            ] [
                tab-face
            ] 
            show face/parent-face
        ] 
        next-face-size: 0 
        next-face-spring: none 
        folded: none 
        append init [
            effect: [draw [image arrow-down.png]] 
            insert-actor-func self 'on-click :fold
        ]
    ]
] 
--- "VID Toggle" 
stylize/master [
    TOGGLE: BUTTON with [
        text: "Toggle" 
        feel: svvf/toggle 
        keep: true 
        access: ctx-access/toggle
    ] 
    STATE: TOGGLE with [
        text: "State" 
        click: false 
        feel: make feel [
            redraw: func [face act pos /local appearance state] [
                state: index? face/states 
                if all [face/texts face/texts/2 face/texts/3] [
                    face/text: pick face/texts state
                ] 
                appearance: pick face/appearances state 
                foreach word next first appearance [
                    set in face word get in appearance word
                ] 
                if face/edge [face/edge: bind get pick [normal-edge frame-edge] face/click face]
            ] 
            engage: func [face action event] [
                if find [down alt-down] action [
                    if face/related [
                        foreach item face/parent-face/pane [
                            if all [
                                flag-face? item toggle 
                                item/related 
                                item/related = face/related 
                                item <> face
                            ] [
                                item/states: head item/states 
                                item/data: item/state: first item/states 
                                show item
                            ]
                        ]
                    ] 
                    face/states: next face/states 
                    if tail? face/states [face/states: head face/states] 
                    face/data: face/state: first face/states 
                    face/click: not face/click 
                    either action = 'down [do-face face face/data] [do-face-alt face face/data] 
                    show face
                ] 
                if find [up alt-up] action [
                    face/click: not face/click 
                    show face
                ]
            ]
        ] 
        states: appearances: none 
        append init [
            unless states [
                states: reduce [none true false]
            ] 
            appearances: reduce any [
                appearances 
                [
                    make object! [
                        effect: reduce ['gradient 0x1 color color - 50]
                    ] 
                    make object! [
                        effect: reduce ['gradient 0x1 color + 50 color]
                    ] 
                    make object! [
                        effect: reduce ['gradient 0x1 color - 50 color - 100]
                    ]
                ]
            ]
        ]
    ] 
    TAB-BUTTON: TOGGLE with [
        text: "Tab" 
        images: load-stock-block [tab tab-on] 
        edge: none 
        effect: [extend 8x8 76x0 key black] 
        access: make access ctx-access/selector-nav
    ] 
    TOGGLE-BOX: TOGGLE with [
        edge: none 
        colors: reduce [
            120.120.120 
            orange 
            140.140.140 
            orange + 20 
            100.100.100 
            orange - 20
        ] 
        feel: make feel [
            redraw: func [face act pos /local state] [
                state: either not face/state [face/blinker] [true] 
                face/color: pick face/colors not state
            ] 
            over: func [face action event] [
                face/color: pick face/colors pick [3 4] not action 
                show face
            ]
        ] 
        effect: copy []
    ]
] 
--- "VID Scroller" 
stylize/master [
    SLIDER: FACE 100.100.100 16x200 with [
        feel: svvf/slide 
        font: none 
        para: none 
        text: none 
        step: 2E-2 
        ratio: 
        page: 
        axis: none 
        data: 0 
        clip: 0x0 
        access: ctx-access/data-number 
        access: make access [
            resize-face*: func [face size x y] [
                face/axis: pick [y x] size/y >= size/x 
                face/redrag face/ratio
            ] 
            key-face*: func [face event] [
                if find [left up right down] event/key [
                    set-face face add (get-face face) 
                    case [
                        find [left up] event/key [negate face/step] 
                        find [right down] event/key [face/step]
                    ] 
                    do-face face none
                ]
            ]
        ] 
        flags: [input] 
        dragger: make svv/vid-face [
            offset: 0x0 
            color: 128.128.128 
            colors: svvc/action-colors 
            disabled-colors: none 
            feel: svvf/drag 
            style: 'dragger 
            text: font: para: none 
            flags: [internal action] 
            edge: make edge [size: 1x1 effect: 'bevel color: 128.128.128]
        ] 
        init: [
            pane: reduce [make dragger [edge: make edge []]] 
            if colors [color: first colors pane/1/color: second colors] 
            axis: pick [y x] size/y >= size/x 
            redrag 0.1
        ] 
        redrag: func [val /local tmp] [
            state: none 
            ratio: min 1 max 0 val 
            page: any [all [ratio = 1 0] ratio / (1 - ratio)] 
            pane/1/size: val: size - (2 * edge/size) - (2 * clip * pick [0x1 1x0] axis = 'y) 
            tmp: val/:axis * ratio 
            if tmp < 10 [page: either val/:axis = tmp: 10 [1] [tmp / (val/:axis - tmp)]] 
            either axis = 'y [pane/1/size/y: tmp] [pane/1/size/x: tmp]
        ]
    ] 
    GRADIENT-SLIDER: SLIDER with [
        step: 1 
        gradient: none 
        set-gradient: func [face /local axis sz] [
            axis: face/axis 
            sz: face-size face 
            face/effect: compose/deep [
                draw [
                    pen none 
                    fill-pen checker-board.png 
                    box 0x0 (sz) 
                    fill-pen linear 0x0 normal 0 (sz/:axis) 0 1 1 (face/gradient) 
                    box 0x0 (sz)
                ]
            ]
        ] 
        access: make access [
            setup-face*: func [face value /local axis sz] [
                face/gradient: value 
                face/set-gradient face
            ] 
            set-face*: func [face value] [
                either block? value [
                    setup-face* face value
                ] [
                    face/data: value / 255
                ]
            ] 
            get-face*: func [face] [
                round face/data * 255
            ]
        ] 
        append init [
            access/setup-face* self setup 
            insert-actor-func self 'on-resize :set-gradient
        ]
    ] 
    SCROLLER: SLIDER spring [left] with [
        align: none 
        scroll-face: none 
        down-arrow: up-arrow: none 
        size: 20x100 
        speed: 20 
        edge: [size: 0x0] 
        feel: svvf/scroll 
        reset: does [data: 0] 
        resize: func [new /x /y /local tmp] [
            either any [x y] [
                if x [size/x: new] 
                if y [size/y: new]
            ] [
                size: any [new size]
            ] 
            tmp: pick [y x] axis = 'x 
            clip: pane/2/size: pane/3/size: size/:tmp - (2 * edge/size/:tmp) * 1x1 
            pane/3/offset: size/:axis - pane/3/size/:axis - (2 * edge/size/:axis) * 0x1 
            if tmp: axis = 'x [pane/3/offset: reverse pane/3/offset] 
            pane/2/data: pick [left up] tmp 
            pane/3/data: pick [right down] tmp 
            state: pane/2/effect: pane/3/effect: none 
            do pane/2/init do pane/3/init 
            pane/1/offset: 0x0 
            redrag any [ratio 0.1]
        ] 
        access: make access [
            key-face*: func [face event /local dir steps val] [
                val: get-face face 
                if find [up down left right] event/key [
                    dir: pick [-1 1] found? find [up left] event/key 
                    set-face face max 0 min 1 val + pick steps found? find [left up] event/key 
                    do-face face none
                ]
            ] 
            resize-face*: func [face size x y] [
                face/axis: pick [y x] size/y >= size/x 
                face/resize size
            ]
        ] 
        action: func [face value] [
            act-face face none 'on-scroll
        ] 
        init: [
            pane: reduce [
                make dragger [
                    edge: make edge [] 
                    feel: svvf/scroller-drag 
                    access: ctx-access/button
                ] 
                axis: make svv/vid-styles/arrow [
                    dir: -1 
                    edge: make edge [] 
                    action: get in svvf 'move-drag 
                    feel: make svvf/scroll-button []
                ] 
                make axis [dir: 1 edge: make edge []]
            ] 
            up-arrow: pane/1 
            down-arrow: pane/3 
            if colors [
                color: first colors pane/1/color: second colors 
                pane/2/colors: pane/3/colors: append copy at colors 2 pane/2/colors/2
            ] 
            axis: pick [y x] size/y >= size/x 
            if none? spring [spring: make block! 4] 
            if axis = 'x [spring: [top]] 
            spring: unique spring 
            resize size
        ]
    ]
] 
--- "VID Panel" 
stylize/master [
    COMPOUND: IMAGE fill 0x0 spring none with [
        font: none 
        access: ctx-access/compound 
        init: [
            pane: 
            layout/styles/tight 
            either all [function? :action not empty? second :action] [
                second :action
            ] [
                make block! []
            ] 
            copy self/styles 
            action: none 
            size: any [
                size 
                pane/size + (2 * edge-size self)
            ] 
            pane: pane/pane 
            set-parent-faces self
        ]
    ] 
    PANEL: COMPOUND fill 0x0 spring none with [
        feel: 
        setup: 
        path: 
        submit: 
        panes: 
        scroller-face: 
        word: 
        none 
        access: ctx-access/panel 
        size: none 
        add-pane: func [[catch] face word pane /local out] [
            if error? set/any 'err try [
                out: either face/styles [layout/styles/tight pane copy face/styles] [layout/tight pane] 
                out/color: none 
                out/spring: face/spring 
                out/align: face/align 
                out/fill: face/fill 
                out/parent-face: face 
                out/style: 'pane 
                set-parent-faces/parent out face
            ] [
                probe disarm err 
                throw make error! reform ["Layout error in pane" word]
            ] 
            repend face/panes [word out] 
            face/panes: back back tail face/panes
        ] 
        remove-pane: func [face word /local current] [
            current: face/panes 
            remove/part find head face/panes word 2 
            current
        ] 
        move-pane: func [face word offset] [
            current: face/panes 
            current
        ] 
        resize-pane: func [face /local faces pane] [
            pane: second face/panes 
            faces: pane/pane 
            all [block? faces empty? faces exit] 
            if pane/fill/x = 0 [
                pane/size/x: 0 
                repeat i length? faces [
                    pane/size/x: max pane/size/x faces/:i/offset/x + faces/:i/size/x
                ]
            ] 
            if pane/fill/y = 0 [
                pane/size/y: 0 
                repeat i length? faces [
                    pane/size/y: max pane/size/y faces/:i/offset/y + faces/:i/size/y
                ]
            ] 
            pane/real-size: pane/size: pane/size + faces/1/origin
        ] 
        init: [
            if all [
                not block? setup 
                function? :action 
                not empty? second :action
            ] [
                setup: reduce ['default second :action]
            ] 
            access/setup-face* self setup 
            action: none 
            word: any [default first setup] 
            access/set-panel-pane self word
        ]
    ] 
    LEFT-PANEL: PANEL spring [right] align [left] fill 0x1 
    LEFT-TOP-PANEL: PANEL spring [right bottom] align [left top] 
    LEFT-BOTTOM-PANEL: PANEL spring [right top] align [left bottom] 
    RIGHT-PANEL: PANEL spring [left] align [right] fill 0x1 
    RIGHT-TOP-PANEL: PANEL spring [left bottom] align [right top] 
    RIGHT-BOTTOM-PANEL: PANEL spring [left top] align [right bottom] 
    BOTTOM-PANEL: PANEL spring [top] align [bottom] fill 1x0 
    TOP-PANEL: PANEL spring [bottom] align [top] fill 1x0 
    CENTER-PANEL: PANEL spring [left right bottom top] align [center] 
    CENTER-TOP-PANEL: PANEL spring [left right bottom] align [left right top] 
    CENTER-BOTTOM-PANEL: PANEL spring [left right top] align [left right bottom] 
    CENTER-LEFT-PANEL: PANEL spring [right bottom top] align [left top bottom] 
    CENTER-RIGHT-PANEL: PANEL spring [left bottom top] align [right top bottom] 
    SCROLL-PANEL: COMPOUND with [
        compound: [
            across space 0 
            button "" 20x20 spring [left top] align [right bottom] 
            scroller 21x20 fill 1x0 align [left bottom] [scroll-face face/parent-face value none] 
            return 
            scroller 20x21 fill 0x1 align [right top] [scroll-face face/parent-face none value] 
            panel fill 1x1 align [top left]
        ] 
        panel-face: 
        nav-face: 
        h-scroller: 
        v-scroller: 
        none 
        faces: [nav-face h-scroller v-scroller panel-face] 
        panel-pane: 
        none 
        pane-spring: [right bottom] 
        pane-fill: 0x0 
        adjust-scrollers: func [face /local content] [
            content: face/panel-face/pane 
            if face/v-scroller [
                v-scroller/redrag min 1 face/panel-face/size/y / max 1 content/size/y
            ] 
            if face/h-scroller [
                h-scroller/redrag min 1 face/panel-face/size/x / max 1 content/size/x
            ]
        ] 
        add-pane: func [face word pane] [
            face/panel-face/add-pane face word pane 
            face/adjust-scrollers face
        ] 
        remove-pane: func [face word] [
            face/panel-face/remove-pane face word 
            face/adjust-scrollers face
        ] 
        move-pane: func [face word offset] [
            face/panel-face/move-pane face word offset 
            face/adjust-scrollers face
        ] 
        resize-pane: func [face] [
            face/panel-face/resize-pane face/panel-face 
            face/adjust-scrollers face
        ] 
        access: make access [
            set-face*: func [face value] [
                face/panel-face/access/set-face* face/panel-face value 
                if word? value [
                    face/access/scroll-face* 
                    face 
                    all [face/h-scroller get-face face/h-scroller] 
                    all [face/v-scroller get-face face/v-scroller]
                ] 
                face/adjust-scrollers face
            ] 
            get-face*: func [face] [
                face/panel-face/access/get-face* face/panel-face
            ] 
            setup-face*: func [face value] [
                face/panel-face/access/setup-face* face/panel-face value 
                face/adjust-scrollers face
            ] 
            scroll-face*: func [face x y /local content sz ssz] [
                content: face/panel-face/pane 
                sz: face-size face/panel-face 
                ssz: content/size 
                if x [
                    content/offset/x: min 0 negate ssz/x - sz/x * x
                ] 
                if y [
                    content/offset/y: min 0 negate ssz/y - sz/y * y
                ] 
                if tab-face: get in root-face face 'tab-face [
                    set-tab-face tab-face
                ]
            ]
        ] 
        init: [
            pane: layout/styles/tight compound copy self/styles 
            set :faces pane/pane 
            if all [
                not block? setup 
                function? :action 
                not empty? second :action
            ] [
                setup: reduce ['default second :action]
            ] 
            set-parent-faces self 
            panel-face/size: none 
            setup-face panel-face setup 
            size: any [
                size 
                add add add panel-face/size 
                any [all [v-scroller as-pair v-scroller/size/x 0] 0] 
                any [all [h-scroller as-pair 0 h-scroller/size/y] 0] 
                (2 * edge-size self)
            ] 
            pane: pane/pane 
            action: none 
            insert-actor-func self 'on-resize :resize-pane 
            word: any [default all [setup first setup]] 
            panel-face/access/set-panel-pane panel-face word 
            panel-face/pane/fill: pane-fill
        ]
    ] 
    H-SCROLL-PANEL: SCROLL-PANEL with [
        faces: [h-scroller panel-face] 
        pane-spring: [right] 
        pane-fill: 0x1 
        compound: [
            space 0 
            scroller 21x20 fill 1x0 align [left bottom] [scroll-face face/parent-face value none] 
            panel fill 1x1 align [top left] spring none
        ]
    ] 
    V-SCROLL-PANEL: H-SCROLL-PANEL with [
        faces: [v-scroller panel-face] 
        pane-spring: [bottom] 
        pane-fill: 1x0 
        compound: [
            across space 0 
            scroller 20x21 fill 0x1 align [top right] [scroll-face face/parent-face none value] 
            panel fill 1x1 align [top left] spring none
        ]
    ] 
    FRAME: PANEL 
    SCROLL-FRAME: SCROLL-PANEL 
    V-SCROLL-FRAME: V-SCROLL-PANEL 
    H-SCROLL-FRAME: H-SCROLL-PANEL 
    COLUMN: BOX EDGE NONE with [
        color: none 
        multi: make multi [
            block: func [
                face 
                blks 
                /local frame tt
            ] [
                if block? blks/1 [
                    frame: layout compose [
                        origin 0x0 
                        space 10x10 
                        below 
                        (blks/1)
                    ] 
                    face/pane: frame/pane 
                    unless face/size [face/real-size: none face/size: -1x-1] 
                    if face/size/x = -1 [
                        face/size/x: frame/size/x + any [all [face/edge/x 2 * face/edge/size/x] 0]
                    ] 
                    if face/size/y = -1 [
                        face/size/y: frame/size/y + any [all [face/edge/y 2 * face/edge/size/y] 0]
                    ]
                ]
            ]
        ]
    ] 
    TRANSPARENT-PANEL: PANEL 
    TAB-PANEL-FRAME: PANEL 
    TAB-PANEL: PANEL fill 1x1 with [
        access: make access ctx-access/tab-panel 
        tab-selector: none 
        tabs: none 
        panes: none 
        add-tab: func [face data] [
            face/tab-selector/add-item face/tab-selector copy/part data 3 
            face/pane/1/add-pane face/pane/1 data/1 data/4
        ] 
        remove-tab: func [face word /local m n] [
            all [
                face/tab-selector/remove-item face/tab-selector word 
                face/pane/1/remove-pane face/pane/1 word
            ]
        ] 
        move-tab: func [face name offset] [
            face/tab-selector/move-item face/tab-selector name offset 
            face/pane/1/move-pane face/pane/1 name offset
        ] 
        init: [
            access/setup-face* self setup 
            default: any [default all [not empty? setup first setup]] 
            access/set-face* self default
        ]
    ] 
    PICTURE: COMPOUND [
        space 0 across 
        pad 2x2 
        image white edge [size: 1x1] spring none 
        pad 0x2 
        box coal 2x98 spring [left] return 
        pad 4x-2 
        box coal 100x2 spring [top]
    ] with [
        access: make access [
            set-face*: func [face value] [
                if image? value [
                    face/pane/1/image: value 
                    show face
                ]
            ] 
            get-face*: func [face] [
                face/pane/1/size
            ]
        ]
    ] 
    WARNING-FRAME: FRAME 
    ACCORDION: V-SCROLL-PANEL with [
        access: make access [
            set-face*: func [face value] [
                either word? value [
                    set-face face/panel-face/pane value 
                    do-face face/panel-face/pane none
                ] [
                    set-face/no-show face/pane/1 value
                ]
            ] 
            get-face*: func [face] [
                get-face face/panel-face/pane
            ] 
            reset-face*: func [face] [
                set-face* face/panel-face/pane face/default
            ]
        ] 
        lo: none 
        fold-func: func [face] [
            fp: face/parent-face 
            fpp: fp/parent-face 
            fc: last fp/pane 
            fp/real-size/y: fp/size/y: fp/origin/y * 2 + fc/offset/y + fc/size/y 
            fpp/parent-face/resize-pane fpp/parent-face 
            fpp/parent-face/adjust-scrollers fpp/parent-face 
            show fpp/parent-face
        ] 
        insert init [
            if block? setup [
                lo: copy setup 
                insert clear setup [space 0] 
                use [b s t w] [
                    t: none 
                    parse lo [
                        any [
                            set w word! 
                            set s string! 
                            [set b block! | set b word! (b: get b)] (
                                insert tail setup compose/deep/only [
                                    fold-button (s) with [var: (to-lit-word w)] 
                                    compound (b)
                                ]
                            )
                        ]
                    ]
                ] 
                setup: reduce ['default setup]
            ]
        ] 
        append init [
            foreach fc panel-face/pane/pane [
                if fc/style = 'fold-button [
                    insert-actor-func fc 'on-click :fold-func
                ]
            ]
        ]
    ]
] 
--- "VID Dialog Button Groups" 
stylize/master [
    LEFT-BUTTON: BUTTON 
    RIGHT-BUTTON: BUTTON align [right] spring [left bottom] 
    CENTER-BUTTON: BUTTON align [left right] spring [left right] 
    TRUE-BUTTON: LEFT-BUTTON "True" [ctx-dialog/set-dialog-value face true] 
    FALSE-BUTTON: RIGHT-BUTTON "False" [ctx-dialog/set-dialog-value face false] 
    VALIDATE-BUTTON: TRUE-BUTTON "Validate" [ctx-dialog/dialog-use face] 
    OK-BUTTON: TRUE-BUTTON "OK" 
    YES-BUTTON: TRUE-BUTTON "Yes" 
    RETRY-BUTTON: TRUE-BUTTON "Retry" 
    SAVE-BUTTON: VALIDATE-BUTTON "Save" 
    USE-BUTTON: VALIDATE-BUTTON "Use" 
    SEND-BUTTON: VALIDATE-BUTTON "Send" 
    CANCEL-BUTTON: FALSE-BUTTON "Cancel" 
    CLOSE-BUTTON: CENTER-BUTTON "Close" [ctx-dialog/set-dialog-value face false] 
    NO-BUTTON: FALSE-BUTTON "No" 
    BTN-GROUP: COMPOUND fill 1x0 spring [top] 
    CLOSE: BTN-GROUP [bar close-button] 
    CANCEL: BTN-GROUP [bar cancel-button align [left right] spring [left right]] 
    OK-CANCEL: BTN-GROUP [across bar return ok-button cancel-button] 
    SAVE-CANCEL: BTN-GROUP [across bar return save-button cancel-button] 
    USE-CANCEL: BTN-GROUP [across bar return use-button cancel-button] 
    SEND-CANCEL: BTN-GROUP [across bar return send-button cancel-button] 
    YES-NO: BTN-GROUP [across bar return yes-button no-button] 
    YES-NO-CANCEL: BTN-GROUP [across bar return yes-button cancel-button align none no-button align none] 
    RETRY-CANCEL: BTN-GROUP [across bar return retry-button no-button cancel-button]
] 
--- "Improved VID Field" 
stylize/master [
    FIELD: FACE 200x24 spring [bottom] with [
        numeric-keys: key-action: false 
        key-range: range: none 
        color: none 
        max-length: -1 
        colors: reduce [svvc/field-color svvc/field-select-color] 
        disabled-colors: reduce [svvc/field-color - 20 svvc/field-select-color] 
        ctrl-keys: make bitset! [#"^H" #"^M" #"^~" #"^-" #" "] 
        font: [color: svvc/font-color/1 style: colors: shadow: none] 
        para: [wrap?: off] 
        feel: ctx-text/edit 
        access: ctx-access/field 
        flags: [field return tabbed on-unfocus input] 
        words: [
            hide [new/data: copy "" flag-face new hide args] 
            decimal [
                flag-face new decimal 
                flag-face new sign 
                new/key-range: make bitset! [#"0" - #"9" #"." #","] 
                new/ctrl-keys: difference new/ctrl-keys make bitset! [#" "] 
                args
            ] 
            integer [
                flag-face new integer 
                new/key-range: make bitset! [#"0" - #"9"] 
                new/ctrl-keys: difference new/ctrl-keys make bitset! [#" "] 
                args
            ] 
            range [new/range: reduce second args args: next args] 
            max-length [new/max-length: second args args: next args]
        ] 
        init: [
            if color [colors: reduce [color colors/2]] 
            if function? :action [
                insert-actor-func self 'on-unfocus :action 
                insert-actor-func self 'on-return :action
            ] 
            access/set-face* self any [text copy ""] 
            para: make para []
        ]
    ] 
    INFO: FIELD with [
        colors: 180.180.180 
        feel: ctx-text/swipe
    ] 
    NAME-FIELD: FIELD 
    COMPLETION-FIELD: FIELD with [
        list: make block! [] 
        match: list 
        sort list 
        complete: func [face] bind [
            set-face/no-show face copy first match 
            caret: highlight-start: at face/text index? caret 
            highlight-end: tail face/text 
            show face
        ] system/view 
        key-action: bind [
            case [
                'up = event/key [if find/match form pick match -1 copy/part get-face face caret [match: back match complete face]] 
                'down = event/key [if find/match form pick match 2 copy/part get-face face caret [match: next match complete face]] 
                all [not word? event/key ctrl-keys <> union ctrl-keys make bitset! event/key] [
                    forall list [
                        if find/match form first list get-face face [match: list complete face break]
                    ] 
                    list: head list
                ]
            ]
        ] system/view
    ] 
    SECURE-FIELD: FIELD with [
        access: make access [
            set-face*: func [face value] [
                if binary? value [face/data: value] 
                face/text: copy "*****"
            ] 
            get-face*: func [face] [face/data]
        ] 
        init: [
            old-value: copy "" 
            if color [colors: reduce [color colors/2]]
        ]
    ] 
    DATA-FIELD: FIELD with [
        ambiguous?: false 
        states: [ua fa u!a f!a] 
        current-state: 'u!a 
        state-event-block: [
            focus [fa fa f!a f!a] 
            dirty [ua u!a u!a u!a] 
            escape [ua ua u!a u!a] 
            many [ua fa ua fa] 
            one [u!a f!a u!a f!a]
        ] 
        set-state: func [event] [
            current-state: pick select state-block event index? find states current-state
        ] 
        actions: bind bind bind [
            fa [clear text font/color: black ambiguous: true] 
            ua [text: "<Multiple>" font/color: gray ambiguous: true] 
            f!a [font/color: black ambiguous: false] 
            u!a [font/color: black ambiguous: false]
        ] system/view ctx-text face
    ] 
    AREA: FIELD spring none with [
        para: make para [wrap?: true] 
        old-value: none 
        set-old-value: func [face] [face/old-value: copy get-face face] 
        access: make access [
            scroll-face*: func [face x y /local sz ssz lh] [
                ssz: face/text-body/size 
                sz: face/text-body/area 
                dsz: ssz - sz 
                lh: face/text-body/line-height 
                face/para/origin: 
                either 1 < abs y [
                    min 
                    face/para/margin 
                    max 
                    negate (dsz - face/para/margin) 
                    add 
                    face/para/origin 
                    negate lh * as-pair 
                    max -1 min 1 x 
                    max -1 min 1 y
                ] [
                    add 
                    face/para/margin 
                    negate 
                    as-pair 
                    dsz/x * x 
                    dsz/y * y
                ]
            ]
        ]
    ] 
    TEXT-AREA: COMPOUND spring none with [
        area: v-scroller: h-scroller: none 
        size: 200x200 
        set-scroller: func [face /local fc fp ft] [
            fc: either face/style = 'area [face] [face/area] 
            fp: either face/style = 'area [face/parent-face] [face] 
            ft: fc/text-body 
            fp/v-scroller/redrag ft/v-ratio 
            set-face fp/v-scroller ft/v-scroll 
            show fp/v-scroller 
            unless fc/para/wrap? [
                fp/h-scroller/redrag ft/h-ratio 
                set-face fp/h-scroller ft/h-scroll 
                show fp/h-scroller
            ]
        ] 
        access: make access [
            set-face*: func [face value] [
                set-face/no-show face/area value 
                face/set-scroller face
            ] 
            get-face*: func [face] [
                get-face face/area
            ] 
            resize-face*: func [face size x y /local sz] [
                sz: size 
                if face/h-scroller [sz/y: sz/y - face/h-scroller/size/y] 
                if face/v-scroller [sz/x: sz/x - face/v-scroller/size/x] 
                resize/no-show face/area sz 0x0 
                if face/h-scroller [
                    resize face/h-scroller as-pair sz/x face/h-scroller/size/y as-pair 0 sz/y
                ] 
                if face/v-scroller [
                    resize face/v-scroller as-pair face/v-scroller/size/x sz/y as-pair sz/x 0
                ] 
                set-scroller face
            ]
        ] 
        init: [
            pane: compose/deep/only [
                across space 0 
                area 100x100 spring none 
                scroller 20x100 spring [left] align [right] 
                on-scroll [scroll-face face/parent-face/area 0 value]
            ] 
            unless self/para/wrap? [
                append pane [
                    return 
                    scroller 100x20 spring [top] 
                    on-scroll [scroll-face face/parent-face/area value 0]
                ]
            ] 
            pane: layout/styles/tight pane copy self/styles 
            set-parent-faces self 
            panes: reduce ['default pane: pane/pane] 
            set [area v-scroller h-scroller] pane 
            if font [
                area/font: font
            ] 
            foreach act [on-key on-return on-escape on-tab] [
                insert-actor-func self act :set-scroller 
                area/actors/:act: self/actors/:act
            ] 
            deflag-face area tabbed 
            area/para/wrap?: para/wrap? 
            if string? text [
                access/set-face* self text 
                text: none
            ]
        ]
    ] 
    FULL-TEXT-AREA: TEXT-AREA with [
        append init [
            deflag-face area 'text-edit 
            flag-face area 'full-text-edit
        ]
    ] 
    CODE-TEXT-AREA: FULL-TEXT-AREA font [shadow: none color: black name: "courier"]
] 
--- "VID Labels" 
stylize/master [
    PLATE: BOX "Boiler Plate" fill 1x1 spring none 
    MINI-LABEL: LABEL center font-size 10 "Mini Label"
] 
--- "VID Construct" 
stylize/master [
    FACE-CONSTRUCT: FACE with [
        size: 60x60 
        emit: func [data] [insert tail lo data] 
        text: none 
        lo: make block! 1000 
        do-setup: none 
        access: ctx-access/face-construct 
        init: [
            if setup [
                access/setup-face* self setup
            ]
        ]
    ]
] 
--- "VID Selector" 
stylize/master [
    SELECTOR-TOGGLE: TOGGLE with [
        access: make access ctx-access/selector-nav
    ] 
    MULTI-SELECTOR-TOGGLE: SELECTOR-TOGGLE 
    SELECTOR: FACE-CONSTRUCT with [
        size: 200x24 
        setup: copy [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"] 
        spacing: 0 
        widths: none 
        calc-widths: func [n width /local widths l spaces error w] [
            if zero? n [return width] 
            spaces: n - 1 * spacing 
            width: width - spaces 
            w: round/floor width / n 
            widths: array/initial n w 
            error: width - (w * n) 
            if n > 1 [
                l: either even? n [
                    n
                ] [
                    round/ceiling n / 2
                ] 
                widths/:l: error + widths/:l
            ] 
            widths
        ] 
        do-setup: func [face input-value /local keys i] [
            keys: extract input-value 2 
            face/widths: face/calc-widths length? keys face/size/x 
            i: 0 
            emit [across space 0] 
            foreach [key value] input-value [
                i: i + 1 
                face/emit compose/deep [
                    selector-toggle (face/color) (as-pair face/widths/:i face/size/y) (value) of 'selection [
                        face/parent-face/dirty?: true 
                        set-face face/parent-face face/var 
                        do-face face/parent-face none 
                        validate-face face/parent-face
                    ] with [
                        var: (to-lit-word key) 
                        font: (make face/font []) 
                        para: (make face/para [])
                    ]
                ]
            ]
        ] 
        add-item: func [face data] [
            face/access/setup-face* face append face/setup data
        ] 
        remove-item: func [face word /local w] [
            any [w: find face/setup word return false] 
            face/access/setup-face* face head remove/part w any [find next w word! tail w]
        ] 
        words: reduce [
            'data func [new args] [
                all [
                    block? args 
                    new/data: args/2
                ] 
                next args
            ]
        ] 
        access: ctx-access/selector
    ] 
    MULTI-SELECTOR: SELECTOR with [
        default: copy data: make block! [] 
        setup: reduce ['choice1 "Choice 1" false 'choice2 "Choice 2" false 'choice3 "Choice 3" false] 
        do-setup: func [face input-value /local keys i clr] [
            clr: any [color 0.0.0] 
            keys: extract input-value 3 
            face/widths: face/calc-widths length? keys face/size/x 
            i: 0 
            face/emit [across space 0] 
            foreach [key text value] input-value [
                i: i + 1 
                face/emit compose/deep [
                    multi-selector-toggle (widths/:i) (text) (value) (clr) [
                        face/parent-face/dirty?: true 
                        alter face/parent-face/data face/var 
                        do-face face/parent-face none 
                        validate-face face/parent-face
                    ] with [var: (to-lit-word key)]
                ]
            ]
        ] 
        access: ctx-access/multi-selector
    ] 
    RADIO-SELECTOR: SELECTOR with [
        color: none 
        do-setup: func [face input-value /local first-key keys i] [
            keys: extract input-value 2 
            first-key: first input-value 
            i: 0 
            face/emit [space 0] 
            foreach [key value] input-value [
                i: i + 1 
                face/emit compose/deep [
                    radio-line (value) of 'selection with [
                        var: (to-lit-word key)
                    ] [
                        face/parent-face/dirty?: true 
                        face/parent-face/data: face/var 
                        do-face face/parent-face none 
                        validate-face face/parent-face
                    ]
                ]
            ]
        ]
    ] 
    CHECK-SELECTOR: MULTI-SELECTOR with [
        color: none 
        do-setup: func [face input-value /local keys i] [
            keys: extract input-value 2 
            i: 0 
            face/emit [space 0] 
            foreach [key text value] input-value [
                i: i + 1 
                face/emit compose/deep [
                    check-line (text) (value) with [
                        var: (to-lit-word key) 
                        font: (make face/font []) 
                        para: (make face/para [])
                    ] [
                        face/parent-face/dirty?: true 
                        alter face/parent-face/data face/var 
                        do-face face/parent-face none 
                        validate-face face/parent-face
                    ]
                ]
            ]
        ]
    ] 
    CHOICE: BUTTON font [color: black align: 'left] 150 with [
        setup: [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"] 
        feel: svvf/choice 
        access: make access [
            setup-face*: func [face value] [
                face/setup: value 
                if value [
                    face/data: copy face/setup 
                    set-face* face face/data/1
                ]
            ] 
            set-face*: func [face value /local val] [
                if val: find/skip head face/data value 2 [
                    face/data: val 
                    face/text: form select face/setup value
                ]
            ] 
            get-face*: func [face] [
                first face/data
            ] 
            resize-face*: func [face size x y /local pos] [
                if face/font/align = 'right [exit] 
                pos: none 
                if face/effect [
                    parse face/effect [
                        thru 'draw into ['image pos: pair!]
                    ]
                ] 
                if pos [
                    change pos as-pair size/x - 24 0
                ] 
                if face/choice-face [
                ]
            ]
        ] 
        choice-face: none 
        init: [
            effect: get in button-skin self load-stock 'arrow-pop color 'effect 
            choice-face: layout/tight [
                space 0 origin 0 caret-list 100x100 fill 1x1 
                on-key [
                    use [fp pop-face] [
                        fp: face/parent-face 
                        pop-face: fp/pop-face 
                        case [
                            find [up down] event/key [
                                unless empty? face/selected [
                                    if any [
                                        all [fp/offset/y < 0 event/key = 'up] 
                                        all [fp/offset/y + fp/size/y > fp/parent-face/size/y event/key = 'down]
                                    ] [
                                        fp/offset/y: face/choice-face-offset face pop-face
                                    ]
                                ]
                            ] 
                            find [#"^M" #" "] event/key [
                                face/close-choice-face face pop-face 
                                do-face pop-face none
                            ] 
                            #"^[" = event/key [
                                unset-menu-face pop-face
                            ]
                        ]
                    ]
                ] 
                on-click [
                    face/close-choice-face face face/parent-face/pop-face 
                    do-face face/parent-face/pop-face none
                ] 
                with [
                    render-func: func [face cell] [
                        case [
                            all [face/over face/over/y = cell/pos/y] [
                                cell/color: svvc/line-color 
                                cell/font/color: svvc/select-body-text-color
                            ] 
                            find face/selected cell/pos/y [
                                cell/color: svvc/select-color 
                                cell/font/color: svvc/select-body-text-color
                            ] 
                            true [
                                cell/color: svvc/menu-color 
                                cell/font/color: svvc/body-text-color
                            ]
                        ]
                    ] 
                    choice-face-offset: func [face pop-face /local y-size] [
                        y-size: pop-face/size/y - (2 * second edge-size pop-face) 
                        second pop-face/offset + as-pair 0 y-size - (y-size * face/selected/1)
                    ] 
                    close-choice-face: func [face pop-face] [
                        set-face pop-face pick pop-face/setup 2 * face/selected/1 - 1 
                        unset-menu-face pop-face
                    ] 
                    select-mode: 'mutex 
                    subface: [list-text-cell bold 100 fill 1x0 spring [bottom]]
                ]
            ] 
            subface: choice-face/pane/1/subface 
            subface/pane/1/real-size: subface/real-size: none 
            subface/pane/1/size: subface/size: size - (2 * edge-size face) 
            subface/pane/1/font: make self/font [] 
            access/setup-face* self setup
        ]
    ] 
    ROTARY: BUTTON with [
        data: copy [choice1 "Choice 1" choice2 "Choice 2" choice3 "Choice 3"] 
        edge: [size: 4x2 effect: 'bezel] 
        feel: svvf/rotary 
        access: ctx-access/data-find 
        insert init [if texts [data: texts]] 
        flags: [input] 
        words: [data [
                if all [block? args new/texts: args/2 not empty? new/texts] [new/text: first new/texts] 
                next args
            ]] 
        access: ctx-access/selector
    ] 
    TAB-SELECTOR: SELECTOR with [
        setup: [choice1 "Choice 1" 160.128.128 choice2 "Choice 2" 128.160.128 choice3 "Choice 3" 128.128.160] 
        do-setup: func [face input-value /local i] [
            i: 0 
            face/emit [across space 0] 
            foreach [pane text color] input-value [
                i: i + 1 
                face/emit compose/deep [
                    tab-button (text) (any [color svvc/menu-color]) of 'selection [
                        set-face/no-show face/parent-face (to-lit-word pane) 
                        do-face face/parent-face none
                    ]
                ]
            ]
        ]
    ]
] 
--- "VID Icon Face" 
stylize/master [
    ICON: FACE 64x64 with [
        font: [size: 11 align: 'center valign: 'bottom] 
        para: [wrap?: off] 
        feel: svvf/icon 
        saved-area: true 
        hold: none 
        color: none 
        ps: none 
        init: [
            if none? text [text: file] 
            if none? image [image: svv/icon-image] 
            hold: reduce [image file] 
            image: file: none 
            ps: size - 0x16 
            pane: make svv/vid-face [
                edge: make edge [size: 2x2 effect: 'bevel color: 128.128.128] 
                es: edge/size * 2 
                feel: svvf/subicon 
                image: first hold 
                file: second hold 
                size: ps - 4x0 
                if image [either outside? size image/size + es [effect: 'fit] [size: image/size + es]] 
                offset: ps - size / 2
            ]
        ]
    ]
] 
--- "Balancers and Resizers" 
stylize/master [
    BALANCER: FACE with [
        color: 0.0.0 
        axis: none 
        dir: none 
        before-face: after-face: none 
        before: func [face diff /local axis f new-size] [
            before-face: f: back-face face 
            axis: face/axis 
            if any [none? f f = face] [exit] 
            new-size: any [f/real-size f/size] 
            new-size/:axis: new-size/:axis + diff/:axis 
            resize/no-springs/no-show f new-size f/offset
        ] 
        after: func [face diff /local axis f new-size] [
            after-face: f: next-face face 
            if any [none? f f = face] [exit] 
            new-size: any [f/real-size f/size] 
            axis: face/axis 
            new-size/:axis: new-size/:axis - diff/:axis 
            f/offset/:axis: f/offset/:axis + diff/:axis 
            f/win-offset/:axis: f/win-offset/:axis + diff/:axis 
            resize/no-springs/no-show f new-size f/offset
        ] 
        feel: svvf/balancer 
        bar-size: 6 
        init: [
            either size [
                dir: pick [x y] size/y >= size/x 
                axis: pick [x y] dir = 'x 
                bar-size: size/:axis 
                spring
            ] [
                size: as-pair bar-size 100 
                dir: 'y 
                axis: 'x
            ] 
            spring: pick [[right] [bottom]] axis = 'x 
            fill: 1x1 
            fill/:axis: 0 
            size/:axis: bar-size
        ]
    ] 
    RESIZER: BALANCER with [
        after: func [face diff /local faces] [
            faces: next find face/parent-face/pane face 
            if tail? faces [exit] 
            axis: face/axis 
            foreach f faces [
                f/offset/:axis: f/offset/:axis + diff/:axis 
                f/win-offset/:axis: f/win-offset/:axis + diff/:axis
            ]
        ] 
        feel: svvf/resizer
    ]
] 
--- "VID Date Field" 
stylize/master [
    DATE-FIELD: COMPOUND 200x24 spring [bottom right] with [
        font: face/font 
        multi: make multi [
            text: func [face blk] [
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
                        face/pane/3/text '- 
                        face/pane/2/text '- 
                        face/pane/1/text
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
            button 24x0 fill 0x1 "..." [
                use [fp d] [
                    all [
                        fp: face/parent-face 
                        d: request-date/date get-face fp 
                        set-face fp d 
                        do-face fp none
                    ]
                ]
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
            button 24x0 fill 0x1 "..." [
                use [fp d] [
                    all [
                        fp: face/parent-face 
                        d: request-date/date any [attempt [to date! get-face fp] now] 
                        set-face fp d 
                        do-face fp none
                    ]
                ]
            ]
        ] 
        access: make access [
            set-face*: func [face value /local time] [
                value: attempt [to-date value] 
                unless value [exit] 
                unless face/pane [exit] 
                set-face/no-show face/pane/1 value/day 
                set-face/no-show face/pane/2 value/month 
                set-face/no-show face/pane/3 value/year 
                if value/time [
                    set-face/no-show face/pane/4 value/time/1 
                    set-face/no-show face/pane/5 value/time/2 
                    set-face/no-show face/pane/6 to-integer value/time/3
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
    DATE-WEEKDAY-CELL: IMAGE with [
        data: none 
        colors: none 
        init: [
            colors: reduce [
                font/color 
                255.255.255 - font/color
            ]
        ]
    ] 
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
                if date? value [
                    face/data: value 
                    face/text: form value/day
                ] 
                face/color: svvc/day-color 
                if block? value [
                    either find value 'out-of-month [
                        face/color: svvc/out-of-month-color
                    ] [
                        if find value 'weekend [
                            face/color: svvc/weekend-color
                        ] 
                        if find value 'selected [
                            face/color: face/color + 20
                        ] 
                        if find value 'day [
                            face/color: svvc/today-color
                        ]
                    ]
                ]
            ] 
            get-face*: func [face] [
                face/data
            ]
        ]
    ] 
    DATE-MONTH: COMPOUND with [
        dates: none 
        sunday: false 
        color: svvc/grid-color 
        access: make access [
            set-face*: func [face value /local i] [
                if date? value [face/data: value/date] 
                start-date: face/data 
                start-date: start-date - start-date/day + 1 
                start-date: start-date - start-date/weekday + 1 
                i: 0 
                foreach day face/pane [
                    either i < 7 [
                        day/text: copy/part pick system/locale/days i + 1 2
                    ] [
                        set-face/no-show day current-date: start-date + i - 7 
                        set-face/no-show day reduce [
                            if current-date/month <> face/data/month ['out-of-month] 
                            if find [6 7] current-date/weekday ['weekend] 
                            if current-date = face/data ['day]
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
            repeat i 7 [
                insert tail pane 'date-weekday-cell
            ] 
            insert tail pane 'return 
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
            ] 
            scroll-face*: func [face x y] [
                set-face* face face/data/month: face/data/month + pick [1 -1] positive? y 
                act-face face none 'on-scroll
            ]
        ]
    ]
] 
--- "Indicators for VID" 
stylize/master [
    PROGRESS: IMAGE 100.100.100 200x16 spring [bottom] with [
        range: [0 1] 
        feel: svvf/progress 
        access: ctx-access/data-number 
        access: make access [
            resize-face*: func [face size x y] []
        ] 
        font: none 
        para: none 
        data: 0 
        bar: make system/view/vid/vid-face [
            offset: 0x0 
            color: 0.80.200 
            edge: font: para: none
        ] 
        init: [
            if image? image [
                if none? size [size: image/size] 
                if size/y < 0 [size/y: size/x * image/size/y / image/size/x effect: insert copy effect 'fit] 
                if color [effect: join effect ['colorize color]]
            ] 
            if none? size [size: 100x100] 
            pane: make bar [] 
            pane/size: size 
            either size/x > size/y [pane/size/x: 1] [pane/size/y: 1] 
            if colors [color: first colors pane/color: second colors]
        ]
    ] 
    LED: CHECK 12x12 with [
        feel: svvf/led 
        set [font para] none 
        colors: reduce [green red]
    ]
] 
--- "VID Pop Face" 
stylize/master [
    POP-FACE: FACE 200x24 spring [horizontal] with [
        color: none 
        btn-action: [do-face face/parent-face none] 
        pane: make block! [] 
        access: make access [
            set-face*: func [face value] [
                face/data: value 
                set-face/no-show face/pane/1 value
            ] 
            get-face*: func [face] [face/data]
        ] 
        flags: [input] 
        init: [
            pane: reverse make-pane [
                across space 0 
                button 24x24 "..." spring [left bottom] align [right] btn-action 
                info fill 1x0 align [left]
            ] 
            set-face self data
        ]
    ] 
    POP-WINDOW: POP-FACE with [
        content: none 
        result: none 
        window: none 
        btn-action: [
            if face/content [
                inform face/window: make-window compose/deep face/content
            ] 
            if face/window/data [
                set-face face face/window/data 
                do-face face face/window/data
            ]
        ]
    ] 
    POP-WINDOW-LIST: POP-WINDOW with [
        title: none 
        list-specs: none 
        content: [
            origin 4 space 2 
            h3 (title) 
            bar 
            list-view spring [horizontal vertical] with [(list-specs)] 
            bar spring [top horizontal] 
            ok-group
        ]
    ] 
    POP-FILE: POP-FACE with [
        access: make access [
            set-face*: func [face value] [
                face/data: all [value to-file value] 
                set-face/no-show face/pane/1 value
            ]
        ] 
        btn-action: [
            use [file] [
                file: request-file/file/only attempt [all [get-face face/parent-face to-file get-face face/parent-face]] 
                if file [
                    set-face face/parent-face file 
                    do-face face/parent-face none
                ]
            ]
        ]
    ] 
    POP-LIST: POP-FACE with [
    ]
] 
--- "Form Related Styles" 
stylize/master [
    VALID-INDICATOR: IMAGES 24x24 spring [left bottom] with [
        images: reduce [
            'not-validated load-stock 'validation-not-validated 
            'valid load-stock 'validation-valid 
            'invalid load-stock 'validation-invalid 
            'not-required load-stock 'validation-not-required 
            'required load-stock 'validation-required 
            'attention load-stock 'validation-attention
        ]
    ] 
    VALIDATE-OLD: FACE with [
        size: 0x0 
        valid: none 
        validation: none 
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
            set [init no-show] value 
            face: back-face fc 
            enabler: back-face face 
            any [enabler/style = 'enabler enabler: none] 
            if all [enabler not get-face enabler] [return 'not-required] 
            indicator: next-face fc 
            either flag-face? face panel [
                validate-face face
            ] [
                if function? get in fc 'validation [
                    fc/valid: fc/validation face get-face face 
                    if indicator/style = 'valid-indicator [
                        result: switch/default fc/valid reduce [
                            true ['valid] 
                            false ['invalid] 
                            none ['invalid]
                        ] [
                            fc/valid
                        ] 
                        either no-show [
                            set-face/no-show indicator result
                        ] [
                            set-face indicator result
                        ]
                    ]
                ] 
                case [
                    logic? fc/valid [fc/valid] 
                    word? fc/valid [
                        select reduce [
                            'not-required true 
                            'valid true 
                            'required false 
                            'invalid false
                        ] fc/valid
                    ] 
                    true [to-logic fc/valid]
                ]
            ]
        ] 
        required: func [value] [pick [required valid] empty? value] 
        init: []
    ] 
    ENABLER: CHECK 24x24 [
        use [nf] [
            nf: next-face face 
            either get-face face [
                enable-face nf 
                set-tab-face focus nf
            ] [
                disable-face nf 
                clear-face nf
            ] 
            validate-init-face nf
        ]
    ] 
    EMBED: FACE with [
        font: none 
        size: 0x0 
        access: ctx-access/data 
        init: []
    ]
] 
--- "Untitled" 
stylize/master [
    ITERATED-FACE: BLANK-FACE fill 1x0 spring [bottom] 
    ITERATED-TEXT: TEXT fill 1x0 spring [bottom] 
    ITERATED-TXT: TXT fill 1x0 spring [bottom] 
    LIST-CELL: TEXT with [
        text: none 
        size: 0x20 
        font: make font [valign: 'middle] 
        para: make para [wrap?: false] 
        pos: 0x0 
        feel: make face/feel [
            over: func [face act pos] [
                face/parent-face/parent-face/over: all [act face/pos] 
                show face
            ] 
            engage: func [face act event /local lst] [
                lst: face/parent-face/parent-face 
                if act = 'down [
                    if all [
                        in lst 'select-func 
                        any-function? get in lst 'select-func
                    ] [
                        lst/select-func face event
                    ] 
                    do-face lst face/pos 
                    act-face lst event 'on-click
                ]
            ]
        ]
    ] 
    LIST-TEXT-CELL: LIST-CELL 
    LIST-TREE-CELL: LIST-CELL with [
    ] 
    LIST-IMAGE-CELL: LIST-CELL 
    LIST: IMAGE with [
        subface: 
        pane: 
        v-scroller: 
        h-scroller: 
        selected: 
        filter-spec: 
        sort-direction: 
        sort-column: 
        data: 
        data-index: 
        data-sorted: 
        data-filtered: 
        data-display: 
        columns: 
        column-order: 
        output: 
        none 
        spacing: 0 
        over: 
        spring: none 
        make-subface: func [face lo /local fs] [
            fs: face/subface: layout/parent/origin/styles lo iterated-face 0x0 copy face/styles 
            fs/parent-face: face 
            fs/size/y: fs/size/y - face/spacing 
            if face/size [fs/size/x: face/size/x] 
            set-parent-faces/parent fs face 
            align fs
        ] 
        list-size: func [face] [
            to-integer 
            face/size/y - (any [attempt [2 * face/edge/size/y] 0]) / face/subface/size/y
        ] 
        follow: func [face pos /local idx range size] [
            any [pos exit] 
            range: sort reduce [
                index? face/output 
                min length? face/data subtract add index? face/output size: face/list-size face 1
            ] 
            case [
                all [pos >= range/1 pos <= range/2] [exit] 
                pos < range/1 [face/output: at head face/output pos] 
                pos >= range/2 [face/output: at head face/output pos - size + 1]
            ]
        ] 
        calc-ratio: func [face] [
            divide face/list-size face max 1 length? head face/output
        ] 
        calc-pos: func [face] [
            divide subtract index? face/output 1 max 1 (length? head face/output) - face/list-size face
        ] 
        map-type: func [type] [
            any [
                select [
                    number! list-text-cell 
                    string! list-text-cell 
                    image! list-image-cell
                ] to-word type 
                'list-text-cell
            ]
        ] 
        select-row: func [face indexes] [
            insert clear head face/selected indexes 
            remove-each idx face/selected 
            face/update face
        ] 
        pane-func: func [face [object!] id [integer! pair!] /local count fs spane sz] [
            fs: face/subface id 
            if pair? id [return 1 + second id / fs/size] 
            fs/offset: fs/old-offset: id - 1 * fs/size * 0x1 
            sz: size/y - any [attempt [2 * face/edge/size/y] 0] 
            if fs/offset/y > sz [return none] 
            count: 0 
            foreach item fs/pane [
                if object? item [
                    face/cell-func 
                    face 
                    item 
                    id 
                    count: count + 1 
                    fs/offset/y + fs/size/y <= sz
                ]
            ] 
            fs
        ] 
        cell-func: func [face cell row col render /local fp r] [
            cell/pos: as-pair col row - 1 + index? face/output 
            r: either all [render row <= length? face/output] [
                pick pick face/output row col
            ] [
                copy ""
            ] 
            if function? :render-func [
                render-func face cell
            ] 
            set-face/no-show cell r
        ] 
        render-func: func [face cell] [
            either find face/selected cell/pos/y [
                cell/color: 
                either flag-face? face disabled [
                    svvc/select-disabled-color
                ] [
                    svvc/select-color
                ] 
                cell/font/color: svvc/select-body-text-color
            ] [
                cell/color: svvc/field-color 
                cell/font/color: 
                either flag-face? face disabled [
                    svvc/body-text-disabled-color
                ] [
                    svvc/body-text-color
                ]
            ] 
            if odd? cell/pos/y [
                cell/color: cell/color - 10
            ]
        ] 
        update: func [face] [
            ctx-list/set-filtered face 
            show face
        ] 
        select-mode: 'multi 
        start: end: none 
        select-func: func [face event /local s step] [
            if tail? at data face/pos/y [exit] 
            switch select-mode [
                mutex [
                    append clear selected start: end: face/pos/y
                ] 
                multi [
                    case [
                        event/shift [
                            either start [
                                step: pick [1 -1] start < end 
                                for i start end step [remove find selected i] 
                                step: pick [1 -1] start < end: face/pos/y 
                                for i start face/pos/y step [
                                    append selected i
                                ]
                            ] [
                                append selected start: end: face/pos/y
                            ]
                        ] 
                        event/control [
                            alter selected start: end: face/pos/y
                        ] 
                        true [
                            append clear selected start: end: face/pos/y
                        ]
                    ]
                ] 
                persistent [
                    alter selected start: end: face/pos/y
                ]
            ] 
            sel: copy selected 
            selected: head insert head clear selected unique sel 
            show self
        ] 
        key-select-func: func [face event /local out s step] [
            if find [up down] event/key [
                out: head output 
                dir: pick [1 -1] event/key = 'down 
                if event/control [dir: dir * list-size face] 
                if empty? out [clear selected return false] 
                either empty? selected [
                    append selected start: end: 1
                ] [
                    case [
                        all [select-mode <> 'mutex event/shift] [
                            step: pick [1 -1] start < end 
                            for i start end step [remove find selected i] 
                            step: pick [1 -1] start < (end: end + dir) 
                            end: max 1 min length? out end 
                            for i start end step [insert tail selected i]
                        ] 
                        true [
                            start: either start [first append clear selected end + dir] [1] 
                            start: end: max 1 min length? out start 
                            selected/1: start
                        ]
                    ]
                ] 
                follow face end
            ] 
            sel: copy selected 
            selected: head insert head clear selected unique sel
        ] 
        access: make access [
            clamp-list: func [face /local sz] [
                if all [
                    not head? face/output 
                    greater? sz: face/list-size face length? face/output
                ] [
                    face/output: skip tail face/output negate sz
                ]
            ] 
            key-face*: func [face event /local old] [
                old: copy face/selected 
                face/key-select-func face event 
                if old <> face/selected [
                    do-face face none 
                    act-face face event 'on-key
                ]
            ] 
            scroll-face*: func [face x y /local old size] [
                old: face/output 
                size: face/list-size face 
                face/output: 
                either 1 < abs y [
                    skip face/output pick [1 -1] positive? y
                ] [
                    at head face/output add y * subtract length? face/data size 1
                ] 
                clamp-list face 
                not-equal? index? old index? face/output
            ] 
            get-face*: func [face /local vals] [
                case [
                    none? face/selected [none] 
                    empty? face/selected [none] 
                    face/select-mode = 'mutex [
                        pick head face/data-filtered first face/selected
                    ] 
                    true [
                        vals: make block! length? face/selected 
                        foreach pos face/selected [
                            append/only vals pick head face/data-filtered pos
                        ] 
                        vals
                    ]
                ]
            ] 
            resize-face*: func [face size x y] [
                resize 
                face/subface 
                as-pair 
                face/size/x 
                face/subface/size/y 
                face/subface/offset 
                clamp-list face
            ] 
            set-face*: func [face data] [
                clear face/selected 
                face/data: data 
                ctx-list/set-filtered face
            ] 
            clear-face*: func [face] [
                clear face/selected 
                clear face/data 
                ctx-list/set-filtered face
            ]
        ] 
        init: [
            case [
                all [subface columns] [
                ] 
                all [not subface columns] [
                    subface: make block! 100 
                    foreach column columns [
                        append subface map-type column/type
                    ]
                ] 
                all [not subface not columns] [
                    either block? data [
                        unless empty? data [
                            subface: make block! 100 
                            switch/default type?/word data/1 [
                                object! [
                                    foreach item first data/1 [
                                        append subface map-type type? item
                                    ]
                                ] 
                                block! [
                                    foreach item data/1 [
                                        append subface map-type type? item
                                    ]
                                ]
                            ] [
                                append subface map-type type? data/1
                            ]
                        ]
                    ] [
                        subface: [list-text-cell 100x20 spring [bottom] fill 1x0]
                    ]
                ]
            ] 
            make-subface self any [subface attempt [second :action] [list-text-cell]] 
            if none? size [
                size: 300x200 
                size/x: subface/size/x + first edge-size? self
            ] 
            unless block? column-order [
                column-order: make block! [] 
                repeat i length? subface/pane [
                    append column-order to-word join 'column- i
                ]
            ] 
            case [
                all [subface not columns] [
                    columns: make block! [] 
                    repeat i length? subface/pane [
                        append columns to-word join 'column- i 
                        append columns none
                    ]
                ]
            ] 
            if none? data [data: make block! []] 
            output: copy data-sorted: copy data-index: copy data-filtered: copy data-display: make block! length? data 
            ctx-list/set-filtered self 
            any [block? selected selected: make block! []] 
            pane: :pane-func
        ]
    ] 
    CARET-LIST: LIST with [
        key-select-func: func [face event /local out s step] [
            if find [up down] event/key [
                out: head output 
                dir: pick [1 -1] event/key = 'down 
                if event/control [dir: dir * list-size face] 
                if empty? out [face/over: none clear face/selected return false] 
                face/over: either face/over [0x1 * dir + face/over] [1x1] 
                face/over: min max 1x1 face/over to-pair length? out 
                follow face face/over/y
            ] 
            if find [#" " #"^M"] event/key [
                append clear face/selected face/over/y
            ]
        ]
    ] 
    REVERSE-LIST: LIST with [
    ] 
    NAV-LIST: PANEL with [
        list: 
        pane: 
        data: 
        columns: 
        column-order: 
        subface: 
        text: 
        none 
        access: make access [
            get-face*: func [face] [
                if face/list [get-face face/list]
            ]
        ]
    ] 
    DATA-LIST: NAV-LIST with [
        header: 
        v-scroller: 
        h-scroller: 
        none 
        select-mode: 'multi 
        access: make access [
            set-scroller: func [face /only] [
                face/v-scroller/ratio: face/list/calc-ratio face/list face/v-scroller 
                face/v-scroller/redrag face/v-scroller/ratio 
                any [only set-face/no-show face/v-scroller face/list/calc-pos face/list]
            ] 
            past-end?: func [face] [
                all [
                    not head? face/list/output 
                    greater? 
                    face/list/list-size face/list 
                    length? face/list/output
                ]
            ] 
            key-face*: func [face event] [
                key-face face/list event 
                set-scroller face
            ] 
            set-face*: func [face data] [
                set-face/no-show face/list data 
                set-scroller face
            ] 
            clear-face*: func [face] [
                clear-face/no-show face/list data 
                set-scroller face
            ] 
            scroll-face*: func [face x y] [
                scroll-face face/list x y 
                set-scroller face
            ]
        ] 
        update: func [face] [
            face/list/update face/list
        ] 
        init: [
            pane: layout/tight compose/deep/only [
                across space 0 
                scroller 20x100 fill 0x1 align [right] [
                    scroll-face face/parent-face/list 0 get-face face 
                    face/parent-face/access/set-scroller/only face/parent-face
                ] on-resize [
                    any [
                        face/parent-face/access/past-end? face/parent-face 
                        face/parent-face/access/set-scroller face/parent-face
                    ]
                ] 
                list fill 1x1 align [left] 
                [do-face face/parent-face none] 
                with [
                    subface: (subface) 
                    data: (data) 
                    columns: (columns) 
                    column-order: (column-order)
                ]
            ] 
            reverse pane/pane 
            set-parent-faces self 
            any [size size: pane/size + any [all [object? edge 2 * edge/size] 0]] 
            panes: reduce ['default pane: pane/pane] 
            set [list v-scroller] pane 
            selected: list/selected 
            list/select-mode: select-mode 
            access/set-scroller self
        ]
    ] 
    SORT-BUTTON: BUTTON 
    SORT-RESET-BUTTON: SORT-BUTTON 
    LIST-HEADER: LIST 
    TABLE: LIST 
    TEXT-LIST: LIST 
    PARAMETER-LIST: DATA-LIST with [
        access: make access [
            set-face*: func [face data /local values] [
                either object? data [
                    values: make block! length? first data 
                    foreach [word value] third data [
                        repend/only values [
                            word 
                            either all [series? :value greater? index? :value length? head :value] [
                                "Past End"
                            ] [
                                form :value
                            ]
                        ]
                    ]
                ] [
                    values: data
                ] 
                set-face/no-show face/list values 
                set-scroller face
            ]
        ] 
        subface: [
            across space 1x1 
            list-text-cell bold spring [bottom right] right 100 200.200.200 
            list-text-cell 180 spring [bottom]
        ]
    ]
] 
iterated-face: get-style 'iterated-face 
--- "VID Search Faces" 
stylize/master [
    SEARCH-FIELD: COMPOUND with [
        content: [
            across space 0 
            field 150 spring none on-key [get in face 'action] 
            button 24x24 "X" [
                context [
                    f: face/parent-face/pane/1 
                    clear-face f 
                    do-face f none
                ]
            ]
        ]
    ]
] 
--- "Super Styles" 
stylize/master [
    LAYOUT-COLOR: COMPOUND [
        style rgb-slider gradient-slider spring [bottom] 200x20 [
            face/parent-face/set-rgb-value face/parent-face face/channel value 
            if value? 'call-back [call-back face/parent-face/data]
        ] 
        style fl field integer font-size 11 30x20 spring [left bottom] [
            set-face back-face face get-face face 
            do-face back-face face none
        ] 
        style lbl label 75x20 
        across 
        lbl "Red" rgb-slider setup [0.0.0 127.0.0 255.0.0] with [channel: 'r] fl return 
        lbl "Green" rgb-slider setup [0.0.0 0.127.0 0.255.0] with [channel: 'g] fl return 
        lbl "Blue" rgb-slider setup [0.0.0 0.0.127 0.0.255] with [channel: 'b] fl return 
        lbl "Alpha" rgb-slider setup [0.0.0 0.0.0.127 0.0.0.255] with [channel: 'a] fl
    ] with [
        set-rgb-value: func [face word value /local idx] [
            idx: index? find [r g b a] word value 
            face/data/:idx: value 
            idx: idx - 1 * 3 + 3 
            set-face face/sliders/:idx value
        ] 
        set-slider: func [face value] [
            set-face/no-show face value 
            set-face/no-show next-face face value
        ] 
        data: 0.0.0.0 
        access: make access [
            set-face*: func [face value] [
                any [tuple? value exit] 
                face/data: add 0.0.0.0 value 
                foreach [idx chn] [2 1 5 2 8 3 11 4] [
                    set-slider face/sliders/:idx face/data/:chn
                ]
            ] 
            get-face*: func [face] [
                to-tuple reduce [
                    get-face face/sliders/2 
                    get-face face/sliders/5 
                    get-face face/sliders/8 
                    get-face face/sliders/11
                ]
            ] 
            clear-face*: func [face] [
                set-face* face 0.0.0
            ]
        ] 
        sliders: none 
        append init [
            sliders: self/pane 
            set-face self data
        ]
    ] 
    LAYOUT-DATE: COMPOUND [
        across 
        arrow left [
            val: get-face face/parent-face 
            val/month: val/month - 1 
            set-face face/parent-face val
        ] 
        arrow right align [right] spring [left bottom] [
            val: get-face face/parent-face 
            val/month: val/month + 1 
            set-face face/parent-face val
        ] 
        text bold fill 1x0 center align [left right] spring [bottom] 
        return 
        date-nav-month 
        spring [left right] 
        on-scroll [set-face face/parent-face/pane/3 get-face face] 
        on-key [set-face face/parent-face/pane/3 get-face face] 
        on-click [set-face face/parent-face/pane/3 get-face face]
    ] with [
        access: make access [
            set-face*: func [face value] [
                if date? value [
                    face/data: value 
                    set-face face/pane/3 form value 
                    set-face face/pane/4 value
                ]
            ] 
            get-face*: func [face] [
                get-face face/pane/4
            ]
        ]
    ] 
    LAYOUT-USER: PANEL [
        across 
        label "User Name" field return 
        label "Password" field hide
    ] 
    LAYOUT-PASS: PANEL [
        across 
        label "Password" field hide
    ] 
    LAYOUT-LISTS: COMPOUND [
        data-list 300x200
    ] with [
        access: make access [
            set-face*: func [face value] [
                if block? value [
                    set-face/no-show face/pane/1 value
                ]
            ] 
            get-face*: func [face] [
                get-face face/pane/1
            ]
        ]
    ] 
    LAYOUT-LIST: LAYOUT-LISTS [
        data-list 300x200 with [select-mode: 'mutex]
    ] 
    LAYOUT-DIR: COMPOUND [
        data-list 200x200
    ] 
    LAYOUT-DOWNLOAD: COMPOUND [
        text 300 center 
        progress fill 1x0
    ] 
    LAYOUT-DOWNLOADS: COMPOUND [
        text 300 center 
        progress fill 1x0 
        text 300 center 
        progress fill 1x0
    ] 
    LAYOUT-VALUE: PANEL [
        label "Enter Value" return 
        field
    ] 
    LAYOUT-TEXT: PANEL [
        label "Enter Text" return 
        text-area
    ] 
    LAYOUT-RENAME: PANEL [
        across 
        label "Old Name" info return 
        label "New Name" field return
    ] 
    LAYOUT-EMAIL: COMPOUND [
        across 
        label "To" field validate [not empty? get-face face] required valid-indicator return 
        label "Subject" field validate [not empty? get-face face] required valid-indicator return 
        label "Text Body" text-area return
    ] 
    LAYOUT-MESSAGE: COMPOUND [
        across 
        label "To" field validate [not empty? get-face face] required valid-indicator return 
        label "Text Body" text-area return
    ] 
    LAYOUT-FIND: COMPOUND [
        across 
        label "Search for" field return 
        label "" check-line "Case Sensitive" return
    ] 
    LAYOUT-REPLACE: COMPOUND [
        across 
        label "Search for" field return 
        label "Replace with" field return 
        label "" check-line "Case Sensitive" return
    ] 
    LAYOUT-INLINE-FIND: COMPOUND [
        right-panel [
            across label 70 "Search for" 
            field 150 on-key [search-face face/parent-face/searched-face get-face face] 
            text 100 "No results" 
            space 0 
            arrow 24x24 up [back-result face/parent-face] 
            arrow down 24x24 [next-result face/parent-face]
        ] return
    ] with [
        searched-face: none 
        next-result: func [face /local results] [
            results: face/searched-face/results 
            any [result exit] 
            face/searched-face/results: either tail? next results [head results] [next results]
        ] 
        prev-result: func [face /local results] [
            results: face/searched-face/results 
            any [results exit] 
            face/searched-face/results: either head? results [back tail results] [back results]
        ] 
        get-result: func [face value] [
            search-face face/searched-face value
        ]
    ] 
    LAYOUT-QUESTION: COMPOUND [
        across 
        frame spring [right] 75x75 [
            image help.gif align [center] spring [left right top bottom]
        ] 
        panel fill 1x1 [body 200 fill 1x1 spring none]
    ] with [
        access: make access [
            set-face*: func [face value] [
                set-face find-style face 'body value
            ]
        ]
    ] 
    LAYOUT-ALERT: LAYOUT-QUESTION [
        across 
        frame spring [right] 75x75 [
            image exclamation.gif align [center] spring [left right top bottom]
        ] 
        panel fill 1x1 [body 200x75 font-size 14 bold spring none]
    ] 
    LAYOUT-WARNING: LAYOUT-QUESTION [
        warning-frame [
            origin 4 
            across 
            frame spring [right] 75x75 [
                image exclamation.gif align [center] spring [left right top bottom]
            ] 
            panel fill 1x1 [body 200x75 font-size 14 bold spring none]
        ]
    ] 
    LAYOUT-NOTIFY: LAYOUT-QUESTION [
        across 
        frame spring [right] 75x75 [
            image info.gif align [center] spring [left right top bottom]
        ] 
        panel fill 1x1 [body 200x75 bold spring none]
    ] 
    LAYOUT-ABOUT: PANEL [
        across 
        frame 300x200 [
            vh2 white 300 center spring [left right bottom] 
            v-scroll-panel fill 1x1 [body -1x0 fill 1x1 center]
        ]
    ] with [
        vh2: body: v-panel: none 
        append init [
            header: system/script/header 
            vh2: find-style self 'vh2 
            v-panel: find-style self 'v-scroll-panel 
            body: find-style self 'body 
            set-face/no-show vh2 header/title 
            set-face/no-show body trim to-string reduce [
                "Version: " header/version newline 
                "Copyright: " header/copyright newline 
                "License: " trim header/license newline 
                "Date: " header/date newline 
                "Author: " header/author/1 newline 
                newline 
                trim reverse trim reverse header/purpose
            ]
        ]
    ]
] 
--- "Styles for Window Management" 
stylize/master [
    WINDOW-BUTTON: BUTTON 20x24 with [text: none] [
        face/manage: to-block face/manage 
        foreach manage face/manage [
            do 
            get in 
            face/parent-face/parent-face/parent-face 
            manage 
            face/parent-face/parent-face/parent-face 
            face/parent-face
        ]
    ] 
    WINDOW-TITLE: WINDOW-BUTTON "Window" with [
        dragging: false 
        old-offset: new-offset: 0x0 
        access: ctx-access/text 
        feel: svvf/window-manage
    ] 
    WINDOW-MANAGER: PANEL with [
        arrange: func [face windows arrangement /no-show /local i] [
            i: 0 
            foreach [size offset] arrangement [
                i: i + 1 
                face/restore/no-show face windows/:i 
                resize/no-springs/no-show windows/:i size offset
            ] 
            any [no-show show face]
        ] 
        tile: func [face /only windows /no-show /local tiles width] [
            face/arrange/no-show face windows tiles 
            any [no-show show face]
        ] 
        h-tile: func [face /only windows /no-show /local offset width tiles] [
            windows: any [windows face/pane/pane] 
            if empty? windows [exit] 
            width: face/size/x / length? windows 
            offset: as-pair negate width 0 
            tiles: make block! length? windows 
            repeat i length? windows [repend tiles [as-pair width face/size/y offset: as-pair offset/x + width 0]] 
            face/arrange/no-show face windows tiles 
            any [no-show show face]
        ] 
        v-tile: func [face /only windows /no-show /local offset height tiles] [
            windows: any [windows face/pane/pane] 
            if empty? windows [exit] 
            height: face/size/y / length? windows 
            offset: as-pair 0 negate height 
            tiles: make block! length? windows 
            repeat i length? windows [repend tiles [as-pair face/size/x height offset: as-pair 0 offset/y + height]] 
            face/arrange/no-show face windows tiles 
            any [no-show show face]
        ] 
        to-front: func [face window /no-show] [
            move/to find face/pane/pane window length? head face/pane/pane 
            any [no-show show window]
        ] 
        to-back: func [face window /no-show] [
            move/to find face/pane/pane window 1 
            any [no-show show window]
        ] 
        activate: func [face window /no-show] [
            any [no-show show face]
        ] 
        maximize: func [face window /no-show] [
            window/spring: none 
            window/original-offset: window/offset 
            window/original-size: window/size 
            window/maximize-face/effect: effect-window-restore 
            resize/no-show window face/size 0x0 
            any [no-show show face]
        ] 
        iconify: func [face window /no-show] [
            any [no-show show window]
        ] 
        deiconify: func [face window /no-show] [
        ] 
        fold: func [face window /no-show /local edge min-size] [
            edge: second (2 * edge-size window) 
            min-size: window/title-face/size/y + edge 
            either probe window/size/y = min-size [
                window/fold-face/effect: effect-window-fold 
                window/size/y: window/content-face/size/y + window/content-face/offset/y + edge
            ] [
                window/fold-face/effect: effect-window-unfold 
                window/size/y: min-size
            ] 
            any [no-show show window]
        ] 
        restore: func [face window /no-show] [
            any [window/original-size exit] 
            resize/no-springs/no-show window window/original-size window/original-offset 
            window/spring: [bottom right] 
            window/original-size: none 
            window/original-offset: none 
            window/maximize-face/effect: probe effect-window-maximize 
            any [no-show show face]
        ] 
        toggle-max: func [face window /no-show] [
            either window/original-size [
                face/restore/no-show face window
            ] [
                face/maximize/no-show face window
            ] 
            any [no-show show face]
        ] 
        close: func [face window /no-show] [
            remove find face/pane/pane window 
            any [no-show show face]
        ] 
        new: func [face title content /size sz /type /offset os win-type /no-show /local window] [
            window: make get-style 'rebol-window compose/only [
                title: (title) 
                action: (content) 
                do bind init self 
                init: none 
                spring: none
            ] 
            if os [window/offset: os] 
            set-parent-faces/parent window face/pane 
            append face/pane/pane window 
            system/words/align/no-show window 
            resize/no-show window any [sz window/size] window/offset 
            window/spring: [right bottom] 
            any [no-show show face]
        ]
    ] 
    REBOL-ICON-WINDOW: FACE spring [right bottom] with [
    ] 
    REBOL-WINDOW: COMPOUND spring [right bottom] with [
        color: svvc/window-background-color 
        size: none 
        access: make access [
            set-face*: func [face value] [
                case [
                    string? value [set-face/no-show face/title-face value] 
                    any-block? value [set-face/no-show face/content-face value]
                ]
            ] 
            get-face*: func [face] [
                get-face face/content-face
            ]
        ] 
        original-offset: none 
        original-size: none 
        extra: none 
        icon-face: 
        content-face: 
        corner-face: 
        iconify-face: 
        maximize-face: 
        fold-face: 
        close-face: 
        title-face: 
        none 
        faces: [close-face title-face fold-face iconify-face maximize-face content-face] 
        compound: [
            across 
            space 0 
            window-button effect effect-window-close spring [right bottom] tool-tip "Close Window" with [manage: 'close] 
            window-title spring [bottom] with [manage: [to-front activate]] 
            window-button effect effect-window-fold spring [left bottom] tool-tip "Fold Window" with [manage: 'fold] 
            window-button effect effect-window-iconify spring [left bottom] tool-tip "Iconify Window" with [manage: 'iconify] 
            window-button effect effect-window-maximize spring [left bottom] tool-tip "Maximize Window" with [manage: 'toggle-max] 
            return 
            compound 100x100 (content)
        ] 
        content: none 
        x-glyph-size: none 
        y-glyph-size: none 
        init: [
            content: either all [function? :action not empty? second :action] [
                second :action
            ] [
                make block! []
            ] 
            pane: layout/styles/tight compound copy self/styles 
            set :faces pane/pane 
            set-parent-faces self 
            x-glyph-size: y-glyph-size: 0 
            if title-face [y-glyph-size: y-glyph-size + title-face/size/y] 
            size: any [
                size 
                content-face/size + 
                (2 * edge-size self) + 
                as-pair x-glyph-size y-glyph-size
            ] 
            pane: pane/pane 
            action: none
        ]
    ] 
    REBOL-DIALOG-WINDOW: REBOL-WINDOW with [
        pane: [
            across 
            space 0 
            window-button effect effect-window-close spring [right bottom] tool-tip "Close Window" with [manage: 'close] 
            window-title spring [bottom] with [manage: [to-front activate]] 
            window-button effect effect-window-fold spring [left bottom] tool-tip "Fold Window" with [manage: 'fold] 
            window-button effect effect-window-iconify spring [left bottom] tool-tip "Iconify Window" with [manage: 'iconify] 
            window-button effect effect-window-maximize spring [left bottom] tool-tip "Maximize Window" with [manage: 'toggle-max] 
            return 
            panel 100x100
        ] 
        init-content-face: func [face content-face] [
            system/words/align content-face 
            extra: 2 * edge-size face 
            pane/spring: none 
            set-parent-faces self 
            any [
                pair? face/size 
                face/size: max 100x100 content-face/size + extra
            ]
        ]
    ]
] 
--- "VID Styles" 
normal-edge: [color: svvc/window-background-color + 5 size: 2x2 effect: 'bevel] 
disabled-normal-edge: [image: standard-edge.png size: 2x2 effect: [extend 2 2 contrast -30 luma 50]] 
narrow-edge: [color: svvc/window-background-color size: 1x2 effect: 'bevel] 
horizontal-edge: [color: svvc/window-background-color size: 0x2 effect: 'bevel] 
field-edge: [color: svvc/window-background-color + 5 size: 2x2 effect: 'ibevel] 
disabled-field-edge: [image: standard-edge.png size: 2x2 effect: [invert extend 2 2 contrast -30 luma 50]] 
read-only-edge: [color: svvc/line-color size: 2x2 effect: none] 
frame-edge: [color: svvc/frame-background-color size: 2x2 effect: 'ibevel] 
mini-edge: [color: svvc/window-background-color size: 1x1] 
tip-edge: [color: svvc/tool-tip-edge-color size: 1x1] 
warning-edge: [size: 2x2 color: 240.240.0 effect: [tile colorize 100.100.100] image: load-stock 'blocked] 
window-edge: [size: 1x1 color: svvc/line-color effect: none] 
system/view/vid/vid-space: 2x2 
system/view/vid/vid-origin: 4x4 
no-stretch: [spring: none] 
stretch-x: [spring: [bottom]] 
stretch-xy: [spring: none] 
stretch-fill: [spring: none fill: 1x1] 
disabled-effect: [brightness 1 contrast -1] 
effect-window-close: [draw [anti-alias off pen black line-width 1 line 4x6 11x13 line 11x6 4x13]] 
effect-window-fold: [draw [pen black fill-pen black box 3x8 12x11]] 
effect-window-unfold: [draw [anti-alias off pen black fill-pen black box 3x8 12x16]] 
effect-window-maximize: [draw [anti-alias off pen black box 3x5 12x14 fill-pen black box 3x5 12x7]] 
effect-window-restore: [draw [anti-alias off pen black box 3x7 12x12 fill-pen black box 3x7 12x9]] 
effect-window-iconify: [draw [pen black fill-pen black box 3x12 7x16]] 
effect-window-resize: [draw [anti-alias off pen black fill-pen black triangle 4x13 13x13 13x4]] 
stylize/master [
    LABEL: LABEL 100x24 right black shadow none 
    MINI-LABEL: MINI-LABEL black shadow none 
    TEXT: TEXT 100x24 font [valign: 'middle] with stretch-x 
    FORM-TEXT: TEXT svvc/body-text-color snow para [wrap?: false] edge read-only-edge 
    LED: LED edge field-edge 
    DUMMY: DUMMY edge read-only-edge 
    BACKDROP: BACKDROP svvc/window-background-color with stretch-fill 
    GROUP: PANEL fill 1x0 spring [top] 
    FRAME: FRAME svvc/frame-background-color edge frame-edge 
    WARNING-FRAME: WARNING-FRAME edge warning-edge 
    SCROLL-FRAME: SCROLL-FRAME edge frame-edge 
    H-SCROLL-FRAME: H-SCROLL-FRAME edge frame-edge 
    V-SCROLL-FRAME: V-SCROLL-FRAME edge frame-edge 
    TAB-PANEL-FRAME: PANEL edge normal-edge 
    DATA-LIST: DATA-LIST edge frame-edge 
    PARAMETER-LIST: PARAMETER-LIST edge frame-edge 
    AREA: AREA edge field-edge with stretch-xy 
    FIELD: FIELD edge field-edge 
    INFO: INFO edge field-edge 
    NAME-FIELD: NAME-FIELD edge field-edge 
    COMPLETION-FIELD: COMPLETION-FIELD edge field-edge 
    DATA-FIELD: DATA-FIELD edge field-edge 
    SECURE-FIELD: SECURE-FIELD edge field-edge 
    LINE: BOX svvc/line-color 2x2 
    BAR: LINE fill 1x0 spring [bottom] 
    VLINE: LINE fill 0x1 spring [right] 
    CHECK: CHECK 24x24 
    RADIO: RADIO 24x24 
    CHOICE: CHOICE svvc/action-color edge normal-edge 
    ROTARY: ROTARY svvc/action-color edge [color: 160.160.160 effect: 'bevel] 
    TOGGLE: TOGGLE svvc/action-color edge normal-edge 
    STATE: STATE svvc/action-color edge normal-edge 
    SELECTOR-TOGGLE: SELECTOR-TOGGLE svvc/action-color edge normal-edge 
    MULTI-SELECTOR-TOGGLE: MULTI-SELECTOR-TOGGLE svvc/action-color edge narrow-edge 
    ARROW: ARROW svvc/manipulator-color edge normal-edge 
    BUTTON: BUTTON svvc/action-color edge normal-edge 
    ACT-BUTTON: BUTTON svvc/action-color edge normal-edge 
    FOLD-BUTTON: FOLD-BUTTON svvc/action-color edge normal-edge 
    HIGHLIGHT-BUTTON: BUTTON svvc/important-color with [font: make font [colors: svvc/important-font-color shadow: 1x1]] 
    MINI-BUTTON: BUTTON 100x20 font-size 10 edge mini-edge 
    TOOL-BUTTON: BUTTON edge [size: 1x1 color: 100.100.100] 50x20 
    ICON-BUTTON: BUTTON 24x24 edge none with [init: []] 
    GLYPH-BUTTON: BUTTON 24x24 edge normal-edge 
    BOTTOM-BUTTON: BUTTON with [spring: [top]] 
    CENTER-BUTTON: BUTTON with [align: [left right]] 
    SAVE-BUTTON: SAVE-BUTTON svvc/true-color edge normal-edge 
    VALIDATE-BUTTON: VALIDATE-BUTTON svvc/true-color edge normal-edge 
    LEFT-BUTTON: LEFT-BUTTON svvc/true-color edge normal-edge 
    TRUE-BUTTON: TRUE-BUTTON svvc/true-color edge normal-edge 
    RETRY-BUTTON: RETRY-BUTTON svvc/true-color edge normal-edge 
    USE-BUTTON: USE-BUTTON svvc/true-color edge normal-edge 
    SEND-BUTTON: SEND-BUTTON svvc/true-color edge normal-edge 
    OK-BUTTON: OK-BUTTON svvc/true-color edge normal-edge 
    YES-BUTTON: YES-BUTTON svvc/true-color edge normal-edge 
    CANCEL-BUTTON: CANCEL-BUTTON svvc/false-color edge normal-edge 
    RIGHT-BUTTON: RIGHT-BUTTON svvc/false-color edge normal-edge 
    FALSE-BUTTON: FALSE-BUTTON svvc/false-color edge normal-edge 
    NO-BUTTON: NO-BUTTON svvc/false-color edge normal-edge 
    CLOSE-BUTTON: CLOSE-BUTTON svvc/false-color edge normal-edge 
    POP-BUTTON: POP-BUTTON 24x24 svvc/action-color edge normal-edge 
    SORT-BUTTON: SORT-BUTTON -1x20 svvc/manipulator-color font [color: black shadow: none] 
    SORT-RESET-BUTTON: SORT-RESET-BUTTON svvc/action-color edge none 
    COLOR-BUTTON: COLOR-BUTTON edge normal-edge 
    DATE-WEEKDAY-CELL: DATE-WEEKDAY-CELL 
    svvc/weekday-color 30x30 with [font: make font [color: svvc/weekday-font-color shadow: none size: 12]] 
    DATE-CELL: DATE-CELL 30x30 with [font: make font [color: svvc/day-font-color shadow: none size: 12]] 
    SELECTOR: SELECTOR svvc/action-color with [font: make font [shadow: none size: 12 style: 'bold align: 'center]] 
    MULTI-SELECTOR: MULTI-SELECTOR svvc/action-color with [font: make font [shadow: none size: 12 style: 'bold align: 'center]] 
    PROGRESS: PROGRESS edge field-edge 
    SCROLLER: SCROLLER coal svvc/manipulator-color with [
        dragger: make dragger [edge: make face/edge normal-edge]
    ] 
    SLIDER: SLIDER edge field-edge 
    GRADIENT-SLIDER: GRADIENT-SLIDER edge field-edge 
    BALANCER: BALANCER svvc/frame-background-color edge field-edge 
    RESIZER: RESIZER svvc/frame-background-color edge field-edge 
    LIST-HEADER: LIST-HEADER edge normal-edge 
    REBOL-WINDOW: REBOL-WINDOW edge window-edge 
    REBOL-DIALOG-WINDOW: REBOL-DIALOG-WINDOW edge window-edge 
    WINDOW-BUTTON: WINDOW-BUTTON svvc/action-color edge normal-edge 
    WINDOW-TITLE: WINDOW-TITLE svvc/action-color edge normal-edge
] 
--- "VID Style Flags" 
foreach [style flags] face-flags: [
    WINDOW [panel action] 
    RESIZABLE-WINDOW [panel action] 
    FACE [] 
    BLANK-FACE [] 
    IMAGE [] 
    IMAGES [] 
    BACKDROP [fixed drop] 
    BACKTILE [fixed drop] 
    BOX [] 
    BAR [] 
    SENSOR [] 
    KEY [] 
    BASE-TEXT [text] 
    VTEXT [text] 
    TEXT [flags text font] 
    BODY [flags text] 
    TXT [flags text] 
    BANNER [flags text font] 
    VH1 [flags text font] 
    VH2 [flags text font] 
    VH3 [flags text] 
    VH4 [flags text font] 
    LABEL [flags text font] 
    VLAB [flags text font] 
    LBL [flags text font] 
    LAB [flags text font] 
    TITLE [flags text font] 
    H1 [flags text font] 
    H2 [flags text font] 
    H3 [flags text font] 
    H4 [flags text font] 
    H5 [flags text] 
    TT [flags text font] 
    CODE [flags text font] 
    FORM-TEXT [flags text font input] 
    PLATE [] 
    BUTTON [tabbed action] 
    ACT-BUTTON [tabbed action] 
    FOLD-BUTTON [tabbed action] 
    LEFT-BUTTON [tabbed action] 
    RIGHT-BUTTON [tabbed action] 
    VALIDATE-BUTTON [tabbed action] 
    TRUE-BUTTON [tabbed action close-true] 
    OK-BUTTON [tabbed action close-true] 
    SAVE-BUTTON [tabbed action close-true] 
    USE-BUTTON [tabbed action close-true] 
    YES-BUTTON [tabbed action close-true] 
    RETRY-BUTTON [tabbed action close-true] 
    CANCEL-BUTTON [tabbed action close-false] 
    FALSE-BUTTON [tabbed action close-false] 
    CLOSE-BUTTON [tabbed action close-false] 
    NO-BUTTON [tabbed action close-false] 
    GLYPH-BUTTON [tabbed action] 
    POP-BUTTON [tabbed action] 
    MINI-BUTTON [tabbed action] 
    TOOL-BUTTON [tabbed action] 
    ICON-BUTTON [tabbed action] 
    BOTTOM-BUTTON [tabbed action] 
    CENTER-BUTTON [tabbed action] 
    HIGHLIGHT-BUTTON [tabbed action] 
    COLOR-BUTTON [tabbed action] 
    OK-CANCEL [compound action] 
    SAVE-CANCEL [compound action] 
    USE-CANCEL [compound action] 
    CLOSE [compound action] 
    CANCEL [compound action] 
    YES-NO [compound action] 
    YES-NO-CANCEL [compound action] 
    RETRY-CANCEL [compound action] 
    CHECK [tabbed action check input changes] 
    CHECK-MARK [tabbed action check input changes] 
    ENABLER [tabbed action check] 
    RADIO [tabbed action radio input changes] 
    CHECK-LINE [tabbed action flags input check font changes] 
    RADIO-LINE [tabbed action flags input radio font changes] 
    LED [input] 
    ARROW [action] 
    TAB-BUTTON [tabbed action toggle] 
    TOGGLE [tabbed action toggle changes] 
    STATE [tabbed action toggle changes] 
    ROTARY [tabbed action input changes] 
    CHOICE [tabbed action input changes] 
    ICON [tabbed action input] 
    FIELD [tabbed action text-edit field return input cancel changes on-unfocus] 
    DUMMY [input] 
    INFO [text-edit field input] 
    AREA [internal action text-edit input changes scrollable] 
    TEXT-AREA [tabbed action compound input changes] 
    FULL-TEXT-AREA [tabbed action compound input changes] 
    CODE-TEXT-AREA [tabbed action compound input changes] 
    DATE-FIELD [input action compound changes] 
    DATE-TIME-FIELD [input action compound changes] 
    DATE-CELL [internal action input action] 
    DATE-WEEKDAY-CELL [internal] 
    DATE-MONTH [input action compound] 
    DATE-NAV-MONTH [tabbed scrollable input action compound changes] 
    SLIDER [tabbed action input changes] 
    GRADIENT-SLIDER [tabbed action input changes] 
    SCROLLER [internal action compound] 
    PROGRESS [input] 
    COMPOUND [panel compound] 
    PANEL [panel] 
    TRANSPARENT-PANEL [panel transparent] 
    FRAME [panel] 
    WARNING-FRAME [panel] 
    CENTER-PANEL [panel] 
    RIGHT-PANEL [panel] 
    BOTTOM-PANEL [panel] 
    SCROLL-PANEL [panel action scrollable] 
    V-SCROLL-PANEL [panel action scrollable] 
    H-SCROLL-PANEL [panel action scrollable] 
    SCROLL-FRAME [panel action scrollable] 
    V-SCROLL-FRAME [panel action scrollable] 
    H-SCROLL-FRAME [panel action scrollable] 
    TAB-PANEL [panel action] 
    SELECTOR-TOGGLE [tabbed toggle action] 
    MULTI-SELECTOR-TOGGLE [tabbed toggle action] 
    SELECTOR [compound action input changes] 
    MULTI-SELECTOR [panel compound action input changes] 
    TAB-SELECTOR [panel compound action input] 
    RADIO-SELECTOR [panel compound action input changes] 
    CHECK-SELECTOR [panel compound action input changes] 
    SEARCH-FIELD [text-edit action field return input] 
    LIST-CELL [flags text font action input] 
    LIST-TEXT-CELL [flags text font action input] 
    LIST-IMAGE-CELL [action input] 
    LIST [iterated action] 
    CARET-LIST [iterated action] 
    REVERSE-LIST [iterated action] 
    DATA-LIST [tabbed action compound scrollable] 
    PARAMETER-LIST [tabbed action compound scrollable] 
    TEXT-LIST [tabbed action compound flags text as-is input] 
    ANIM [] 
    LOGO-BAR [] 
    VALID-INDICATOR [] 
    LAYOUT-COLOR [panel action] 
    LAYOUT-DATE [panel action] 
    LAYOUT-USER [panel action] 
    LAYOUT-PASS [panel action] 
    LAYOUT-LIST [panel action] 
    LAYOUT-DIR [panel action] 
    LAYOUT-RENAME [panel action] 
    LAYOUT-DOWNLOAD [panel] 
    LAYOUT-DOWNLOADS [panel] 
    LAYOUT-VALUE [panel action] 
    LAYOUT-EMAIL [panel action] 
    LAYOUT-MESSAGE [panel action] 
    LAYOUT-FIND [panel action] 
    LAYOUT-REPLACE [panel action] 
    LAYOUT-INLINE-FIND [panel action] 
    LAYOUT-QUESTION [panel] 
    LAYOUT-ALERT [panel] 
    LAYOUT-WARNING [panel] 
    LAYOUT-NOTIFY [panel] 
    LAYOUT-ABOUT [panel]
] [
    if error? try [
        set in get-style style 'flags flags
    ] [
        make error! rejoin ["Error when setting flags for style " style]
    ]
] 
--- "VID Style Tags" 
foreach [style tags] [
    FACE [internal] 
    BLANK-FACE [] 
    IMAGE [] 
    IMAGES [] 
    BACKDROP [] 
    BACKTILE [] 
    BOX [] 
    BAR [] 
    SENSOR [data-only] 
    KEY [data-only] 
    BASE-TEXT [internal] 
    VTEXT [text] 
    TEXT [text] 
    BODY [text] 
    TXT [text] 
    BANNER [text] 
    VH1 [text] 
    VH2 [text] 
    VH3 [text] 
    VH4 [text] 
    LABEL [text] 
    VLAB [text] 
    LBL [text] 
    LAB [text] 
    TITLE [text] 
    H1 [text] 
    H2 [text] 
    H3 [text] 
    H4 [text] 
    H5 [text] 
    TT [text] 
    CODE [text] 
    FORM-TEXT [text] 
    PLATE [text] 
    BUTTON [text] 
    ACT-BUTTON [text] 
    TRUE-BUTTON [text] 
    FALSE-BUTTON [text] 
    CLOSE-BUTTON [text] 
    POP-BUTTON [text] 
    MINI-BUTTON [text] 
    TOOL-BUTTON [text] 
    ICON-BUTTON [text] 
    BOTTOM-BUTTON [text] 
    CENTER-BUTTON [text] 
    HIGHLIGHT-BUTTON [text] 
    CHECK [] 
    CHECK-MARK [deprecated] 
    ENABLER [] 
    RADIO [] 
    CHECK-LINE [] 
    RADIO-LINE [] 
    LED [] 
    ARROW [] 
    TAB-BUTTON [] 
    TOGGLE [] 
    ROTARY [] 
    CHOICE [] 
    ICON [] 
    FIELD [text] 
    DUMMY [] 
    INFO [text] 
    AREA [text] 
    DATE-FIELD [text] 
    DATE-TIME-FIELD [text] 
    SLIDER [] 
    SCROLLER [] 
    PROGRESS [] 
    PANEL [] 
    TAB-PANEL [] 
    SELECTOR-TOGGLE [] 
    SELECTOR [] 
    TAB-SELECTOR [] 
    RADIO-SELECTOR [] 
    SEARCH-FIELD [text] 
    LIST [text iterated] 
    TABLE [text iterated] 
    TEXT-LIST [text iterated] 
    DATA-LIST [text iterated] 
    ANIM [] 
    VALID-INDICATOR [] 
    OK-CANCEL [compound] 
    CLOSE [compound]
] [
    if error? try [
        set in get-style style 'tags tags
    ] [
        make error! rejoin ["Error when setting tags for style " style]
    ]
]