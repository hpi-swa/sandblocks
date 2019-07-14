actions
deleteSelection

	self setCopyBuffer: self multiSelection.
	
	self doMultiSelectionEach: [:selected |
		(selected parentSandblock canDeleteChild: selected)
			ifTrue: [SBDeleteCommand new target: selected]
			ifFalse: [SBReplaceCommand target: selected replacer: SBUnknown new]]