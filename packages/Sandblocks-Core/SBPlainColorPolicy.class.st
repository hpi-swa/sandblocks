Class {
	#name : #SBPlainColorPolicy,
	#superclass : #SBColorPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPlainColorPolicy >> borderWidthForBlock: aBlock [

	^ 1
]

{ #category : #'as yet unclassified' }
SBPlainColorPolicy >> layoutInsetFor: aBlock [

	^ 2 @ 1
]
