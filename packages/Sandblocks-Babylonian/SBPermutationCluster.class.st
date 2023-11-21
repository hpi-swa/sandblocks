Class {
	#name : #SBPermutationCluster,
	#superclass : #SBCluster,
	#instVars : [
		'watches'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBPermutationCluster class >> newForSize: aSBMorphResizer havingWatches: aCollectionOfSBExampleWatches [

	^ self new 
		morphResizer: aSBMorphResizer;
		watches: aCollectionOfSBExampleWatches;
		visualize;
		yourself 
		
]

{ #category : #converting }
SBPermutationCluster >> buildDisplayMatrix [

	| matrix |
	self watches ifEmpty: [^ Matrix new].
	matrix := Matrix 
		rows: self watches size + 1
		columns: (self watches first examples size) + 1.
		
	matrix atRow: 1 put: ({self newTopLeftCornerPlaceholder}, 
		(self extractedTopHeadingsFrom: self watches)).
	matrix atColumn: 1 put: ({self newTopLeftCornerPlaceholder}, 
		(self extractedLeftHeadingsFrom: self watches)).
	
	self watches withIndexDo: [:aWatch :row | 
		(self extractColumnsFrom: aWatch) withIndexDo: [:aCellMorph :column| 
			matrix at: row+1 at: column+1 put: aCellMorph]].

	^ matrix
]

{ #category : #visualisation }
SBPermutationCluster >> extractColumnsFrom: aCollectionOfSBExampleWatches [

	^ aCollectionOfSBExampleWatches exampleToDisplay collect: [:anExampleValueDisplay | | displayedMorphs | 
		displayedMorphs := anExampleValueDisplay display displayedMorphs 
			collect: [:aMorph | aMorph watchValue morphResizer: self morphResizer. aMorph watchValue asValueMorph].
		(displayedMorphs size = 1) 
			ifTrue: [displayedMorphs first]
			ifFalse: [self newCellMorph 
						borderWidth: 0;
						when: #clicked send: #exploreValues to: anExampleValueDisplay display;
						listDirection: #leftToRight;
						wrapDirection: #topToBottom;
						addAllMorphsBack: displayedMorphs]].
]

{ #category : #visualisation }
SBPermutationCluster >> extractedLeftHeadingsFrom: aCollectionOfSBExampleWatches [

	^ (aCollectionOfSBExampleWatches collect: [:aWatch | aWatch expression copy])
]

{ #category : #visualisation }
SBPermutationCluster >> extractedTopHeadingsFrom: aCollectionOfSBExampleWatches [

	^ (aCollectionOfSBExampleWatches first exampleToDisplay values collect: [:aDisplay | aDisplay labelMorph copy])
]

{ #category : #accessing }
SBPermutationCluster >> watches [

	^ watches
]

{ #category : #accessing }
SBPermutationCluster >> watches: aCollectionOfSBExampleWatches [

	watches := aCollectionOfSBExampleWatches
]
