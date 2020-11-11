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
SBBlockBindings >> layoutInset [

	^ self hasSubmorphs ifTrue: [2 withScalingFactor] ifFalse: [0]
]
