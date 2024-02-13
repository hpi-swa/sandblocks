Class {
	#name : #SBPermutationTraces,
	#superclass : #SBPermutationCluster,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #converting }
SBPermutationTraces >> buildDisplayMatrix [

	| matrix |
	self hasNothingToDisplay ifTrue: [^ Matrix new].
	matrix := Matrix 
		rows: 2
		columns: self watches first examples size.
		
	matrix atRow: 1 put: (self extractedTopHeadingsFrom: self watches).
	matrix atRow: 2 put: (self watches first examples collect: [:anExample |
		SBTrace newForExample: anExample watches: self watches]).

	^ matrix
]

{ #category : #converting }
SBPermutationTraces >> hasNothingToDisplay [

	^ self watches isEmpty or: [self watches first examples isEmpty]
]

{ #category : #converting }
SBPermutationTraces >> visualize [

	| matrix |
	self submorphs copy do: #delete.
	self hasNothingToDisplay ifTrue:  [self visualizeNothingToDisplay. ^ self].
	
	matrix := self buildDisplayMatrix.
	self addAllMorphsBack: {self newContainerMorph 
			listDirection: #leftToRight;
			cellPositioning: #topLeft;
			cellInset: 0;
			addAllMorphsBack:(
				(matrix atRow: 2) withIndexCollect: [:aTrace :i | 
					self wrapInCell:  (aTrace addMorphFront:(
						self newContainerMorph
							wrapCentering: #center;
							hResizing: #spaceFill;
							addMorphBack: (matrix at: 1 at: i)))
					flexVertically: true 
					flexHorizontally: true ])}
]
