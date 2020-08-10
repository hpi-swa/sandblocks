Class {
	#name : #SBMorphRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBMorphRepresentation class >> isMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBMorphRepresentation class >> isSandblock [

	^ true
]

{ #category : #'as yet unclassified' }
SBMorphRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBMorphRepresentation class >> matches: anObject [

	self flag: #fixme. " sandblocks cannot live outside their natural habitat, but encoding this here is not nice "
	^ anObject isMorph and: [anObject isSandblock not and: [anObject owner isNil or: [anObject owner class = SBMorphWrapperBlock]]]
]

{ #category : #'as yet unclassified' }
SBMorphRepresentation class >> newFor: anObject [

	^ SBMorphWrapperBlock new
		addMorphLater: anObject;
		yourself
]
