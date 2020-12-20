as yet unclassified
testMatchesShiftCommandComma

	| shortcut |
	shortcut := $, shift withCommand.
	self assert: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: true command: true)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: false command: true)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: false command: false)).
	self deny: (shortcut matchesEvent: (SBTest keyboardEvent: $, shift: true command: false))