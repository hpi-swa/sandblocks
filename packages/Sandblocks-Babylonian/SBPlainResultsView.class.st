Class {
	#name : #SBPlainResultsView,
	#superclass : #SBResultsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBPlainResultsView >> buildAllPossibleResults [
	
	self multiverse universes do: [:aUniverse | self buildPermutationFor: aUniverse]
]

{ #category : #building }
SBPlainResultsView >> buildPermutationFor: aSBUniverse [

	self block addAllMorphsBack: {SBPermutationLabel newDisplaying: aSBUniverse activePermutation.
									SBButton newApplyPermutationFor: aSBUniverse activePermutation.
									(self containerRow listDirection: #leftToRight) 
										addAllMorphsBack: aSBUniverse watches.
									LineMorph from: 0@0 to: 50@0 color: Color black width: 2}
]

{ #category : #initialization }
SBPlainResultsView >> initialize [ 

	super initialize.
	
	self name: 'Watches'
]

{ #category : #copying }
SBPlainResultsView >> wantsHistory [
	
	^ false
]
