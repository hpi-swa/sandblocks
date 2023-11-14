Class {
	#name : #SBPermutationCluster,
	#superclass : #SBCluster,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #visualisation }
SBPermutationCluster >> extractedLeftHeadingsFrom: aCollectionOfSBExampleWatches [

	^ (aCollectionOfSBExampleWatches collect: [:aWatch | aWatch expression])
]

{ #category : #visualisation }
SBPermutationCluster >> extractedTopHeadingsFrom: aCollectionOfSBExampleWatches [

	^ (aCollectionOfSBExampleWatches first exampleToDisplay values collect: [:aDisplay | aDisplay labelMorph])
]

{ #category : #visualisation }
SBPermutationCluster >> watchesAsMatrix: aCollectionOfSBExampleWatches [

	| matrix |
	matrix := Matrix 
		rows: aCollectionOfSBExampleWatches size + 1
		columns: (aCollectionOfSBExampleWatches first examples size) + 1.
	matrix atRow: 1 put: ({self newTopLeftCornerPlaceholder}, (self extractedTopHeadingsFrom: aCollectionOfSBExampleWatches)).
	matrix atColumn: 1 put: ({self newTopLeftCornerPlaceholder}, (self extractedLeftHeadingsFrom: aCollectionOfSBExampleWatches)).
	aCollectionOfSBExampleWatches withIndexDo: [:aWatch :row | 
		aWatch exampleToDisplay withIndexDo: [:exampleDisplayAssc :column | . 
		matrix at: row+1 at: column+1 put: (exampleDisplayAssc display)]].
	^ matrix
]
