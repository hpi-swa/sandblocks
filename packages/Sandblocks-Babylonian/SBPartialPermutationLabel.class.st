Class {
	#name : #SBPartialPermutationLabel,
	#superclass : #SBPermutationLabel,
	#instVars : [
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

{ #category : #'event handling' }
SBPartialPermutationLabel >> mouseDown: evt [ 
	
	self universe activePermutation apply
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
