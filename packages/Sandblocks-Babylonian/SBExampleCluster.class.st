Class {
	#name : #SBExampleCluster,
	#superclass : #SBCluster,
	#instVars : [
		'displayedIndex',
		'multiverse'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBExampleCluster class >> newForSize: aSBMorphResizer multiverse: aSBMultiverse displaying: aNumber [

	^ self new 
		morphResizer: aSBMorphResizer;
		multiverse: aSBMultiverse;
		displayedIndex: aNumber;
		visualize;
		yourself 
		
]

{ #category : #visualisation }
SBExampleCluster >> buildDisplayMatrix [

	| matrix |
	matrix := Matrix 
		rows: (self multiverse universes first watches size) + 1
		columns: self multiverse universes size + 1.
		
	matrix atRow: 1 put: ({self newTopLeftCornerPlaceholder}, 
		(self extractedTopHeadingsFrom: self multiverse)).
	matrix atColumn: 1 put: ({self newTopLeftCornerPlaceholder}, 
		(self extractedLeftHeadingsFrom: self multiverse)).
	
	self multiverse universes withIndexDo: [:aUniverse :column | 
		(self extractRowsFrom: aUniverse) withIndexDo: [:aCellMorph :row| 
			matrix at: row+1 at: column+1 put: aCellMorph]].

	^ matrix
]

{ #category : #accessing }
SBExampleCluster >> displayedIndex [

	^ displayedIndex
]

{ #category : #accessing }
SBExampleCluster >> displayedIndex: aNumber [

	displayedIndex := aNumber
]

{ #category : #visualisation }
SBExampleCluster >> extractRowsFrom: aUniverse [

	^ aUniverse watches collect: [:anExample | | display displayedMorphs | 
		display := (anExample exampleToDisplay associations at: self displayedIndex) value display.
		displayedMorphs := display displayedMorphs collect: [:aMorph | 
			aMorph watchValue morphResizer: self morphResizer. 
			aMorph watchValue asValueMorph].
		(displayedMorphs size = 1) 
		ifTrue: [displayedMorphs first]
		ifFalse: [self newCellMorph 
					borderWidth: 0;
					when: #clicked send: #exploreValues to: display;
					listDirection: #leftToRight;
					wrapDirection: #topToBottom;
					addAllMorphsBack: displayedMorphs]]
]

{ #category : #visualisation }
SBExampleCluster >> extractedLeftHeadingsFrom: aSBMultiverse [

	^ (aSBMultiverse universes first watches collect: [:aWatch | aWatch expression copy])
]

{ #category : #visualisation }
SBExampleCluster >> extractedTopHeadingsFrom: aSBMultiverse [

	^ (aSBMultiverse universes collect: [:aUniverse | 
		self newContainerMorph 
			addAllMorphsBack: {
				SBStringMorph new contents: aUniverse activePermutation asString.
				SBButton newApplyPermutationFor: aUniverse activePermutation}])
]

{ #category : #accessing }
SBExampleCluster >> multiverse [

	^ multiverse
]

{ #category : #accessing }
SBExampleCluster >> multiverse: aSBMultiverse [

	multiverse := aSBMultiverse
]