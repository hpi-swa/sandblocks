actions
selectPreviousGroup
	<multiSelectAction>

	| oldCursorPos |
	oldCursorPos := self currentTextMorph ifNotNil: [:m | m cursorPosition] ifNil: [self center].
	
	self sandblockEditor keepVerticalSelectionPositionDuring: [
		(self previousVerticalNear: self sandblockEditor verticalSelectionPosition) ifNotNil: #select].
	oldCursorPos ifNil: [self sandblockEditor maybeStartInputFromStart] ifNotNil: [self sandblockEditor maybeStartInputNear: oldCursorPos]