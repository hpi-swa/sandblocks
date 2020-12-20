as yet unclassified
testMatchesCtrlAlt

	| shortcut |
	shortcut := $v command withCtrl.
	self assert: (shortcut matchesEvent: (SBTest keyboardEvent: $v shift: false command: true control: true))