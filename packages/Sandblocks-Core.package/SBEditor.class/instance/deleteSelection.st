actions
deleteSelection

	self setCopyBuffer: self multiSelection.
	
	self doMultiSelectionEach: [:selected |
		selected parentSandblock deleteCommandFor: selected]