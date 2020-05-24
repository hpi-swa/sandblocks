Class {
	#name : #SBDepthFirstPostOrderNavigation,
	#superclass : #SBNavigation,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDepthFirstPostOrderNavigation >> nextFrom: aBlock [

	^ (aBlock adjacentBlock: 1) ifNotNil: [:b | b firstDeepChild] ifNil: [aBlock parentSandblock]
]

{ #category : #'as yet unclassified' }
SBDepthFirstPostOrderNavigation >> previousFrom: aBlock [

	^ aBlock hasChildSandblocks ifTrue: [aBlock childSandblocks last] ifFalse: [aBlock parentAdjacentBlock: -1]
]
