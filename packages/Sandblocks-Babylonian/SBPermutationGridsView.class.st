Class {
	#name : #SBPermutationGridsView,
	#superclass : #SBSwitchableResultsView,
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
					(SBPermutationLabel newDisplaying: aSBUniverse activePermutation)
						wrapFlag: false.
					(self currentClusterClass 
						newForSize: self selectedResizer
						havingWatches: aSBUniverse watches)}})
]

{ #category : #building }
SBPermutationGridsView >> currentClusterClass [

	^ isDisplayingTrace 
		ifTrue: [SBPermutationTraces] 
		ifFalse: [SBPermutationCluster]
]

{ #category : #initialization }
SBPermutationGridsView >> initialize [ 

	super initialize.
	
	self name: 'Permutation Grouped'
]
