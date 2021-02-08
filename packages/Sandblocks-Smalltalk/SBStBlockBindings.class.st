Class {
	#name : #SBStBlockBindings,
	#superclass : #SBBlockRow,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStBlockBindings >> isBlockBindings [

	^ true
]

{ #category : #'as yet unclassified' }
SBStBlockBindings >> layoutInset [

	^ self hasSubmorphs ifTrue: [2 withScalingFactor] ifFalse: [0]
]
