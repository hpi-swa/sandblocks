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
SBMultiverse class >> new [
	
	"Use constructor with editor instead"
	self shouldNotImplement 
]

{ #category : #'instance creation' }
SBMultiverse class >> newInEditor: aSandblockEditor [

	^ self basicNew
		sandblockEditor: aSandblockEditor;
		initialize;
		yourself 
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

{ #category : #collecting }
SBMultiverse >> copyWatchesIn: aCollectionOfMethodBlocks [
	
	^ (aCollectionOfMethodBlocks collect: [:aMethodBlock | 
		aMethodBlock containedExampleWatches collect: #asInactiveCopy]) flatten
]

{ #category : #converting }
SBMultiverse >> createUniverseFomPermutation: aSBPermutation [ 

	^ SBUniverse 
		newActive: aSBPermutation
		watches: (self copyWatchesIn: self allMethodBlocksContainingWatches)
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
SBMultiverse >> initialize [

	super initialize.
	
	"We are looking for already opened methods so that we can assign the
	variant there as the original in SBVariantProxy. That way, we immediately
	have consistency between changes."
	allMethodBlocksContainingVariants := self findExistingOrConvertToBlocks: self allCompiledMethodsContainingVariants.
	
	"We need existing originals to be noticed of changes."
	allMethodBlocksContainingWatches := self findExistingOrConvertToBlocks: self allCompiledMethodsContainingExampleWatches.
	
	variants := (allMethodBlocksContainingVariants collect: #containedVariants) flatten.
	activeExamples := self allActiveExamples.
	
	universes := (SBPermutation allPermutationsOf: variants) collect: [:aPermutation |
		self createUniverseFomPermutation: aPermutation].
	
	
]

{ #category : #accessing }
SBMultiverse >> sandblockEditor [

	^ sandblockEditor
]

{ #category : #accessing }
SBMultiverse >> sandblockEditor: aSandblockEditor [

	sandblockEditor := aSandblockEditor
]

{ #category : #accessing }
SBMultiverse >> universes [

	^ universes
]

{ #category : #accessing }
SBMultiverse >> variants [

	^ variants
]