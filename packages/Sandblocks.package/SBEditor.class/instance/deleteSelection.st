actions
deleteSelection

	self setCopyBuffer: self selection.
	
	self do: (self selection == self selection containingStatement
		ifTrue: [SBDeleteCommand new target: self selection]
		ifFalse: [SBReplaceCommand target: self selection replacer: SBUnknown new])