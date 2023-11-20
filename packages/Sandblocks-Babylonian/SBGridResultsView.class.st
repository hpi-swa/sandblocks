Class {
	#name : #SBGridResultsView,
	#superclass : #SBResultsView,
	#instVars : [
		'gridContainer'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBGridResultsView >> buildPermutationFor: aSBUniverse [
		
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
		
	gridContainer width: (self multiverse universes size safeSquareRoot ceiling) * (gridContainer lastSubmorph width + (2 * gridContainer cellInset) + (2 * gridContainer cellGap) + (2 * self block layoutInset x)). 
]

{ #category : #actions }
SBGridResultsView >> clean [

	super clean.
	
	self block addMorphBack: (gridContainer := self newGridContainer)
	
]

{ #category : #initialization }
SBGridResultsView >> initialize [ 

	super initialize.
	
	self name: 'Grid View'.
	
	self block addMorphBack: (gridContainer := self newGridContainer).
]

{ #category : #building }
SBGridResultsView >> newGridContainer [

	^ SBBlock new
		changeTableLayout;
		color: Color white;
		listDirection: #leftToRight;
		wrapDirection: #topToBottom;
		wrapCentering: #topLeft;
		hResizing: #rigid;
		width: 50;
		cellInset: 0;
		vResizing: #shrinkWrap;
		yourself
]
