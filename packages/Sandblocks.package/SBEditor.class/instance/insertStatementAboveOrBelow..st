actions
insertStatementAboveOrBelow: anAboveBoolean

	| currentStatement index newStatement |
	currentStatement := self selection containingStatement.
	index := currentStatement owner submorphIndexOf: currentStatement.
	
	newStatement :=  SBUnknown new.
	
	self do: (SBInsertCommand new
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: newStatement;
		shouldMergeWithNext: true;
		yourself).
	
	self startInput: newStatement at: 1 replacingContents: false