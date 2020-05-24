Class {
	#name : #SBDepthFirstPreOrderNavigation,
	#superclass : #SBNavigation,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDepthFirstPreOrderNavigation >> nextFrom: aBlock [

	aBlock childSandblocksDo: [:first | ^ first].
	^ (aBlock adjacentBlock: 1) ifNil: [aBlock parentSandblock parentAdjacentBlock: 1]
]

{ #category : #'as yet unclassified' }
SBDepthFirstPreOrderNavigation >> previousFrom: aBlock [

	^ (aBlock adjacentBlock: -1) ifNil: [aBlock parentSandblock] ifNotNil: [:adj | adj rightMostBlock]
]
