as yet unclassified
noteNewOwner: aMorph

	aMorph ifNil: [^ self].
	
	((aMorph parentSandblock ifNotNil: #isMethod ifNil: [false]) and: [aMorph parentSandblock isMyArgument: self]) ifTrue: [^ self behavior: SBDeclarationForMethodArgument new].
	aMorph isTemporaries ifTrue: [^ self behavior: SBDeclarationForTemporaryVariable new].
	aMorph isBlockBindings ifTrue: [^ self behavior: SBDeclarationForBlock new].
	(self containingArtefact ifNotNil: #isClassContainer ifNil: [false]) ifTrue: [
		aMorph = self containingArtefact instanceVariables ifTrue: [^ self behavior: SBDeclarationForInstanceVariable new].
		aMorph = self containingArtefact classVariables ifTrue: [^ self behavior: SBDeclarationForPoolVariable new]].
	
	((self containingArtefact ifNotNil: #isRepl ifNil: [false]) and: [aMorph = self containingArtefact localVariables])
		ifTrue: [^ self behavior: SBDeclarationForLocalVariable new].
	
	(self contents = 'true' or: [self contents = 'false']) ifTrue: [^ self behavior: SBBoolean new].
	self isReserved ifTrue: [^ self behavior: SBKeywordBinding new].
	self flag: #fixme. " this may be too strict "
	
	aMorph isAssignment ifTrue: [^ self behavior: (self isFirstChild ifTrue: [SBAssignmentLabel new] ifFalse: [SBBinding new])].
	self behavior: SBBinding new