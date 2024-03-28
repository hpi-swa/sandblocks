Class {
	#name : #SBCorrelationCluster,
	#superclass : #SBCluster,
	#instVars : [
		'displayedExample',
		'displayedWatch',
		'baseUniverse',
		'basePermutation',
		'correlatingUniverses'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'instance creation' }
SBCorrelationCluster class >> newForSize: aSBMorphResizer example: anExample watch: aWatch basePermutation: aPermutation correlating: aCollectionOfUniverses [

	^ self new 
		morphResizer: aSBMorphResizer;
		displayedExample: anExample;
		displayedWatch: aWatch;
		basePermutation: aPermutation;
		correlatingUniverses: aCollectionOfUniverses;
		visualize;
		yourself 
]

{ #category : #accessing }
SBCorrelationCluster >> basePermutation [
	^ basePermutation
]

{ #category : #accessing }
SBCorrelationCluster >> basePermutation: anObject [
	basePermutation := anObject
]

{ #category : #accessing }
SBCorrelationCluster >> baseUniverse [

	^ baseUniverse
]

{ #category : #accessing }
SBCorrelationCluster >> baseUniverse: aUniverse [

	baseUniverse := aUniverse
]

{ #category : #building }
SBCorrelationCluster >> buildDisplayMatrix [

	| matrix |
	
	matrix := Matrix 
		rows: 2
		columns: self correlatingUniverses size + 1.
		
	matrix atRow: 1 put: ({TextMorph new contents: self basePermutation asVariantString}, 
	(self extractedTopHeadingsFrom: self correlatingUniverses)).
	
	matrix at: 2 at: 1 put: (SBPermutationLabel newDisplaying: self basePermutation).

	self extractRow withIndexDo: [:aCellMorph :column | matrix at: 2 at: column+1 put: aCellMorph].

	^ matrix
]

{ #category : #accessing }
SBCorrelationCluster >> correlatingUniverses [

	^ correlatingUniverses
]

{ #category : #accessing }
SBCorrelationCluster >> correlatingUniverses: aCollectionOfUniverses [

	correlatingUniverses := aCollectionOfUniverses
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

	^ self correlatingUniverses 
		collect: [:aUniverse | | display | 
		display := ((aUniverse watches detect: [:aWatch | aWatch originalIdentifier = self displayedWatch identifier]) 
					exampleToDisplay at: self displayedExample) value display.
		self compressedMorphsForDisplay: display]
]

{ #category : #building }
SBCorrelationCluster >> extractedTopHeadingsFrom: aCollectionOfCorrelatingUniverses [

	^ aCollectionOfCorrelatingUniverses collect: [:aCorrelatingUniverse |  
		SBPartialPermutationLabel 
			newDisplaying: (aCorrelatingUniverse activePermutation copyRemovingVariants: self basePermutation referencedVariants)
			referingTo: aCorrelatingUniverse]
]

{ #category : #visualisation }
SBCorrelationCluster >> newTopRowFrom: aCollectionOfPermutationLabels [
	
	"Width should be set, but height can vary"
	^ self newContainerMorph 
		listDirection: #leftToRight;
		listCentering: #bottomRight;
		cellPositioning: #topCenter;
		hResizing: #spaceFill;
		addAllMorphsBack: (aCollectionOfPermutationLabels collect: [:aLabel | 
			self newContainerMorph 
				addAllMorphsBack: {
					(self 
						wrapInCell: aLabel 
						flexVertically: true 
						flexHorizontally: false)  borderWidth: 0.
					SBButton newApplyPermutationFor: (aLabel universe activePermutation).}])
]
