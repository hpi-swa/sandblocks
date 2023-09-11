Class {
	#name : #SBResultsView,
	#superclass : #SBExploriantsView,
	#instVars : [
		'variants'
	],
	#category : #'Sandblocks-Core'
}

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
SBResultsView >> buildAllPossibleResults [

	| permutations activeExamples watchMethodBlocks |
	self flag: #todo. "don't calculate all variants a second time (first time being the variants view) -jb"
	variants := (self allMethodBlocksContainingVariants collect: #containedVariants) flatten.
	watchMethodBlocks := self allMethodBlocksContainingWatches.
	activeExamples := self allActiveExamples.
	permutations := SBPermutation allPermutationsOf: variants.
	
	[ permutations do: [:aPermutation |
		SBActiveVariantPermutation value: aPermutation.
		activeExamples do: #basicRunSynchronously.
		self buildPermutationFor: aPermutation collectingWatchesFrom: watchMethodBlocks]] 
	forkAt: Processor userSchedulingPriority
]

{ #category : #building }
SBResultsView >> buildPermutationFor: aPermutation collectingWatchesFrom: aCollectionOfMethodBlocks [

	self block addMorphBack: (self titleMorphForPermutation: aPermutation).
	self block addMorphBack: (
		self containerRow 
			addMorphBack: ((self containerRow listDirection: #leftToRight) 
				addAllMorphsBack: (self allWatchesIn: aCollectionOfMethodBlocks))).
	self block addMorphBack: (LineMorph from: 0@0 to: 50@0 color: Color black width: 2)
]

{ #category : #initialization }
SBResultsView >> initialize [ 

	super initialize.
	
	self name: 'Possible Results'.
	
	self visualize
]

{ #category : #building }
SBResultsView >> titleMorphForPermutation: aPermutation [

	"collecting instead of calling (a active name), ', ', (b active name) in fold
	as one variant only will not return a string but a variant"
	^ SBOwnTextMorph new contents: (
		(aPermutation referencedVariants collect: [:aVariant | 
			(aVariant blockAt: (aPermutation at: aVariant id)) name]) 
			fold: [:a :b | a, ', ', b ])
]

{ #category : #actions }
SBResultsView >> visualize [ 

	self buildAllPossibleResults 
]
