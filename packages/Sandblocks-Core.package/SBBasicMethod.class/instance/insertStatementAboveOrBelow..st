as yet unclassified
insertStatementAboveOrBelow: anAboveBoolean

	| statement |
	statement := SBUnknown new.
	self sandblockEditor
		do: ((SBInsertCommand newFor: self)
			index: (anAboveBoolean ifTrue: [2] ifFalse: [self body submorphCount + 1]);
			container: self body;
			morph: statement;
			shouldMergeWithNext: true;
			yourself);
		startInput: statement at: 1 replacingContents: false