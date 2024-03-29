Class {
	#name : #SBPartialPermutationLabel,
	#superclass : #TextMorph,
	#instVars : [
		'permutation',
		'universe'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBPartialPermutationLabel class >> newDisplaying: aSBPermutation referingTo: aUniverse [

	^ self new
		universe: aUniverse;
		permutation: aSBPermutation;
		updateStyling;
		yourself
]

{ #category : #'*Sandblocks-Babylonian' }
SBPartialPermutationLabel >> listensToPermutations [ 

	^ true
]

{ #category : #accessing }
SBPartialPermutationLabel >> permutation [

	^ permutation
]

{ #category : #accessing }
SBPartialPermutationLabel >> permutation: aPermutation [ 

	permutation := aPermutation
]

{ #category : #accessing }
SBPartialPermutationLabel >> universe [

	^ universe
]

{ #category : #accessing }
SBPartialPermutationLabel >> universe: aUniverse [

	universe := aUniverse
]

{ #category : #initialization }
SBPartialPermutationLabel >> updateStyling [

	self contents: (self universe activePermutation isActive 
		ifTrue: [self permutation asStylizedText] 
		ifFalse: [self permutation asString])
]
