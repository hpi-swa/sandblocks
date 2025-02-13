Class {
	#name : #SBExampleCluster,
	#superclass : #SBCluster,
	#instVars : [
		'displayedIndex',
		'examples',
		'universes'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBExampleCluster class >> newForSize: aSBMorphResizer multiverse: aSBMultiverse displaying: aNumber [

	^ self new 
		morphResizer: aSBMorphResizer;
		universes: aSBMultiverse universes;
		examples: aSBMultiverse activeExamples; 
		displayedIndex: aNumber;
		visualize;
		yourself 
		
]

{ #category : #visualisation }
SBExampleCluster >> buildDisplayMatrix [

	| matrix |
	matrix := Matrix 
		rows: self universes first watches size + 1
		columns: self universes size + 1.
		
	matrix atRow: 1 put: ({self newTopLeftCornerPlaceholder}, 
		(self extractedTopHeadingsFrom: self universes)).
	matrix atColumn: 1 put: ({self newTopLeftCornerPlaceholder}, 
		(self extractedLeftHeadingsFrom: self universes first watches)).
	
	self universes withIndexDo: [:aUniverse :column | 
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

{ #category : #accessing }
SBExampleCluster >> examples [

	^ examples
]

{ #category : #accessing }
SBExampleCluster >> examples: aCollectionOfSBExamples [
	
	examples := aCollectionOfSBExamples
]

{ #category : #visualisation }
SBExampleCluster >> extractRowsFrom: aUniverse [

	^ aUniverse watches collect: [:aWatch | | display | 
		display := (aWatch exampleToDisplay at: (self examples at: self displayedIndex)) value display.
		(self compressedMorphsForDisplay: display) 
			tag: ((SBTag newFromWatch: aWatch) addFromPermutation: aUniverse activePermutation)]
]

{ #category : #visualisation }
SBExampleCluster >> extractedLeftHeadingsFrom: aCollectionOfSBExampleWatches [

	^ (aCollectionOfSBExampleWatches collect: [:aWatch | 
		aWatch expression copy
			tag: (SBTag newFromWatch: aWatch)])
]

{ #category : #visualisation }
SBExampleCluster >> extractedTopHeadingsFrom: aCollectionOfSBUniverses [

	^ aCollectionOfSBUniverses collect: [:aUniverse | 
		(SBPermutationLabel newDisplaying: aUniverse activePermutation)
			tag:  (SBTag newFromPermutation: aUniverse activePermutation)]
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

{ #category : #accessing }
SBExampleCluster >> universes [

	^ universes
]

{ #category : #accessing }
SBExampleCluster >> universes: aCollectionOfSBUniverses [

	universes := aCollectionOfSBUniverses
]
