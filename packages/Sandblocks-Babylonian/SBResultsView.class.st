Class {
	#name : #SBResultsView,
	#superclass : #SBExploriantsView,
	#instVars : [
		'morphResizer'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBResultsView >> buildAllPossibleResults [
	
	self subclassResponsibility
]

{ #category : #initialization }
SBResultsView >> initialize [ 

	super initialize.
	
	morphResizer := SBMorphResizer newThumbmail.
]

{ #category : #building }
SBResultsView >> resetWatchesToOriginalPermutationRunning: activeExamples [

	SBActiveVariantPermutation value: nil.
	activeExamples do: #runSynchronouslyIgnoreReturn
]

{ #category : #building }
SBResultsView >> updateButton [

	^ SBButton new
		icon: SBIcon iconRotateLeft
			label: 'Re-Generate'
			do: [self multiverse initialize];
		cornerStyle: #squared
]

{ #category : #actions }
SBResultsView >> visualize [ 

	self clean.

	self block addMorphFront: self updateButton.
	self buildAllPossibleResults 
]
