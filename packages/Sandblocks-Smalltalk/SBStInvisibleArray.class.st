Class {
	#name : #SBStInvisibleArray,
	#superclass : #SBStArray,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStInvisibleArray >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'as yet unclassified' }
SBStInvisibleArray >> prefersNoBorder [

	^ true
]

{ #category : #'as yet unclassified' }
SBStInvisibleArray >> symbols [

	^ #(nil nil)
]
