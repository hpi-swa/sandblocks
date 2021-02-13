Class {
	#name : #SBEmptyLine,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBEmptyLine >> actionProviders [

	^ super actionProviders, {self grammarHandler}
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> canAppearInBlockBody [

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
SBEmptyLine >> grammarHandler [

	^ self parentSandblock grammarHandler
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> initialize [

	super initialize.
	
	self extent: self extent
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> newNullBlock [

	^ self parentSandblock newNullBlock
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> prefersNoBorder [

	^ true
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> printOn: aStream [

	aStream nextPutAll: 'empty line'
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> writeSourceOn: aStream [

	" in the context were the empty line makes sense its mere existence should already cause appropriate spacing "
]

{ #category : #'as yet unclassified' }
SBEmptyLine >> writeSourceOn: aStream indent: aNumber [

	self writeSourceOn: aStream
]
