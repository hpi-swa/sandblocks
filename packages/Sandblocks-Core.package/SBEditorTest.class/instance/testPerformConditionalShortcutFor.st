as yet unclassified
testPerformConditionalShortcutFor

	| editor block |
	block := SBMockBlock new.
	editor := self editorFor: block.
	editor
		shortcutsOverride: {($a asSandblockShortcut -> #conditionalMockAction)};
		performShortcutFor: $a asSandblockShortcut.
	self deny: block mockActionTaken.
	block actionValid: true.
	editor performShortcutFor: $a asSandblockShortcut.
	self assert: block mockActionTaken