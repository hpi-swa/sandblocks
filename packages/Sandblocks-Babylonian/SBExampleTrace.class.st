Class {
	#name : #SBExampleTrace,
	#superclass : #SBExampleCluster,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #visualisation }
SBExampleTrace >> buildDisplayMatrix [

	| matrix displayedExample |
	matrix := Matrix 
		rows: 2
		columns: self multiverse universes size.
	displayedExample := self multiverse activeExamples at: self displayedIndex. 
		
	matrix atRow: 1 put: (self extractedTopHeadingsFrom: self multiverse).
	self multiverse universes withIndexDo: [:aUniverse :column | 
		matrix 
			at: 2 
			at: column 
			put: (SBTrace 
				newForSize: self morphResizer
				example: displayedExample 
				watches: aUniverse watches)].

	^ matrix
]

{ #category : #visualisation }
SBExampleTrace >> visualize [

	| matrix |
	self submorphs copy do: #delete.
	self multiverse watches ifEmpty: [self visualizeNothingToDisplay. ^ self].
	
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
