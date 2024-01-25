"
objectToPermutation is a WeakKeyDictionary to enable permutation execution for dynamic objects. E.G. UI is run in a shared process which does not know the SBActiveVariantPermutation of the example processes, resulting in all morphs running the same step method. 
"
Class {
	#name : #SBExploriants,
	#superclass : #SBTabView,
	#instVars : [
		'objectToPermutation',
		'updateProcess',
		'updateProcessRunning'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #accessing }
SBExploriants class >> deleteUniqueInstance [ 

	uniqueInstance := nil
]

{ #category : #'instance creation' }
SBExploriants class >> new [

	^ self error: 'Singleton. Use #uniqueInstance'
]

{ #category : #accessing }
SBExploriants class >> objectToPermutation [

	^ self uniqueInstance objectToPermutation
]

{ #category : #accessing }
SBExploriants class >> uniqueInstance [ 

	^ uniqueInstance ifNil: [uniqueInstance := super new]
]

{ #category : #comparing }
SBExploriants >> = other [

	^ self class = other class
]

{ #category : #callbacks }
SBExploriants >> artefactSaved: aMethodBlock [

	(aMethodBlock isMethod and: [self isInEditor]) ifTrue: [self tryToUpdateInBackgroundAfterChangeIn: aMethodBlock]
]

{ #category : #'ast helpers' }
SBExploriants >> binding: aString for: block class: aClass ifPresent: aBlock [

	"See SBStContainer >> binding:  for:  class:  ifPresent: "
	| outer |
	Symbol hasInterned: aString ifTrue: [:sym | | binding |
		binding := aClass bindingOf: sym environment: UndefinedObject environment.
		binding ifNotNil: [^ aBlock value: ((SBStName poolDeclaration: aString binding: binding) binding: binding)]].
	
	outer := self outerArtefact.
	(outer notNil and: [outer isSmalltalk]) ifTrue: [^ self outerArtefact binding: aString for: block class: aClass ifPresent: aBlock].
	
	^ nil
]

{ #category : #ui }
SBExploriants >> buildView [

	self addMorphBack: (self activeBlock hResizing: #shrinkWrap)
]

{ #category : #testing }
SBExploriants >> cacheType: aClass for: aBlock [
]

{ #category : #testing }
SBExploriants >> evaluationContext [

	^ nil
]

{ #category : #testing }
SBExploriants >> evaluationReceiver [

	^ self object
]

{ #category : #initialization }
SBExploriants >> initialize [

	super initialize.
	
	objectToPermutation := WeakKeyDictionary new.
	updateProcessRunning := false.
	
	self
		attachDecorator: SBMoveDecorator new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #testing }
SBExploriants >> isArtefact [ 

	^ true
]

{ #category : #accessing }
SBExploriants >> objectToPermutation [

	^ objectToPermutation
]

{ #category : #actions }
SBExploriants >> onlySwitchedTabsIn: aMethodBlock multiverse: aMultiverse [

	| methodClass methodSelector latestChange diff changes |
	(aMultiverse allMethodBlocksContainingVariants includes: aMethodBlock) 
		ifFalse: [^ false].
		
	methodClass := aMethodBlock compiledMethod methodClass.
	methodSelector := aMethodBlock compiledMethod selector.
	latestChange := (ChangeSet 
		scanVersionsOf: aMethodBlock compiledMethod
		class: methodClass 
		meta: methodClass isMeta
		category: (methodClass organization categoryOfElement: methodSelector)
		selector: methodSelector) second.
	diff := TextDiffBuilder new
		from: aMethodBlock compiledMethod getSource
		to: latestChange text.
	changes := OrderedCollection new.
	diff patchSequenceDoIfMatch: [ :string |]
			ifInsert: [ :string | changes add: string]
			ifRemove: [ :string| changes add: string].
	^ (changes allSatisfy: [:aString | aString matchesRegex: '\s*activeIndex\: \d*\s*']).
		
	
	 
]

{ #category : #'artefact protocol' }
SBExploriants >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	^ true
]

{ #category : #accessing }
SBExploriants >> selector [
	" if this node represents any selector, return it here "

	^ nil
]

{ #category : #actions }
SBExploriants >> tryToUpdateInBackgroundAfterChangeIn: aMethodBlock [

	| multiverse |
	multiverse := self active multiverse.
	(self onlySwitchedTabsIn: aMethodBlock multiverse: multiverse) ifTrue: [^ self].
		
	self updateInBackgroundOnTimeoutRevertTo: multiverse
	
	 
]

{ #category : #actions }
SBExploriants >> updateInBackgroundOnTimeoutRevertTo: theOldMultiverse [

	updateProcessRunning ifTrue: [
		updateProcess ifNotNil: #terminate.
		theOldMultiverse cleanUp.	
		updateProcessRunning := false.].
	
	updateProcessRunning := true.
	updateProcess := [
		| newMultiverse |
		newMultiverse := SBMultiverse bigbangInEditorWithoutKaboom: self sandblockEditor.
		self namedBlocks do: [:aTab | aTab multiverse: newMultiverse].
		[newMultiverse kaboom] 
			valueWithin: 7 seconds 
			onTimeout: [newMultiverse cleanUp. 
						  self namedBlocks do: [:aTab | aTab multiverse: theOldMultiverse]]. 
		updateProcess := nil. updateProcessRunning := false.
	] forkAt: Processor userBackgroundPriority.
]

{ #category : #actions }
SBExploriants >> visualize [

	| tabs |
	self width: 0.
	"tabs will visualize as soon as multiverse is finished"
	tabs := SBExploriantsView getTabsInMultiverse: (SBMultiverse bigbangInEditor: self sandblockEditor).
	
	self namedBlocks: tabs activeIndex: 1.
	
]
