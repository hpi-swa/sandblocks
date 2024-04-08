Class {
	#name : #SBPermutationLabel,
	#superclass : #TextMorph,
	#instVars : [
		'permutation'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBPermutationLabel class >> newDisplaying: aSBPermutation [

	^ self new
		permutation: aSBPermutation;
		updateStyling;
		yourself
]

{ #category : #'*Sandblocks-Babylonian' }
SBPermutationLabel >> applyResize: aPoint [

	^ self extent: aPoint
]

{ #category : #initialization }
SBPermutationLabel >> initialize [ 

	super initialize.
	
	self wrapFlag: true.
]

{ #category : #'*Sandblocks-Babylonian' }
SBPermutationLabel >> listensToPermutations [ 

	^ true
]

{ #category : #'event handling' }
SBPermutationLabel >> mouseDown: evt [ 
	
	self permutation apply
]

{ #category : #'event handling' }
SBPermutationLabel >> mouseEnter: evt [ 

	"nothing"
]

{ #category : #'event handling' }
SBPermutationLabel >> mouseLeave: evt [ 

	"nothing"
]

{ #category : #'event handling' }
SBPermutationLabel >> mouseMove: evt [

	^ Cursor execute show
]

{ #category : #'event handling' }
SBPermutationLabel >> mouseUp: evt [ 
	
	"nothing"
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
