Class {
	#name : #SBReturn,
	#superclass : #SBASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Core'
}

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
	
	pc := 0.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap
]

{ #category : #formatting }
SBReturn >> isReturn [

	^ true
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

{ #category : #formatting }
SBReturn >> valid [

	^ self containingStatement = self and: [self containingBlock submorphs last = self]
]

{ #category : #formatting }
SBReturn >> writeSourceOn: aStream [

	aStream nextPutAll: '^ '.
	self expression writeSourceOn: aStream
]
