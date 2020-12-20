actions input
moveCursorUp
	<inputAction>

	self textMorph moveCursorVertically: -1 ifAtBound: [ | next |
		next := self selection previousVerticalNear: self sandblockEditor verticalSelectionPosition.
		next ifNotNil: [self startInput: next at: 9e8 replacingContents: false]]