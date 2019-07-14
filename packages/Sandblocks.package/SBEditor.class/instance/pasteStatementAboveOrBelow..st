actions
pasteStatementAboveOrBelow: anAboveBoolean

	| index target adjacent |
	target := copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer].
	
	adjacent := self selection.
	[adjacent parentSandblock acceptChild: target] whileFalse: [adjacent := adjacent parentSandblock].
	
	index := adjacent owner submorphIndexOf: adjacent.
	
	self do: (SBInsertCommand new
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: adjacent owner;
		morph: target veryDeepCopy;
		yourself)