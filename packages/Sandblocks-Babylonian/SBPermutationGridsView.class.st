Class {
	#name : #SBPermutationGridsView,
	#superclass : #SBGridResultsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBPermutationGridsView >> buildAllPossibleResults [
	
	self multiverse universes do: [:aUniverse | self buildPermutationFor: aUniverse]
]

{ #category : #building }
SBPermutationGridsView >> buildPermutationFor: aSBUniverse [
		
	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				addAllMorphsBack: { 
					SBOwnTextMorph new contents: aSBUniverse activePermutation asString.
					SBButton newApplyPermutationFor: aSBUniverse activePermutation. 
					(SBPermutationCluster 
						newForSize: morphResizer
						havingWatches: aSBUniverse watches)}.
		LineMorph from: 0@0 to: 0@50 color: Color black width: 2}).
		
	self updateContainerWidth.
]

{ #category : #updating }
SBPermutationGridsView >> gridObjects [

	^ self multiverse universes
]

{ #category : #initialization }
SBPermutationGridsView >> initialize [ 

	super initialize.
	
	self name: 'Permutation Grid View'.
]
