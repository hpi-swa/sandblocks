Class {
	#name : #SBEmptyLine,
	#superclass : #SBASTNode,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBEmptyLine >> canAppearInBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> canSwap [

	^ true
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> drawnColor [

	^ Color transparent
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> extent [

	^ self fontToUse height asPoint
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> extent: aPoint [

	super extent: self fontToUse height asPoint
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> initialize [

	super initialize.
	
	self extent: self extent
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> printOn: aStream [

	aStream nextPutAll: 'empty line'
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> writeSourceOn: aStream [

	aStream nextPutAll: '#sbEmptyLine'
]
