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

{ #category : #actions }
SBResultsView >> visualize [ 

	super visualize.
	self buildAllPossibleResults 
]
