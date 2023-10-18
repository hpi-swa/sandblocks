Class {
	#name : #SBResultsView,
	#superclass : #SBExploriantsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBResultsView >> addAllWatchesFrom: aCollectionOfMethodBlocks [

	self block addAllMorphsBack: (self allWatchesIn: aCollectionOfMethodBlocks)
]

{ #category : #accessing }
SBResultsView >> allActiveExamples [
	
	^ (self allCompiledMethodsContainingExamples 
		collect: [:aCompiledMethod | 
			"Only examples which are open in the editor can actually be active."
			SBEditor current blockFor: aCompiledMethod withInterfaces: #(#isMethod) 
				ifOpen: [:existingMethodBlock | existingMethodBlock containedExamples select: #active] 
				ifClosed: [#()]]) flatten
]

{ #category : #accessing }
SBResultsView >> allCompiledMethodsContainingExampleWatches [

	^ self allCompiledMethodsContainingClass: SBExampleWatch
]

{ #category : #accessing }
SBResultsView >> allCompiledMethodsContainingExamples [

	^ self allCompiledMethodsContainingClass: SBExample
]

{ #category : #accessing }
SBResultsView >> allMethodBlocksContainingWatches [

	"We need existing originals to be noticed of changes."
	^ self findExistingOrConvertToBlocks: self allCompiledMethodsContainingExampleWatches 

]

{ #category : #accessing }
SBResultsView >> allWatchesIn: aCollectionOfMethodBlocks [
	
	^ (aCollectionOfMethodBlocks collect: [:aMethodBlock | 
		aMethodBlock containedExampleWatches collect: #asInactiveCopy]) flatten
]

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

	| permutations activeExamples watchMethodBlocks variants |
	self flag: #todo. "don't calculate all variants a second time (first time being the variants view) -jb"
	variants := (self allMethodBlocksContainingVariants collect: #containedVariants) flatten.
	watchMethodBlocks := self allMethodBlocksContainingWatches.
	activeExamples := self allActiveExamples.
	permutations := SBPermutation allPermutationsOf: variants.
	
	permutations ifEmpty: [self addAllWatchesFrom: watchMethodBlocks].
	
	[ permutations do: [:aPermutation |
		SBActiveVariantPermutation value: aPermutation.
		activeExamples do: #runSynchronouslyIgnoreReturn.
		self buildPermutationFor: aPermutation collectingWatchesFrom: watchMethodBlocks].
		self resetWatchesToOriginalPermutationRunning: activeExamples] forkAt: Processor userSchedulingPriority
]

{ #category : #building }
SBResultsView >> buildPermutationFor: aPermutation collectingWatchesFrom: aCollectionOfMethodBlocks [

	self block addAllMorphsBack: { SBOwnTextMorph new contents: aPermutation asString.
									self applyButtonFor: aPermutation. 
									(self containerRow listDirection: #leftToRight) 
										addAllMorphsBack: (self allWatchesIn: aCollectionOfMethodBlocks).
									LineMorph from: 0@0 to: 50@0 color: Color black width: 2}
]

{ #category : #initialization }
SBResultsView >> initialize [ 

	super initialize.
	
	self name: 'Possible Results'.
	
	self visualize
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