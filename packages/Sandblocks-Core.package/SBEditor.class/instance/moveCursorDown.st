actions input
moveCursorDown
	<inputAction>

	self textMorph moveCursorVertically: 1 ifAtBound: [ | next |
		next := self selection nextVerticalNear: self sandblockEditor verticalSelectionPosition.
		next ifNotNil: [self startInput: next at: 9e8 replacingContents: false]]