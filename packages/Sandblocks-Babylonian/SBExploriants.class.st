"
objectToPermutation is a WeakKeyDictionary to enable permutation execution for dynamic objects. E.G. UI is run in a shared process which does not know the SBActiveVariantPermutation of the example processes, resulting in all morphs running the same step method. 
"
Class {
	#name : #SBExploriants,
	#superclass : #SBTabView,
	#instVars : [
		'objectToPermutation'
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
SBExploriants >> visualize [

	| tabs |
	self width: 0.
	"tabs will visualize as soon as multiverse is finished"
	tabs := SBExploriantsView getTabsInMultiverse: (SBMultiverse newInEditor: self sandblockEditor).
	
	self namedBlocks: tabs activeIndex: 1.
	
]
