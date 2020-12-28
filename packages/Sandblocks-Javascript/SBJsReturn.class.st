Class {
	#name : #SBJsReturn,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsReturn >> childSandblocksDo: aBlock [

	self expression ifNotNil: aBlock
]

{ #category : #'as yet unclassified' }
SBJsReturn >> expression [

	^ self submorphCount > 1 ifTrue: [self submorphs second] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBJsReturn >> expression: aBlock [

	self expression ifNotNil: #delete.
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBJsReturn >> initialize [

	super initialize.
	
	self addMorphBack: (SBStringMorph new contents: 'return')
]

{ #category : #'as yet unclassified' }
SBJsReturn >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {SBAlgebraCommand morph data: self firstSubmorph. SBAlgebraCommand softLineOrGap}, (self expression ifNotNil: [:expr | {expr layoutCommands}] ifNil: [{}])
]

{ #category : #'as yet unclassified' }
SBJsReturn >> valid [

	^ self isStatement
]
