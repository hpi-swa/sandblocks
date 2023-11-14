Class {
	#name : #SBGridResultsView,
	#superclass : #SBResultsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBGridResultsView >> buildPermutationFor: aPermutation collectingWatchesFrom: aCollectionOfMethodBlocks [

	self block addAllMorphsBack: { SBOwnTextMorph new contents: aPermutation asString.
									self applyButtonFor: aPermutation. 
									(self containerRow listDirection: #leftToRight)
										 addMorph: ((
											SBPermutationCluster
												newFromWatches: (self allWatchesIn: aCollectionOfMethodBlocks)
												havingSize: (SBMorphResizer newSmall))).
									LineMorph from: 0@0 to: 50@0 color: Color black width: 2}
]

{ #category : #initialization }
SBGridResultsView >> initialize [ 

	super initialize.
	
	self name: 'Grid View'
]
