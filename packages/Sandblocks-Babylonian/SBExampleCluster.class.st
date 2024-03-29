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

	^ aUniverse watches collect: [:aWatch | | display | 
		display := (aWatch exampleToDisplay at: (self multiverse activeExamples at: self displayedIndex)) value display.
		self compressedMorphsForDisplay: display]
]

{ #category : #visualisation }
SBExampleCluster >> extractedLeftHeadingsFrom: aSBMultiverse [

	^ (aSBMultiverse universes first watches collect: [:aWatch | aWatch expression copy])
]

{ #category : #visualisation }
SBExampleCluster >> extractedTopHeadingsFrom: aSBMultiverse [

	^ (aSBMultiverse universes collect: [:aUniverse | 
			SBPermutationLabel newDisplaying: aUniverse activePermutation])
]

{ #category : #accessing }
SBExampleCluster >> multiverse [

	^ multiverse
]

{ #category : #accessing }
SBExampleCluster >> multiverse: aSBMultiverse [

	multiverse := aSBMultiverse
]

{ #category : #visualisation }
SBExampleCluster >> newTopRowFrom: aCollectionOfPermutationLabels [
	
	"Width should be set, but height can vary"
	^ self newContainerMorph 
		listDirection: #leftToRight;
		listCentering: #bottomRight;
		cellPositioning: #topCenter;
		hResizing: #spaceFill;
		addAllMorphsBack: (aCollectionOfPermutationLabels collect: [:aLabel | 
			self morphResizer applyOn: aLabel])
]
