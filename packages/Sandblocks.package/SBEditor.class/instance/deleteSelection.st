actions
deleteSelection

	self setCopyBuffer: self multiSelection.
	
	self doMultiSelectionEach: [:selected |
		(selected == selected containingStatement or: [selected owner isArrayBlock])
			ifTrue: [SBDeleteCommand new target: selected]
			ifFalse: [SBReplaceCommand target: selected replacer: SBUnknown new]]