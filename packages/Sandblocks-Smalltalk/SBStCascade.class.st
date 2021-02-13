Class {
	#name : #SBStCascade,
	#superclass : #SBStASTNode,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStCascade >> acceptChild: aMorph [

	^ aMorph isMessageSend
]

{ #category : #'as yet unclassified' }
SBStCascade >> canDeleteChild: aBlock [

	^ aBlock ~= self receiver
]

{ #category : #'as yet unclassified' }
SBStCascade >> cellGap [

	^ self colorPolicy lineGap
]

{ #category : #'as yet unclassified' }
SBStCascade >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBStCascade >> codeActions [

	^ super codeActions, (SBStSubstitution allSubclasses
		select: [:substition | substition matchesCascades and: [substition matches: self]]
		thenCollect: [:substitution | 
			SBCodeAction
				labeled: 'Convert to ', substitution name
				for: self
				do: [:node | 
					node sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
						target: node;
						replacer: ((substitution newFrom: self) pc: self pc))]])
]

{ #category : #'as yet unclassified' }
SBStCascade >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBStCascade >> guessedClass [

	^ self submorphs last guessedClass
]

{ #category : #'as yet unclassified' }
SBStCascade >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		container: self;
		index: (self submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		shouldMergeWithNext: true;
		morph: (SBStMessageSend new receiver: nil selector: #'' arguments: #())
]

{ #category : #'as yet unclassified' }
SBStCascade >> isCascade [

	^ true
]

{ #category : #'as yet unclassified' }
SBStCascade >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStCascade >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self receiver layoutCommands.
			SBAlgebraCommand group data: (self messages gather: [:message | {SBAlgebraCommand hardLine withGap: true. message layoutCommands}])}
]

{ #category : #'as yet unclassified' }
SBStCascade >> messages [

	^ self submorphs allButFirst
]

{ #category : #'as yet unclassified' }
SBStCascade >> objectInterfaceAt: aNumber adding: aBoolean [

	^ aNumber = 1 ifTrue: [SBInterfaces stExpression] ifFalse: [SBInterfaces stMessage]
]

{ #category : #'as yet unclassified' }
SBStCascade >> printOn: aStream [

	aStream nextPutAll: 'cascade to '.
	self hasSubmorphs ifTrue: [self firstSubmorph printOn: aStream]
]

{ #category : #'as yet unclassified' }
SBStCascade >> receiver [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBStCascade >> receiver: aBlock messages: aCollection [

	self addMorphBack: aBlock.
	aCollection do: [:m | self addMorphBack: m]
]

{ #category : #'as yet unclassified' }
SBStCascade >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self firstSubmorph writeSourceOn: aStream.
	aStream space.
	self submorphs allButFirst do: [:m | m writeSendSourceOn: aStream] separatedBy: [aStream nextPutAll: '; '].
	aStream nextPut: $)
]