Class {
	#name : #SBReturn,
	#superclass : #SBASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBReturn >> canAppearInBlockBody [

	^ true
]

{ #category : #formatting }
SBReturn >> childSandblocksDo: aBlock [

	self hasSubmorphs ifTrue: [aBlock value: self firstSubmorph]
]

{ #category : #formatting }
SBReturn >> expression [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBReturn >> expression: aBlock [

	self removeAllMorphs.
	self addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBReturn >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #formatting }
SBReturn >> isReturn [

	^ true
]

{ #category : #'as yet unclassified' }
SBReturn >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self expression layoutCommands}
]

{ #category : #formatting }
SBReturn >> pc [

	^ pc
]

{ #category : #formatting }
SBReturn >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBReturn >> prefix [

	^ '^ '
]

{ #category : #formatting }
SBReturn >> printOn: aStream [

	aStream nextPutAll: 'return '.
	self firstSubmorph printOn: aStream
]

{ #category : #'as yet unclassified' }
SBReturn >> symbols [

	^ self colorPolicy symbolsForReturn: self
]

{ #category : #formatting }
SBReturn >> valid [

	^ self containingStatement = self and: [self containingBlock submorphs last = self]
]

{ #category : #testing }
SBReturn >> wantsExtraSpace [

	^ false
]

{ #category : #formatting }
SBReturn >> writeSourceOn: aStream [

	aStream nextPutAll: '^ '.
	self expression writeSourceOn: aStream
]
