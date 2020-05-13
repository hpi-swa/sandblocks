Class {
	#name : #SBCascade,
	#superclass : #SBASTNode,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCascade >> acceptChild: aMorph [

	^ aMorph isMessageSend
]

{ #category : #'as yet unclassified' }
SBCascade >> canDeleteChild: aBlock [

	^ aBlock ~= self receiver
]

{ #category : #'as yet unclassified' }
SBCascade >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBCascade >> codeActions [

	^ super codeActions, (SBSubstitution allSubclasses
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
SBCascade >> contextAcceptedRepresentationAt: aNumber [

	aNumber = 1 ifTrue: [^ #isSmalltalkExpression].
	^ #isSmalltalkMessage
]

{ #category : #'as yet unclassified' }
SBCascade >> guessedClass [

	^ self submorphs last guessedClass
]

{ #category : #'as yet unclassified' }
SBCascade >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBCascade >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		container: self;
		index: (self submorphIndexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		shouldMergeWithNext: true;
		morph: (SBMessageSend new receiver: nil selector: #'' arguments: #())
]

{ #category : #'as yet unclassified' }
SBCascade >> isCascade [

	^ true
]

{ #category : #'as yet unclassified' }
SBCascade >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBCascade >> messages [

	^ self submorphs allButFirst
]

{ #category : #'as yet unclassified' }
SBCascade >> printOn: aStream [

	aStream nextPutAll: 'cascade to '.
	self firstSubmorph printOn: aStream
]

{ #category : #'as yet unclassified' }
SBCascade >> receiver [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBCascade >> receiver: aBlock messages: aCollection [

	self addMorphBack: aBlock.
	aCollection do: [:m | self addMorphBack: m]
]

{ #category : #'as yet unclassified' }
SBCascade >> writeSourceOn: aStream [

	aStream nextPut: $(.
	self firstSubmorph writeSourceOn: aStream.
	aStream space.
	self submorphs allButFirst do: [:m | m writeSendSourceOn: aStream] separatedBy: [aStream nextPutAll: '; '].
	aStream nextPut: $)
]
