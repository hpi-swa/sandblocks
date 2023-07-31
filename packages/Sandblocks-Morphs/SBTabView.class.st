Class {
	#name : #SBTabView,
	#superclass : #SBBlock,
	#instVars : [
		'namedBlocks',
		'activeIndex'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBTabView class >> example [

	SBMorphExample
		setUp: [self new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBTabView class >> namedBlocks: aCollectionOfSBNamedBlocks [

	^ self new namedBlocks: aCollectionOfSBNamedBlocks
]

{ #category : #'as yet unclassified' }
SBTabView >> active [

	^ self namedBlocks at: activeIndex
]

{ #category : #'as yet unclassified' }
SBTabView >> activeBlock [

	^ self active block
]

{ #category : #'as yet unclassified' }
SBTabView >> activeIndex [

	^ activeIndex 
]

{ #category : #'as yet unclassified' }
SBTabView >> activeName [

	^ self active name
]

{ #category : #'as yet unclassified' }
SBTabView >> activeTab [

	^ self tabs at: activeIndex 
]

{ #category : #'as yet unclassified' }
SBTabView >> add: aNamedBlock [

	self namedBlocks add: aNamedBlock.
	activeIndex := self namedBlocks size.
	
	self updateTabs
]

{ #category : #'as yet unclassified' }
SBTabView >> addButton [

	^ SBButton new
		icon: (SBIcon iconPlus
				size: 8.0;
				color: Color green)
			label: ''
			do: [self add: (self active veryDeepCopy name: self activeName, '_copy')];
		makeSmall;
		cornerStyle: #squared;
		cellGap: -1.0 sbScaled;
		layoutInset: (4.0 @ 4.0) sbScaled
]

{ #category : #'as yet unclassified' }
SBTabView >> asTabButton: aNamedBlock [

	| button |
	button := SBButton new
		label: aNamedBlock name do: [self setActive: aNamedBlock];
		cornerStyle: #squared;
		makeSmall;
		hResizing: #spaceFill.
	
	aNamedBlock = self active ifTrue: [button makeBold].
	
	
	^ button
		changeTableLayout;
		listDirection: #leftToRight;
		addMorphBack: (self deleteButtonFor: aNamedBlock)
]

{ #category : #'as yet unclassified' }
SBTabView >> buildTabs [

	self addMorphBack: (SBRow new
		addAllMorphsBack: (self namedBlocks collect: [:block | self asTabButton: block]);
		name: #tabs;
		addMorphBack: self addButton;
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap)
]

{ #category : #'as yet unclassified' }
SBTabView >> buildView [

	self addMorphBack: self activeBlock
]

{ #category : #'as yet unclassified' }
SBTabView >> deleteButtonFor: aNamedBlock [

	| delete |
	delete := SBButton new
		icon: (SBIcon iconTimes
				size: 8;
				color: Color red)
			label: ''
			do: [self remove: aNamedBlock];
		makeSmall;
		cornerStyle: #squared;
		layoutInset: (0.0 @ 1.0) sbScaled;
		cellGap: -1.0 sbScaled.
	^ delete
]

{ #category : #'as yet unclassified' }
SBTabView >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBTabView >> initialize [

	super initialize.
	
	namedBlocks := {SBNamedBlock new} asOrderedCollection.
	activeIndex := 1.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap.
	
	self updateTabs
]

{ #category : #'as yet unclassified' }
SBTabView >> namedBlocks [

	^ namedBlocks
]

{ #category : #'as yet unclassified' }
SBTabView >> namedBlocks: aCollectionOfSBBlocks [

	namedBlocks := aCollectionOfSBBlocks asOrderedCollection.
	self updateTabs
]

{ #category : #'as yet unclassified' }
SBTabView >> newEmptyChildNear: aBlock before: aBoolean [

    ^ SBNamedBlock new
]

{ #category : #'as yet unclassified' }
SBTabView >> objectInterfaceNear: aBlock at: aSymbol [

	^ {[:o | o isKindOf: SBNamedBlock ]}
]

{ #category : #'as yet unclassified' }
SBTabView >> remove: aNamedBlock [

	((self namedBlocks indexOf: aNamedBlock) <= activeIndex) 
		ifTrue:  [activeIndex := {activeIndex - 1. 1} max]. 
	
	self namedBlocks remove: aNamedBlock ifAbsent: [].
	
	self namedBlocks ifEmpty: [^ self delete].
	
	self updateTabs
]

{ #category : #'as yet unclassified' }
SBTabView >> setActive: aNamedBlock [

	self activeTab makeSmall.
	
	activeIndex := self namedBlocks indexOf: aNamedBlock ifAbsent: 1.
	
	self updateSelectedTab
]

{ #category : #'as yet unclassified' }
SBTabView >> tabs [

	^ (self submorphNamed: #tabs) submorphs
]

{ #category : #'as yet unclassified' }
SBTabView >> updateSelectedTab [

	self lastSubmorph delete.
	
	self buildView.
	(self tabs at: activeIndex) makeBold  	
]

{ #category : #'as yet unclassified' }
SBTabView >> updateTabs [

	self submorphs copy do: #delete.
	
	self
		buildTabs;
		buildView
]
