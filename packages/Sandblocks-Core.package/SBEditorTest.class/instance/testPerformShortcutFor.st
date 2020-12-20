as yet unclassified
testPerformShortcutFor

	| block |
	block := SBMockBlock new.
	(self editorFor: block)
		shortcutsOverride: {($a asSandblockShortcut -> #mockAction)};
		performShortcutFor: $a asSandblockShortcut.
	self assert: block mockActionTaken