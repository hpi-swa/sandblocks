actions
insertStatementAboveOrBelow: anAboveBoolean

	| currentStatement index newStatement |
	newStatement :=  SBUnknown new.
	self selection isCodeContainer ifTrue: [self select: self selection method].
	
	self selection = self method
		ifTrue: [
			self do: ((SBInsertCommand newFor: self method)
				index: 3;
				container: self method body;
				morph: newStatement;
				shouldMergeWithNext: true;
				yourself)]
		ifFalse: [
			currentStatement := self selection containingStatement.
			index := currentStatement owner submorphIndexOf: currentStatement.
	
			self do: ((SBInsertCommand newFor: self selection containingArtefact)
				index: (anAboveBoolean
					ifTrue: [index] ifFalse: [index + 1]);
				container: currentStatement owner;
				morph: newStatement;
				shouldMergeWithNext: true;
				yourself)].
	
	self startInput: newStatement at: 1 replacingContents: false