"
A mostly data class for collecting and caching watches, variants, methods found in a point of time
"
Class {
	#name : #SBMultiverse,
	#superclass : #Object,
	#instVars : [
		'universes',
		'variants',
		'watches',
		'activeExamples',
		'allMethodBlocksContainingVariants',
		'allMethodBlocksContainingWatches',
		'sandblockEditor'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'instance creation' }
SBMultiverse class >> bigbangInEditor: aSandblockEditor [

	^ self basicNew
		sandblockEditor: aSandblockEditor;
		initialize;
		asyncKaboom;
		yourself 
]

{ #category : #'instance creation' }
SBMultiverse class >> bigbangInEditorWithoutKaboom: aSandblockEditor [ 

	^ self basicNew
		sandblockEditor: aSandblockEditor;
		initialize;
		yourself 
]

{ #category : #'instance creation' }
SBMultiverse class >> new [
	
	"Use constructor with editor instead"
	self shouldNotImplement 
]

{ #category : #accessing }
SBMultiverse >> activeExamples [

	^ activeExamples
]

{ #category : #collecting }
SBMultiverse >> allActiveExamples [
	
	^ (self allCompiledMethodsContainingExamples 
		collect: [:aCompiledMethod | 
			"Only examples which are open in the editor can actually be active."
			self sandblockEditor blockFor: aCompiledMethod withInterfaces: #(#isMethod) 
				ifOpen: [:existingMethodBlock | existingMethodBlock containedExamples select: #active] 
				ifClosed: [#()]]) flatten
]

{ #category : #collecting }
SBMultiverse >> allCompiledMethodsContainingClass: aClass [

	"aClass should have #matchingSelectors implemented"
	^ (((aClass matchingSelectors collect: [:aSelector | self systemNavigation allCallsOn: aSelector]) flatten)
		reject: [:aMethodReference | aMethodReference actualClass = aClass class])
		collect: #compiledMethod
]

{ #category : #collecting }
SBMultiverse >> allCompiledMethodsContainingExampleWatches [

	^ self allCompiledMethodsContainingClass: SBExampleWatch
]

{ #category : #collecting }
SBMultiverse >> allCompiledMethodsContainingExamples [

	^ self allCompiledMethodsContainingClass: SBExample
]

{ #category : #collecting }
SBMultiverse >> allCompiledMethodsContainingVariants [

	^ self allCompiledMethodsContainingClass: SBVariant
]

{ #category : #accessing }
SBMultiverse >> allMethodBlocksContainingVariants [

	^ allMethodBlocksContainingVariants

]

{ #category : #accessing }
SBMultiverse >> allMethodBlocksContainingWatches [

	^ allMethodBlocksContainingWatches

]

{ #category : #actions }
SBMultiverse >> asyncKaboom [
	
	^ [self kaboom] forkAt: Processor userSchedulingPriority.
]

{ #category : #actions }
SBMultiverse >> cleanUp [
	
	watches do: #resumeGraphicalUpdates.
	(watches select: [:anOpenWatch | anOpenWatch containingArtefact isNil]) copy do: #delete
]

{ #category : #collecting }
SBMultiverse >> findExistingOrConvertToBlocks: aCollectionOfCompiledMethods [ 

	^ aCollectionOfCompiledMethods 
		collect: [:aCompiledMethod | 
			self sandblockEditor blockFor: aCompiledMethod withInterfaces: #(#isMethod) 
				ifOpen: [:existingMethodBlock | existingMethodBlock] 
				ifClosed: [aCompiledMethod asSandblock]]
]

{ #category : #'initialize-release' }
SBMultiverse >> gatherElements [

	"We are looking for already opened methods so that we can assign the
	variant there as the original in SBVariantProxy. That way, we immediately
	have consistency between changes."
	allMethodBlocksContainingVariants := self findExistingOrConvertToBlocks: self allCompiledMethodsContainingVariants.
	
	allMethodBlocksContainingWatches := self allCompiledMethodsContainingExampleWatches collect: #asSandblock.
	
	universes := OrderedCollection new.
	activeExamples := self allActiveExamples.
	
	variants := (allMethodBlocksContainingVariants collect: #containedVariants) flatten.
	variants := variants select: #isActive.
	
	watches := (self allMethodBlocksContainingWatches collect: #containedExampleWatches) flatten.
	watches do: [:aWatch | activeExamples do: [:anExample | aWatch exampleStarting: anExample].
							 aWatch hide. aWatch extent: 1@1].
	
]

{ #category : #'initialize-release' }
SBMultiverse >> initialize [ 

	super initialize.
	
	self gatherElements.
]

{ #category : #actions }
SBMultiverse >> kaboom [
	
	| outOfWorldWatches permutations |
	"Only open watches display values when examples are run. We want to show them too"
	(outOfWorldWatches := watches reject: #isInEditor) do: [:aWatch | self sandblockEditor openMorph: aWatch].
	permutations := (SBPermutation allPermutationsOf: variants).
	watches do: #stopGraphicalUpdates.
	
	"Running the active one last"
	(permutations sorted: [:a :b | a activeScore  <= b activeScore ] ) do: [:aPermutation | 
		self runPermutation: aPermutation copyingWatches: watches ].
	
	"but stay consistent of the permutation sequences for alignment in clusters" 
	"sorting this is cheaper than running a permutation twice just to reset to prior state"
	universes := universes sorted: [:a :b | 
		(permutations indexOf: a activePermutation) <= (permutations indexOf: b activePermutation)].
	self cleanUp.
	
	self triggerEvent: #updated.
]

{ #category : #actions }
SBMultiverse >> reset [

	allMethodBlocksContainingVariants := OrderedCollection new.
	allMethodBlocksContainingWatches := OrderedCollection new.
	variants := OrderedCollection new.
	activeExamples := OrderedCollection new.
	watches:= OrderedCollection new.
	universes := OrderedCollection withAll: ((SBPermutation allPermutationsOf: {}) 
		collect: [:aPermutation | SBUniverse newActive: aPermutation watches: {}]) .
	
	self triggerEvent: #updated.
]

{ #category : #actions }
SBMultiverse >> resolve [

	self allActiveExamples do: #stopRunning.
	
	(self findExistingOrConvertToBlocks: self allCompiledMethodsContainingVariants) do: [:aVariantMethod | 
		aVariantMethod containedVariants do: #replaceSelfWithChosen.
		self saveMethod: aVariantMethod].
	
	(self findExistingOrConvertToBlocks: self allCompiledMethodsContainingExampleWatches) do: [:aWatchMethod | 
		aWatchMethod containedExampleWatches do: #replaceWithWatchedExpression.
		self saveMethod: aWatchMethod].
	
	self reset.
	
]

{ #category : #actions }
SBMultiverse >> runPermutation: aPermutation copyingWatches: allWatches [
	
	SBActiveVariantPermutation value: aPermutation.
	activeExamples do: [:anExample | anExample runSynchUpdatingOnlyValuesOf: allWatches].
	universes add: (SBUniverse newActive: aPermutation watches: (allWatches collect: #asInactiveCopy))
			
]

{ #category : #accessing }
SBMultiverse >> sandblockEditor [

	^ sandblockEditor
]

{ #category : #accessing }
SBMultiverse >> sandblockEditor: aSandblockEditor [

	sandblockEditor := aSandblockEditor
]

{ #category : #'action-helper' }
SBMultiverse >> saveMethod: aMethod [

	aMethod save.
	aMethod sandblockEditor ifNotNil: [:theEditor | theEditor markSaved: aMethod]
	
]

{ #category : #accessing }
SBMultiverse >> universes [

	^ universes
]

{ #category : #accessing }
SBMultiverse >> variants [

	^ variants
]

{ #category : #accessing }
SBMultiverse >> watches [

	^ watches
]
