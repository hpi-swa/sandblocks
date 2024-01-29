Class {
	#name : #SBPermutationLabel,
	#superclass : #TextMorph,
	#instVars : [
		'permutation'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBPermutationLabel class >> newDisplaying: aSBPermutation [

	^ self new
		permutation: aSBPermutation;
		updateStyling;
		yourself
]

{ #category : #'*Sandblocks-Babylonian' }
SBPermutationLabel >> listensToPermutations [ 

	^ true
]

{ #category : #accessing }
SBPermutationLabel >> permutation [

	^ permutation
]

{ #category : #accessing }
SBPermutationLabel >> permutation: aSBPermutation [

	permutation := aSBPermutation.
	
	self updateStyling
]

{ #category : #accessing }
SBPermutationLabel >> updateStyling [

	self contents: self permutation asStylizedText 
]
