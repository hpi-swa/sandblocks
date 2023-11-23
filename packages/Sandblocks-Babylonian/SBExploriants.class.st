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

{ #category : #ui }
SBExploriants >> buildTabs [

	super buildTabs.
	(self submorphNamed: #tabs) firstSubmorph delete.
]

{ #category : #initialization }
SBExploriants >> initialize [

	super initialize.
	
	objectToPermutation := WeakKeyDictionary new.
	
	self
		attachDecorator: SBMoveDecorator new;
		changeTableLayout;
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

{ #category : #'as yet unclassified' }
SBExploriants >> selector [
	" if this node represents any selector, return it here "

	^ nil
]

{ #category : #accessing }
SBExploriants >> tabs [

	^ (self submorphNamed: #tabs) submorphs allButLast
]

{ #category : #actions }
SBExploriants >> visualize [

	"The Views need a parent to visualize themselves. We also want to avoid double-calculations"
	| tabs |
	tabs := SBExploriantsView getTabs.
	tabs do: [:aTab | self addMorph: aTab block. aTab visualize.].
	self removeAllMorphs.
	
	self namedBlocks: tabs activeIndex: 1.
	
]
