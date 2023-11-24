"
A codeflow state caused by a particular permutation, resulting in varying watches 
"
Class {
	#name : #SBUniverse,
	#superclass : #Object,
	#instVars : [
		'activePermutation',
		'watches'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'instance creation' }
SBUniverse class >> newActive: aSBPermutation watches: aCollectionOfSBExampleWatches [

	^ self new
		activePermutation: aSBPermutation;
		watches: aCollectionOfSBExampleWatches;
		yourself 
]

{ #category : #accessing }
SBUniverse >> activePermutation [

	^ activePermutation
]

{ #category : #accessing }
SBUniverse >> activePermutation: aSBPermutation [

	activePermutation := aSBPermutation
]

{ #category : #accessing }
SBUniverse >> watches [

	^ watches
]

{ #category : #accessing }
SBUniverse >> watches: aCollectionOfSBExampleWatches [

	watches := aCollectionOfSBExampleWatches
]
