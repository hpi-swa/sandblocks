actions
deleteBlock
	<multiSelectAction>

	self assert: self isSelected.
	self sandblockEditor
		copyBuffer: self sandblockEditor multiSelection;
		doMultiSelectionEach: [:selected |
			selected parentSandblock deleteCommandFor: selected];
		maybeStartInputFromEnd