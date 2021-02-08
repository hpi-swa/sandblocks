Class {
	#name : #SBStReturn,
	#superclass : #SBStASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStReturn >> canAppearInBlockBody [

	^ true
]

{ #category : #formatting }
SBStReturn >> childSandblocksDo: aBlock [

	self hasSubmorphs ifTrue: [aBlock value: self firstSubmorph]
]

{ #category : #formatting }
SBStReturn >> expression [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBStReturn >> expression: aBlock [

	self removeAllMorphs.
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBStReturn >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #formatting }
SBStReturn >> isReturn [

	^ true
]

{ #category : #'as yet unclassified' }
SBStReturn >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self expression layoutCommands}
]

{ #category : #formatting }
SBStReturn >> pc [

	^ pc
]

{ #category : #formatting }
SBStReturn >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBStReturn >> prefix [

	^ '^ '
]

{ #category : #formatting }
SBStReturn >> printOn: aStream [

	aStream nextPutAll: 'return '.
	self firstSubmorph printOn: aStream
]

{ #category : #'as yet unclassified' }
SBStReturn >> symbols [

	^ self colorPolicy symbolsForReturn: self
]

{ #category : #formatting }
SBStReturn >> valid [

	^ self containingStatement = self and: [self containingBlock submorphs last = self]
]

{ #category : #testing }
SBStReturn >> wantsExtraSpace [

	^ false
]

{ #category : #formatting }
SBStReturn >> writeSourceOn: aStream [

	aStream nextPutAll: '^ '.
	self expression writeSourceOn: aStream
]
