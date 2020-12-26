Class {
	#name : #SBJsBlockScope,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsBlockScope >> binding: aString for: block class: aClass ifPresent: aBlock [

	self statements detect: [:stmt | stmt isDeclaration and: [stmt lhs contents = aString]] ifFound: [:stmt | ^ aBlock value: stmt] ifNone: [].
	
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> childSandblocksDo: aBlock [

	self statements do: aBlock
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: ((self submorphs indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]) max: self statementsIndex);
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> isBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> isMethodBody [

	^ self owner isMethod
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: self layoutCommandsForStatements
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> layoutCommandsForStatements [

	^ self statements collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true]
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> statements [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> statements: aCollection [

	self addAllMorphs: aCollection
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> statementsIndex [

	^ 1
]
