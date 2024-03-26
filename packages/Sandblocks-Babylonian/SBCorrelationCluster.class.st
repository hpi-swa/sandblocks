Class {
	#name : #SBCorrelationCluster,
	#superclass : #SBCluster,
	#instVars : [
		'multiverse',
		'displayedExample',
		'displayedWatch',
		'opponentPermutations',
		'basePermutation'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'instance creation' }
SBCorrelationCluster class >> newForSize: aSBMorphResizer multiverse: aMultiverse example: anExample watch: aWatch basePermutation: base opponentPermutations: opponent [

	^ self new 
		morphResizer: aSBMorphResizer;
		multiverse: aMultiverse;
		displayedExample: anExample;
		displayedWatch: aWatch;
		basePermutation: base;
		opponentPermutations: opponent;
		visualize;
		yourself 
]

{ #category : #accessing }
SBCorrelationCluster >> basePermutation [

	^ basePermutation
]

{ #category : #accessing }
SBCorrelationCluster >> basePermutation: aSBPermutation [

	basePermutation := aSBPermutation
]

{ #category : #building }
SBCorrelationCluster >> buildDisplayMatrix [

	| matrix |
	
	matrix := Matrix 
		rows: 2
		columns: self opponentPermutations size + 1.
		
	matrix atRow: 1 put: ({TextMorph new contents: self basePermutation asVariantString}, 
	(self extractedTopHeadingsFrom: self opponentPermutations)).
	
	matrix at: 2 at: 1 put: (SBPermutationLabel newDisplaying: self basePermutation).

	self extractRow withIndexDo: [:aCellMorph :column | matrix at: 2 at: column+1 put: aCellMorph].

	^ matrix
]

{ #category : #accessing }
SBCorrelationCluster >> displayedExample [

	^ displayedExample
]

{ #category : #accessing }
SBCorrelationCluster >> displayedExample: aSBExample [

	displayedExample := aSBExample
]

{ #category : #accessing }
SBCorrelationCluster >> displayedWatch [

	^ displayedWatch
]

{ #category : #accessing }
SBCorrelationCluster >> displayedWatch: anSBExampleWatch [

	displayedWatch := anSBExampleWatch
]

{ #category : #building }
SBCorrelationCluster >> extractRow [

	^ self multiverse universes 
		select: [:aUniverse | (aUniverse activePermutation contains: self basePermutation)]
		thenCollect: [:aUniverse | | display | 
		display := ((aUniverse watches detect: [:aWatch | aWatch originalIdentifier = self displayedWatch identifier]) 
					exampleToDisplay at: self displayedExample) value display.
		self compressedMorphsForDisplay: display]
]

{ #category : #building }
SBCorrelationCluster >> extractedLeftHeadingsFrom: aCollectionOfPermutations [

	^ aCollectionOfPermutations collect: [:aPermutation | SBPermutationLabel newDisplaying: aPermutation]
]

{ #category : #building }
SBCorrelationCluster >> extractedTopHeadingsFrom: aCollectionOfPermutations [

	^ aCollectionOfPermutations collect: [:aPermutation | 
		aPermutation isNilPermutation 
			ifTrue: [StringMorph new contents: ' / '] 
			ifFalse: [SBPermutationLabel newDisplaying: aPermutation]]
]

{ #category : #accessing }
SBCorrelationCluster >> multiverse [

	^ multiverse
]

{ #category : #accessing }
SBCorrelationCluster >> multiverse: aSBMultiverse [

	multiverse := aSBMultiverse
]

{ #category : #accessing }
SBCorrelationCluster >> opponentPermutations [

	^ opponentPermutations
]

{ #category : #accessing }
SBCorrelationCluster >> opponentPermutations: aCollectionOfSBPermutations [

	opponentPermutations := aCollectionOfSBPermutations
]
