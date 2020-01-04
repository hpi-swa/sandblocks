actions
insertLabelAboveOrBelow: anAboveBoolean

	| currentStatement index newStatement |
	newStatement :=  SBLabel new.
	
	currentStatement := self selection containingStatement.
	index := currentStatement owner submorphIndexOf: currentStatement.
	
	self do: ((SBInsertCommand newFor: self method)
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: newStatement;
		shouldMergeWithNext: true;
		yourself).
	
	self startInput: newStatement at: 1 replacingContents: false