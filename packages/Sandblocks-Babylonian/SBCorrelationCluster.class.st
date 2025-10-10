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
		
	matrix atRow: 1 put: ({TextMorph new
								tag: (SBTag newFromPermutation: self basePermutation); 
								contents: self basePermutation asVariantString;
								yourself}, 
	(self extractedTopHeadingsFrom: self correlatingUniverses)).
	
	matrix at: 2 at: 1 put: ((SBPermutationLabel 
								newDisplaying: self basePermutation)
								tag: (SBTag newFromPermutation: self basePermutation);
								yourself).

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
		collect: [:aUniverse | | display watchMorph |
		watchMorph :=  aUniverse watches detect: [:aWatch | aWatch originalIdentifier = self displayedWatch identifier].
		display := (watchMorph exampleToDisplay at: self displayedExample) value display.
		(self compressedMorphsForDisplay: display)
			tag: (SBTag new
				addFromExample: self displayedExample;
				addFromWatch: self displayedWatch;
				addFromPermutation: aUniverse activePermutation )]
]

{ #category : #building }
SBCorrelationCluster >> extractedTopHeadingsFrom: aCollectionOfCorrelatingUniverses [

	^ aCollectionOfCorrelatingUniverses collect: [:aCorrelatingUniverse | | partialPermutation |
		partialPermutation :=  (aCorrelatingUniverse activePermutation copyRemovingVariants: self basePermutation referencedVariants).
		(SBPartialPermutationLabel 
			newDisplaying: partialPermutation
			referingTo: aCorrelatingUniverse)]
]

{ #category : #visualisation }
SBCorrelationCluster >> newLeftColumnFrom: aCollectionOfMorphs [
	
	"Height should be set, but width can vary"
	^ self newContainerMorph 
		cellPositioning: #rightCenter;
		addAllMorphsBack: (aCollectionOfMorphs collect: [:aMorph | 
			aMorph wrapFlag: false.
			(self wrapInCell: aMorph flexVertically: false flexHorizontally: true)
				listDirection: #rightToLeft;
				borderWidth: 0])
]

{ #category : #visualisation }
SBCorrelationCluster >> newTopRowFrom: aCollectionOfPermutationLabels [
	
	"Width should be set, but height can vary"
	^ self newContainerMorph 
		listDirection: #leftToRight;
		listCentering: #bottomRight;
		cellPositioning: #bottomCenter;
		hResizing: #spaceFill;
		addAllMorphsBack: (aCollectionOfPermutationLabels collect: [:aLabel | 
				self newContainerMorph addMorphBack: (self morphResizer applyOn: aLabel)])
]

{ #category : #helper }
SBCorrelationCluster >> wrapInCell: aMorph [

	^ self morphResizer label = SBMorphResizer newIdentity label
		ifTrue: [self wrapInCell: aMorph flexVertically: true flexHorizontally: true] 
		ifFalse: [self wrapInCell: aMorph flexVertically: true flexHorizontally: false]
]
