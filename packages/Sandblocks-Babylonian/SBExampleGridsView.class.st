Class {
	#name : #SBExampleGridsView,
	#superclass : #SBSwitchableResultsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBExampleGridsView >> buildAllPossibleResults [
	
	self multiverse activeExamples 
		ifEmpty: [gridContainer addMorph: (TextMorph new contents: 'No examples active').
				  gridContainer width: gridContainer firstSubmorph width + 5 "a bit of margin"].
	
	self multiverse activeExamples withIndexDo: [:anExample :anIndex | self buildExampleFor: anIndex]
]

{ #category : #building }
SBExampleGridsView >> buildExampleFor: aNumber [
		
	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				addAllMorphsBack: { 
					SBOwnTextMorph new contents: 'example: ', (self multiverse activeExamples at: aNumber) label.
					self currentClusterClass
						newForSize: self selectedResizer
						multiverse: self multiverse 
						displaying: aNumber}})
]

{ #category : #accessing }
SBExampleGridsView >> currentClusterClass [

	^ isDisplayingTrace 
		ifTrue: [SBExampleTrace] 
		ifFalse: [SBExampleCluster]
]

{ #category : #initialization }
SBExampleGridsView >> initialize [ 

	super initialize.
	
	self name: 'Example Focused'.
]
