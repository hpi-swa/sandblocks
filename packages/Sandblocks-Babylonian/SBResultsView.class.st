Class {
	#name : #SBResultsView,
	#superclass : #SBExploriantsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBResultsView >> applyButtonFor: aPermutation [ 
	
	^ SBButton new
		icon: (SBIcon iconCheck
				size: 6.0 sbScaled;
				color: (Color r: 0.0 g: 1 b: 0.0))
			label: 'Apply Permutation'
			do: [aPermutation apply];
		makeSmall;
		cornerStyle: #squared
]

{ #category : #building }
SBResultsView >> buildAllPossibleResults [
	
	self multiverse universes ifEmpty: [self block addAllMorphsBack: self mutliverse watches].
	
	[ self multiverse universes do: [:aUniverse |
		SBActiveVariantPermutation value: aUniverse activePermutation.
		self multiverse activeExamples do: #runSynchronouslyIgnoreReturn.
		self buildPermutationFor: aUniverse].
		self resetWatchesToOriginalPermutationRunning: self multiverse activeExamples] forkAt: Processor userSchedulingPriority
]

{ #category : #building }
SBResultsView >> buildPermutationFor: aSBUniverse [

	self block addAllMorphsBack: { SBOwnTextMorph new contents: aSBUniverse activePermutation asString.
									self applyButtonFor: aSBUniverse activePermutation. 
									(self containerRow listDirection: #leftToRight) 
										addAllMorphsBack: aSBUniverse watches.
									LineMorph from: 0@0 to: 50@0 color: Color black width: 2}
]

{ #category : #initialization }
SBResultsView >> initialize [ 

	super initialize.
	
	self name: 'Simple View'
]

{ #category : #building }
SBResultsView >> resetWatchesToOriginalPermutationRunning: activeExamples [

	SBActiveVariantPermutation value: nil.
	activeExamples do: #runSynchronouslyIgnoreReturn
]

{ #category : #building }
SBResultsView >> updateButton [

	^ SBButton new
		icon: SBIcon iconRotateLeft
			label: 'Re-Generate'
			do: [self visualize];
		cornerStyle: #squared
]

{ #category : #actions }
SBResultsView >> visualize [ 

	self clean.

	self block addMorphBack: self updateButton.
	self buildAllPossibleResults 
]
