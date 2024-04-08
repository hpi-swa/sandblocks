"
objectToPermutation is a WeakKeyDictionary to enable permutation execution for dynamic objects. E.G. UI is run in a shared process which does not know the SBActiveVariantPermutation of the example processes, resulting in all morphs running the same step method. 
"
Class {
	#name : #SBExploriants,
	#superclass : #SBTabView,
	#instVars : [
		'objectToPermutation',
		'updateProcess',
		'updateProcessRunning',
		'ignoreUpdate'
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

{ #category : #ui }
SBExploriants >> asTabButton: aNamedBlock [

	| button |
	button := super asTabButton: aNamedBlock.
	button when: #doubleClicked send: #value to: [].
	
	^ button
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

{ #category : #accessing }
SBExploriants >> buttonClass [

	^ SBButton 
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

{ #category : #accessing }
SBExploriants >> ignoreUpdate [

	^ ignoreUpdate
]

{ #category : #accessing }
SBExploriants >> ignoreUpdate: aBoolean [

	ignoreUpdate := aBoolean
]

{ #category : #initialization }
SBExploriants >> initialize [

	super initialize.
	
	objectToPermutation := WeakKeyDictionary new.
	updateProcessRunning := false.
	ignoreUpdate := false.
	namedBlocks := {SBExploriantsView new} asOrderedCollection.
	
	self
		attachDecorator: SBMoveDecorator new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #initialization }
SBExploriants >> intoWorld: aWorld [

	super intoWorld: aWorld.
	SystemChangeNotifier uniqueInstance
		noMoreNotificationsFor: self;
		notify: self ofSystemChangesOfItem: #method using: #methodChanged:
]

{ #category : #testing }
SBExploriants >> isArtefact [ 

	^ true
]

{ #category : #initialization }
SBExploriants >> methodChanged: anEvent [

	anEvent isModified 
		ifTrue: [
			namedBlocks detect: #isHistory
			ifFound: [:history | history addCodeSnapshot: anEvent]]
]

{ #category : #accessing }
SBExploriants >> objectToPermutation [

	^ objectToPermutation
]

{ #category : #initialization }
SBExploriants >> outOfWorld: aWorld [

	SystemChangeNotifier uniqueInstance noMoreNotificationsFor: self.
	super outOfWorld: aWorld
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
	self active wantsReloadOnSaveWhenOpen ifFalse: [^self].
	
	self ignoreUpdate 
		ifFalse: [self updateInBackgroundOnTimeoutRevertTo: multiverse]
		ifTrue: [
		[self sandblockEditor sendNewPermutationNotification] forkAt: Processor userBackgroundPriority.
		self ignoreUpdate: false.]
		
	
	 
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
			valueWithin: 20 seconds 
			onTimeout: [newMultiverse cleanUp. 
						  self namedBlocks do: [:aTab | aTab multiverse: theOldMultiverse]]. 
		updateProcess := nil. updateProcessRunning := false.
	] forkAt: Processor userBackgroundPriority.
]

{ #category : #actions }
SBExploriants >> visualize [
	
	|tabs|
	self width: 0.
	ignoreUpdate := false.
	"tabs will visualize as soon as multiverse is finished"
	tabs := SBExploriantsView getTabsInMultiverse: (SBMultiverse bigbangInEditor: self sandblockEditor).
	
	self namedBlocks: tabs activeIndex: 1.
	
]
