Class {
	#name : #SBExploriants,
	#superclass : #SBBlock,
	#instVars : [
		'watchMethodBlocks',
		'variants',
		'activeExamples'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Sandblocks-Core'
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

{ #category : #'as yet unclassified' }
SBExploriants >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	^ true
]

{ #category : #actions }
SBExploriants >> visualize [

	self submorphs copy do: #delete.
	
	self addMorphBack: SBExploriantsView asTabView.
]
