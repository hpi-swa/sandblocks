as yet unclassified
noteNewOwner: aMorph

	aMorph ifNil: [^ self].
	
	(self contents = 'true' or: [self contents = 'false']) ifTrue: [^ self assureClass: SBBoolean].
	self isReserved ifTrue: [^ self assureClass: SBKeywordBinding].
	aMorph isAssignment ifTrue: [^ self assureClass: SBBinding].
	aMorph isBlockBody ifTrue: [^ self assureClass: SBBinding].
	(aMorph parentSandblockOrNil ifNotNil: #isMethod ifNil: [false]) ifTrue: [^ self assureClass: SBDeclarationForMethodArgument].
	aMorph isTemporaries ifTrue: [^ self assureClass: SBDeclaration].
	aMorph isBlockBindings ifTrue: [^ self assureClass: SBDeclarationForBlock].
	
	self flag: #fixme. " this may be too strict "
	self assureClass: SBBinding