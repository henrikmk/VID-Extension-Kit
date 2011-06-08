;-- Base Colors

focus-ring-color:			20.120.230 ; focus ring
body-text-color:			black ; general text in fields, infos, etc.
body-text-disabled-color:	gray ; general text in fields, infos, etc. with disabled text
select-body-text-color:		white ; general selected text color
title-text-color:			black ; general banner texts
field-color:				snow - 5
field-select-color:			yello
window-background-color:	180.180.180
menu-color:					window-background-color + 20
frame-background-color:		window-background-color - 20
line-color:					window-background-color - 100
menu-text-color:			[0.0.0 0.75.150 255.255.255]
important-color:			brick					; color for important elements
manipulator-color:			200.200.200				; arrows, scrollbars
glyph-color:				black					; popup, arrow
action-color:				200.200.200 ; action items, like buttons
true-color:					80.180.80 ; true buttons
false-color:				180.180.180 ; false buttons
action-colors:				reduce [action-color action-color]
disabled-action-colors:		reduce [action-color - 50 action-color - 50]
select-color:				focus-ring-color ; general selection color
select-disabled-color:		120.120.120
font-color:					reduce [black focus-ring-color - 75] ; general text in buttons, etc.
important-font-color:		reduce [white important-color + 100] ; text in elements using important-color

;-- Tool tips
tool-tip-background-color:	white
tool-tip-edge-color:		black

;-- Calendar Specific
grid-color:					140.140.140
today-color:				select-color
day-color:					snow
day-font-color:				black
weekend-color:				yello
out-of-month-color:			180.180.180
weekday-color:				black
weekday-font-color:			snow
appointment-color:			orange