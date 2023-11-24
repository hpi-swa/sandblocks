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
						newForSize: morphResizer
						multiverse: self multiverse 
						displaying: aNumber}.
		LineMorph from: 0@0 to: 0@50 color: Color black width: 2}).
		
	self updateContainerWidth.
]

{ #category : #updating }
SBExampleGridsView >> gridObjects [

	^ self multiverse activeExamples
]

{ #category : #initialization }
SBExampleGridsView >> initialize [ 

	super initialize.
	
	self name: 'Example Grid View'.
]