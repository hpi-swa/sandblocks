Class {
	#name : #SBPermutationCluster,
	#superclass : #SBCluster,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #visualisation }
SBPermutationCluster >> extractColumnsFrom: anExampleWatch [

	^ anExampleWatch exampleToDisplay collect: [:anExampleValueDisplay | | displayedMorphs | 
		displayedMorphs := anExampleValueDisplay display displayedMorphs 
			collect: [:aMorph | aMorph watchValue morphResizer: self morphResizer. aMorph watchValue asValueMorph].
		self flag: #todo. "Another way besides turning into an image to keep interactions.-jb"
		(displayedMorphs size = 1) 
			ifTrue: [displayedMorphs first]
			ifFalse: [
				ImageMorph new newForm: (
					self newCellMorph 
						listDirection: #leftToRight;
						wrapDirection: #topToBottom;
						addAllMorphsBack: displayedMorphs;
						iconOrThumbnailOfSize: self newCellMorph extent)]].
]

{ #category : #visualisation }
SBPermutationCluster >> extractedLeftHeadingsFrom: aCollectionOfSBExampleWatches [

	^ (aCollectionOfSBExampleWatches collect: [:aWatch | aWatch expression copy])
]

{ #category : #visualisation }
SBPermutationCluster >> extractedTopHeadingsFrom: aCollectionOfSBExampleWatches [

	^ (aCollectionOfSBExampleWatches first exampleToDisplay values collect: [:aDisplay | aDisplay labelMorph copy])
]

{ #category : #visualisation }
SBPermutationCluster >> watchesAsMatrix: aCollectionOfSBExampleWatches [

	| matrix |
	matrix := Matrix 
		rows: aCollectionOfSBExampleWatches size + 1
		columns: (aCollectionOfSBExampleWatches first examples size) + 1.
		
	matrix atRow: 1 put: ({self newTopLeftCornerPlaceholder}, 
		(self extractedTopHeadingsFrom: aCollectionOfSBExampleWatches)).
	matrix atColumn: 1 put: ({self newTopLeftCornerPlaceholder}, 
		(self extractedLeftHeadingsFrom: aCollectionOfSBExampleWatches)).
	
	aCollectionOfSBExampleWatches withIndexDo: [:aWatch :row | 
		(self extractColumnsFrom: aWatch) withIndexDo: [:aCellMorph :column| 
			matrix at: row+1 at: column+1 put: aCellMorph]].

	^ matrix
]
