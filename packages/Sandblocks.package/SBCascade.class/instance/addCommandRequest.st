as yet unclassified
addCommandRequest

	^ (SBInsertCommand newFor: self containingMethod)
		container: self;
		index: self submorphCount + 1;
		shouldMergeWithNext: true;
		morph: (SBMessageSend new receiver: self firstSubmorph veryDeepCopy selector: #'' arguments: #())