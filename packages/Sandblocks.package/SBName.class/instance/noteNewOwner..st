as yet unclassified
noteNewOwner: aMorph

	aMorph ifNil: [^ self].
	
	aMorph isAssignment ifTrue: [^ self assureClass: SBBinding].
	aMorph isBlockBody ifTrue: [^ self assureClass: SBBinding].
	(aMorph owner ifNotNil: #isMethod ifNil: [false]) ifTrue: [^ self assureClass: SBDeclaration].
	aMorph isTemporaries ifTrue: [^ self assureClass: SBDeclaration].
	aMorph isBlockBindings ifTrue: [^ self assureClass: SBDeclarationForBlock].
	self isReserved ifTrue: [^ self assureClass: SBKeywordBinding].
	
	self flag: #fixme. " this may be too strict "
	self assureClass: SBBinding