Class {
	#name : #SBBlockBindings,
	#superclass : #SBBlockRow,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlockBindings >> isBlockBindings [

	^ true
]

{ #category : #'as yet unclassified' }
SBBlockBindings >> visible [

	^ self hasSubmorphs
]
