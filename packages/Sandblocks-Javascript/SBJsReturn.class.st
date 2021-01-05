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
		data: {
			SBAlgebraCommand morph data: self firstSubmorph.
			self expression
				ifNotNil: [:expr | SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap. expr layoutCommands}]
				ifNil: [SBAlgebraCommand noop]
		}
]

{ #category : #'as yet unclassified' }
SBJsReturn >> valid [

	^ self isStatement
]

{ #category : #'as yet unclassified' }
SBJsReturn >> writeSourceOn: aStream [

	aStream nextPutAll: 'return '.
	self expression writeSourceOn: aStream
]
