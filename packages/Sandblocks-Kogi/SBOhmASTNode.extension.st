Extension { #name : #SBOhmASTNode }

{ #category : #'*Sandblocks-Kogi' }
SBOhmASTNode >> isFieldInput [

	(self isAlternative and: [self childSandblocks allSatisfy: [:b | b isIdentifier and: [(b associatedRule isKindOf: Association) or: [b associatedRule isFieldInput]]]]) ifTrue: [^ true].

	^ (self allBlocksSelect: [:b | b isIdentifier and: [b isSimple]]) notEmpty and: [(self allBlocksSelect: [:b | b isTerminal and: [(b contents reject: [:c | c ~= $\]) size > 1]]) isEmpty]
]
