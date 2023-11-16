Class {
	#name : #SBGridResultsView,
	#superclass : #SBResultsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBGridResultsView >> buildPermutationFor: aSBUniverse [

	self block addAllMorphsBack: { SBOwnTextMorph new contents: aSBUniverse activePermutation asString.
									self applyButtonFor: aSBUniverse activePermutation. 
									(self containerRow listDirection: #leftToRight)
										 addMorph: ((
											SBPermutationCluster
												newFromWatches: aSBUniverse watches
												havingSize: (SBMorphResizer newMedium))).
									LineMorph from: 0@0 to: 50@0 color: Color black width: 2}
]

{ #category : #initialization }
SBGridResultsView >> initialize [ 

	super initialize.
	
	self name: 'Grid View'
]
