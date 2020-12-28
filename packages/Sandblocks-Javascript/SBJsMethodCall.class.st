Class {
	#name : #SBJsMethodCall,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsMethodCall >> arguments [

	^ self submorphs viewFrom: 3 to: self submorphCount - 1
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> childSandblocksDo: aBlock [

	aBlock value: self method.
	self arguments do: aBlock
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: ((self submorphs indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]) max: 3);
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self method layoutCommands.
			SBAlgebraCommand morph data: self submorphs second.
			SBAlgebraCommand indent data:
				{SBAlgebraCommand softLine},
				((self arguments collect: [:a | a layoutCommands] separatedBy: [SBAlgebraCommand softLineOrGap]),
				{SBAlgebraCommand morph data: self submorphs last})}
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> method [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> method: aBlock arguments: aCollection [

	self addMorphBack: aBlock.
	self addMorphBack: (SBStringMorph new contents: '(').
	self addAllMorphsBack: aCollection.
	self addMorphBack: (SBStringMorph new contents: ')').
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> printOn: aStream [

	aStream nextPutAll: 'method call'
]

{ #category : #'as yet unclassified' }
SBJsMethodCall >> wantsExtraSpace [

	^ false
]
