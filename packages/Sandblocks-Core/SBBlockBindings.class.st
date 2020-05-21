Class {
	#name : #SBBlockBindings,
	#superclass : #SBBlockRow,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlockBindings >> addedMorph: aMorph [

	super addedMorph: aMorph.
	
	self triggerEvent: #visibilityChanged
]

{ #category : #'as yet unclassified' }
SBBlockBindings >> isBlockBindings [

	^ true
]

{ #category : #'as yet unclassified' }
SBBlockBindings >> visible [

	^ self hasSubmorphs
]
