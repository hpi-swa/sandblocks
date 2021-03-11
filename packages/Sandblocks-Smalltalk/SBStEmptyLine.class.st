Class {
	#name : #SBStEmptyLine,
	#superclass : #SBStASTNode,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStEmptyLine >> canAppearInBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBStEmptyLine >> drawnColor [

	^ Color transparent
]

{ #category : #'as yet unclassified' }
SBStEmptyLine >> extent [

	^ self fontToUse height asPoint
]

{ #category : #'as yet unclassified' }
SBStEmptyLine >> extent: aPoint [

	super extent: self fontToUse height asPoint
]

{ #category : #'as yet unclassified' }
SBStEmptyLine >> initialize [

	super initialize.
	
	self extent: self extent
]

{ #category : #'as yet unclassified' }
SBStEmptyLine >> prefersNoBorder [

	^ true
]

{ #category : #'as yet unclassified' }
SBStEmptyLine >> printOn: aStream [

	aStream nextPutAll: 'empty line'
]

{ #category : #'as yet unclassified' }
SBStEmptyLine >> writeSourceOn: aStream [

	aStream nextPutAll: '#ppEmptyLine'
]
