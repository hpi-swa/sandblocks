as yet unclassified
splitStringAtCursor
	<inputAction>

	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: (SBMessageSend new
			receiver: (SBString new contents: text contentsBeforeCursor)
			selector: #,
			arguments: {SBString new contents: text contentsAfterCursor}))