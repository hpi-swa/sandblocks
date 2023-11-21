Class {
	#name : #SBExampleGridsView,
	#superclass : #SBGridResultsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBExampleGridsView >> buildAllPossibleResults [
	
	self multiverse activeExamples withIndexDo: [:anExample :anIndex | self buildExampleFor: anIndex]
]

{ #category : #building }
SBExampleGridsView >> buildExampleFor: aNumber [
		
	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				addAllMorphsBack: { 
					SBOwnTextMorph new contents: 'example: ', (self multiverse activeExamples at: aNumber) label.
					SBExampleCluster 
						newForSize: SBMorphResizer newMedium 
						multiverse: self multiverse 
						displaying: aNumber}.
		LineMorph from: 0@0 to: 0@50 color: Color black width: 2}).
		
	self updateContainerWidth.
]

{ #category : #initialization }
SBExampleGridsView >> initialize [ 

	super initialize.
	
	self name: 'Example Grid View'.
]

{ #category : #updating }
SBExampleGridsView >> updateContainerWidth [

	gridContainer width: 
		(self multiverse activeExamples size safeSquareRoot ceiling) 
			* (gridContainer lastSubmorph fullBounds width 
				+ (2 * gridContainer cellInset) 
				+ (2 * gridContainer cellGap) 
				+ 10)
]
