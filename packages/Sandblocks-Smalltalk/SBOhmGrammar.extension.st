Extension { #name : #SBOhmGrammar }

{ #category : #'*Sandblocks-Smalltalk' }
SBOhmGrammar >> canAppearInBlockBody [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBOhmGrammar >> grammarHandler [

	^ self parentSandblock grammarHandler
]

{ #category : #'*Sandblocks-Smalltalk' }
SBOhmGrammar >> guessClassExpensive [

	^ self guessedClass
]

{ #category : #'*Sandblocks-Smalltalk' }
SBOhmGrammar >> guessedClass [

	^ OhmGrammar
]

{ #category : #'*Sandblocks-Smalltalk' }
SBOhmGrammar >> isExpression [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBOhmGrammar >> isSmalltalk [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBOhmGrammar >> updatePCFrom: anObject [
]

{ #category : #'*Sandblocks-Smalltalk' }
SBOhmGrammar >> writeStSourceOn: aStream [

	aStream nextPutAll: '(OhmGrammar new: '.
	aStream store: (String streamContents: [:s |
		self writeOhmSourceOn: s]).
	aStream nextPut: $)
]
