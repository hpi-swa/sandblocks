Class {
	#name : #SBPlainResultsView,
	#superclass : #SBResultsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBPlainResultsView >> buildPermutationFor: aSBUniverse [

	self block addAllMorphsBack: { SBOwnTextMorph new contents: aSBUniverse activePermutation asString.
									self applyButtonFor: aSBUniverse activePermutation. 
									(self containerRow listDirection: #leftToRight) 
										addAllMorphsBack: aSBUniverse watches.
									LineMorph from: 0@0 to: 50@0 color: Color black width: 2}
]

{ #category : #initialization }
SBPlainResultsView >> initialize [ 

	super initialize.
	
	self name: 'Plain View'
]
