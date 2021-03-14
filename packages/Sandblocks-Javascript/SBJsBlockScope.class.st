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
SBJsBlockScope >> fixedArity [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> insertCommandRequest: anAfterBoolean near: aBlock [

	(((self header includes: aBlock) or: [aBlock isNil]) and: [self fixedArity not]) ifTrue: [
		^ (SBInsertCommand newFor: self containingArtefact)
			index: (aBlock ifNil: [3] ifNotNil: [((self submorphs indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]))]);
			container: self;
			morph: self newNullBlock;
			shouldMergeWithNext: true;
			yourself].
	
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

	(self submorphs copyFrom: self statementsIndex to: self submorphCount) do: #delete.
	self addAllMorphs: aCollection
]

{ #category : #'as yet unclassified' }
SBJsBlockScope >> statementsIndex [

	^ 1
]
