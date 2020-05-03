Class {
	#name : #SBNoopLayout,
	#superclass : #SBLayoutPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNoopLayout >> layout: aMorph in: aRectangle [
]

{ #category : #'as yet unclassified' }
SBNoopLayout >> minExtentOf: aMorph in: aRectangle [

	^ aMorph bounds
]
