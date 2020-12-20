actions
selectNextGroup
	<multiSelectAction>

	| oldCursorPos |
	oldCursorPos := self currentTextMorph ifNotNil: [:m | m cursorPosition] ifNil: [self center].
	
	self sandblockEditor keepVerticalSelectionPositionDuring: [
		(self nextVerticalNear: self sandblockEditor verticalSelectionPosition)
			ifNotNil: #select
			ifNil: [
				SBLabel text: [
					'Artefacts typically contain all their nodes, so none are below them'].
				self isArtefact ifTrue: [self selectNext]]].
	self sandblockEditor maybeStartInputNear: oldCursorPos