actions
pasteStatementAboveOrBelow: anAboveBoolean

	| index target adjacent morph |
	copyBuffer ifNil: [^ self].
	
	copyBuffer wrapsAround ifTrue: [^ self wrapSelectionWith: copyBuffer].
	
	target := copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer].
	
	adjacent := self selection.
	[adjacent parentSandblock acceptChild: target] whileFalse: [adjacent := adjacent parentSandblock].
	
	index := adjacent owner submorphIndexOf: adjacent.
	morph := target veryDeepCopy.
	
	self do: ((SBInsertCommand newFor: self selectedArtefact)
		index: (anAboveBoolean
			ifTrue: [index] ifFalse: [index + 1]);
		container: adjacent owner;
		morph: morph;
		yourself).
	
	morph postDuplicate