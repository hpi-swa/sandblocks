actions
pasteStatementAboveOrBelow: anAboveBoolean

	| currentStatement index |
	currentStatement := self selection containingStatement.
	index := currentStatement owner submorphIndexOf: currentStatement.
	
	self do: (SBInsertCommand new
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: currentStatement owner;
		morph: (copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer]) veryDeepCopy;
		yourself)