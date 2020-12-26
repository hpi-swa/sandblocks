Class {
	#name : #SBJsReturn,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsReturn >> childSandblocksDo: aBlock [

	aBlock value: self expression
]

{ #category : #'as yet unclassified' }
SBJsReturn >> expression [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsReturn >> expression: aBlock [

	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBJsReturn >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self expression layoutCommands}
]

{ #category : #'as yet unclassified' }
SBJsReturn >> symbols [

	^ #('return ' nil)
]

{ #category : #'as yet unclassified' }
SBJsReturn >> valid [

	^ self isStatement
]
