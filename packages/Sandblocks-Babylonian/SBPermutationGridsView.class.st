Class {
	#name : #SBPermutationGridsView,
	#superclass : #SBGridResultsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBPermutationGridsView >> backUpWhenNoVariants [
		
	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				addAllMorphsBack: { 
					self noVariantsHeader.
					SBPermutationCluster
								newFromWatches: self multiverse copyWatches
								havingSize: SBMorphResizer newSmall}}).
								
	gridContainer width: gridContainer lastSubmorph fullBounds width. 
]

{ #category : #building }
SBPermutationGridsView >> buildPermutationFor: aSBUniverse [
		
	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				addAllMorphsBack: { 
					SBOwnTextMorph new contents: aSBUniverse activePermutation asString.
					self applyButtonFor: aSBUniverse activePermutation. 
					SBPermutationCluster
								newFromWatches: aSBUniverse watches
								havingSize: SBMorphResizer newSmall}.
		LineMorph from: 0@0 to: 0@50 color: Color black width: 2}).
		
	gridContainer width: (self multiverse universes size safeSquareRoot ceiling) * (gridContainer lastSubmorph fullBounds width + (2 * gridContainer cellInset) + (2 * gridContainer cellGap) + (2 * self block layoutInset x)). 
]

{ #category : #initialization }
SBPermutationGridsView >> initialize [ 

	super initialize.
	
	self name: 'Permutation Grid View'.
]
