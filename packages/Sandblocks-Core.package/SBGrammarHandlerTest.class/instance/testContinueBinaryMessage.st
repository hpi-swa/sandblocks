tests
testContinueBinaryMessage

	| block editor send |
	send := SBMessageSend new receiver: SBUnknown new selector: #+ arguments: {SBUnknown new}.
	block := '[]' parseAsSandblock.
	editor := self editorFor: block.
	block addMorphBack: send.
	editor startInput: send at: 0 replacingContents: false.
	editor selection keyStroke: (self keyboardEvent: $+).
	self assert: (block statements first isMessageSend and: [block statements first = send])