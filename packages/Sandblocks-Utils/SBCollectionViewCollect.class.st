Class {
	#name : #SBCollectionViewCollect,
	#superclass : #SBCollectionView,
	#instVars : [
		'block'
	],
	#category : #'Sandblocks-Utils'
}

{ #category : #'as yet unclassified' }
SBCollectionViewCollect class >> on: aCollection block: aBlock [

	^ (self on: aCollection from: 1 to: aCollection size)
		block: aBlock;
		yourself
]

{ #category : #'as yet unclassified' }
SBCollectionViewCollect >> at: aNumber [

	^ block value: (super at: aNumber)
]

{ #category : #'as yet unclassified' }
SBCollectionViewCollect >> block: aBlock [

	block := aBlock
]

{ #category : #'as yet unclassified' }
SBCollectionViewCollect >> do: aBlock [

	start to: end by: step do: [:index |
		aBlock value: (block value: (collection at: index))]
]
