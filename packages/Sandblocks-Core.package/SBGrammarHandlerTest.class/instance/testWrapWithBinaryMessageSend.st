tests
testWrapWithBinaryMessageSend

	| block editor |
	{
		SBNumber new contents: '123'.
		SBName new contents: 'abc'.
		SBMessageSend new receiver: SBUnknown new selector: #abc arguments: #()
	} do: [:leaf |
		block := '[]' parseAsSandblock.
		editor := self editorFor: block.
		block addMorphBack: leaf.
		editor startInput: leaf at: 0 replacingContents: false.
		editor selection keyStroke: (self keyboardEvent: $+).
		self assert: (block statements first isMessageSend and: [block statements first ~= leaf])]