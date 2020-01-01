actions
pasteStatementAboveOrBelow: anAboveBoolean

	| index target adjacent |
	copyBuffer ifNil: [^ self].
	
	target := copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer].
	
	adjacent := self selection.
	[adjacent parentSandblock acceptChild: target] whileFalse: [adjacent := adjacent parentSandblock].
	
	index := adjacent owner submorphIndexOf: adjacent.
	
	self do: ((SBInsertCommand newFor: self method)
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: adjacent owner;
		morph: target veryDeepCopy;
		yourself)