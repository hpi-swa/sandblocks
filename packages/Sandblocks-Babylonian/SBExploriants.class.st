Class {
	#name : #SBExploriants,
	#superclass : #SBTabView,
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
SBExploriants class >> uniqueInstance [ 

	^ uniqueInstance ifNil: [uniqueInstance := super new]
]

{ #category : #comparing }
SBExploriants >> = other [

	^ self class = other class
]

{ #category : #initialization }
SBExploriants >> initialize [

	super initialize.
	
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

{ #category : #'artefact protocol' }
SBExploriants >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	^ true
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
