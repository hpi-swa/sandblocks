as yet unclassified
addCommandRequest

	^ (SBInsertCommand newFor: self containingMethod)
		container: self;
		index: self submorphCount + 1;
		shouldMergeWithNext: true;
		morph: (SBMessageSend new receiver: nil selector: #'' arguments: #())