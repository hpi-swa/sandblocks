Class {
	#name : #SBTabView,
	#superclass : #SBBlock,
	#instVars : [
		'namedBlocks',
		'activeIndex',
		'isShowingDiff'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #examples }
SBTabView class >> example [

	SBMorphExample
		setUp: [self newEmpty]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 300 @ 300.
	
	
]

{ #category : #'instance creation' }
SBTabView class >> namedBlocks: aCollectionOfSBNamedBlocks activeIndex: aNumber [

	^ self new namedBlocks: aCollectionOfSBNamedBlocks
		     activeIndex: aNumber;
		     yourself 
]

{ #category : #'instance creation' }
SBTabView class >> newEmpty [

	^ self new rebuild
]

{ #category : #shortcuts }
SBTabView class >> registerShortcuts: aProvider [

	aProvider registerShortcut: $n command do: #addTab.
	aProvider registerShortcut: $w command do: #removeCurrentTab.
	aProvider registerShortcut: Character arrowLeft  do: #jumpToPrevious.
	aProvider registerShortcut: Character arrowRight  do: #jumpToNext.
	
	aProvider registerShortcut: $1 do: #jumpToFirstTab.
	aProvider registerShortcut: $2 do: #jumpToSecondTab.
	aProvider registerShortcut: $3 do: #jumpToThirdTab.
	aProvider registerShortcut: $4 do: #jumpToFourthTab.
	aProvider registerShortcut: $5 do: #jumpToFifthTab.
	aProvider registerShortcut: $6 do: #jumpToSixthTab.
	aProvider registerShortcut: $7 do: #jumpToSeventhTab.
	aProvider registerShortcut: $8 do: #jumpToEightTab.
	aProvider registerShortcut: $9 do: #jumpToNinthTab.
	
]

{ #category : #accessing }
SBTabView >> active [

	^ self namedBlocks at: activeIndex
]

{ #category : #accessing }
SBTabView >> activeBlock [

	^ self active block
]

{ #category : #accessing }
SBTabView >> activeIndex [

	^ activeIndex 
]

{ #category : #accessing }
SBTabView >> activeIndex: aNumber [ 

	self activeTab makeSmall.

	activeIndex := {aNumber. self namedBlocks size} min.

	self updateSelectedTab.
	
	self triggerEvent: #changedActive
]

{ #category : #accessing }
SBTabView >> activeName [

	^ self active name
]

{ #category : #accessing }
SBTabView >> activeTab [

	^ self tabs at: activeIndex 
]

{ #category : #tabs }
SBTabView >> add: aNamedBlock [
	
	|oldValue|
	oldValue := self namedBlocks veryDeepCopy.
	self namedBlocks add: aNamedBlock.
	
	self sandblockEditor do: (SBCombinedCommand newWith: {
		self switchCommandFor: self namedBlocks size oldValue: self activeIndex.
		(self addOrRemoveCommandFor: oldValue).
		})
]

{ #category : #ui }
SBTabView >> addButton [

	^ SBButton new
		icon: (SBIcon iconPlus
				size: 8.0 sbScaled;
				color: (Color green))
			do: [self addTab];
		makeSmall;
		cornerStyle: #squared;
		balloonText: 'Add';
		cellGap: -1.0 sbScaled;
		layoutInset: (4.0 @ 5.0) sbScaled
]

{ #category : #commands }
SBTabView >> addOrRemoveCommandFor: anOldCollectionOfNamedBlocks [

	^SBMutatePropertyCommand new 
		target: self;
		selector: #namedBlocks;
		mutateSelector: #namedBlocks:;
		oldValue: anOldCollectionOfNamedBlocks;
		value: self namedBlocks
]

{ #category : #actions }
SBTabView >> addTab [
	<action>

	self add: (self active veryDeepCopy name: self activeName, '_i')
]

{ #category : #callbacks }
SBTabView >> artefactSaved: aMethodBlock [

	(aMethodBlock = self containingArtefact and: [self isShowingDiff]) 
		ifTrue: [self updateSelectedTab]
]

{ #category : #ui }
SBTabView >> asTabButton: aNamedBlock [

	| button |
	button := SBEditableButton new
		label: aNamedBlock name do: [self setActive: aNamedBlock];
		cornerStyle: #squared;
		makeSmall;
		hResizing: #spaceFill;
		changeTableLayout;
		listDirection: #leftToRight;
		addMorphBack: (self deleteButtonFor: aNamedBlock).
	
	aNamedBlock = self active ifTrue: [button makeBold].
	button when: #contentsChanged send: #updateNameFor:on: to: self withArguments: {aNamedBlock. button}.
	button when: #doubleClicked send: #triggerEvent: to: self with: #doubleClicked.
	
	^ button
]

{ #category : #accessing }
SBTabView >> blockAt: anIndex [

	^ self namedBlocks at: anIndex
]

{ #category : #diffing }
SBTabView >> buildDiffBlockFrom: aNamedBlock to: anotherNamedBlock given: aDiffText [

	(aNamedBlock == anotherNamedBlock) ifTrue: [^ aNamedBlock block vResizing: #spaceFill].
	
	^ SBTextBubble multiLine 
		vResizing: #spaceFill;
		contents: aDiffText, 
			 (Text fromString: 
				'', Character cr,
				'==========', Character cr,
				(aNamedBlock name)) 
]

{ #category : #ui }
SBTabView >> buildTabs [

	self addMorphBack: (SBRow new
		addAllMorphsBack: (self namedBlocks collect: [:block | self asTabButton: block]);
		name: #tabs;
		addMorphBack: self addButton;
		addMorphFront: self diffButton;
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap)
]

{ #category : #ui }
SBTabView >> buildView [

	self addMorphBack:  ((self isShowingDiff 
		ifTrue: [self diffForSelected]
		ifFalse: [self activeBlock])
			hResizing: #spaceFill)
]

{ #category : #ui }
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

{ #category : #ui }
SBTabView >> diffButton [

	^ SBButton new
		icon: (SBIcon iconCodeFork size: 12.0 sbScaled)
			do: [self toggleDiffView];
		makeSmall;
		balloonText: 'Toggle diff to others';
		cornerStyle: #squared;
		cellGap: -1.0 sbScaled;
		layoutInset: (4.0 @ 3.0) sbScaled
]

{ #category : #diffing }
SBTabView >> diffForSelected [

	| diffs |
	diffs := self paddedDiffTexts.

	"Some blocks are only able to print themselves with a block as parent (eg block bodies). 
	Thats why we don't use a SBRow here"
	^ SBBlock new
		changeTableLayout;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addAllMorphsBack: (self namedBlocks withIndexCollect: [:aNamedBlock :i | 
			self buildDiffBlockFrom: aNamedBlock to: self active given: (diffs at: i)])
]

{ #category : #initialization }
SBTabView >> initialize [

	super initialize.
	
	namedBlocks := {SBNamedBlock new} asOrderedCollection.
	activeIndex := 1.
	isShowingDiff := false.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap.
]

{ #category : #accessing }
SBTabView >> isShowingDiff [

	^ isShowingDiff
]

{ #category : #accessing }
SBTabView >> isShowingDiff: aBoolean [ 

	isShowingDiff := aBoolean
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToEightTab [

	<action>
	self jumpToTab: 8
	
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToFifthTab [

	<action>
	self jumpToTab: 5
	
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToFirstTab [

	<action>
	self jumpToTab: 1
	
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToFourthTab [

	<action>
	self jumpToTab: 4
	
]

{ #category : #actions }
SBTabView >> jumpToNext [

	<action>
	self jumpToTab: self activeIndex  \\ self namedBlocks size + 1
	
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToNinthTab [

	<action>
	self jumpToTab: 9
	
]

{ #category : #actions }
SBTabView >> jumpToPrevious [

	<action>
	self jumpToTab: self activeIndex - 2 \\ self namedBlocks size + 1
	
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToSecondTab [

	<action>
	self jumpToTab: 2
	
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToSeventhTab [

	<action>
	self jumpToTab: 7
	
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToSixthTab [

	<action>
	self jumpToTab: 6
	
]

{ #category : #tabs }
SBTabView >> jumpToTab: anIndex [

	self namedBlocks at: anIndex ifPresent: [:block | self setActive: block]
	
]

{ #category : #'shortcut-utility' }
SBTabView >> jumpToThirdTab [

	<action>
	self jumpToTab: 3
	
]

{ #category : #accessing }
SBTabView >> namedBlocks [

	^ namedBlocks
]

{ #category : #accessing }
SBTabView >> namedBlocks: aCollectionOfSBNamedBlocks [

	self namedBlocks: aCollectionOfSBNamedBlocks activeIndex: namedBlocks size
]

{ #category : #accessing }
SBTabView >> namedBlocks: aCollectionOfSBNamedBlocks activeIndex: aNumber [

	namedBlocks := aCollectionOfSBNamedBlocks asOrderedCollection.
	activeIndex := {aNumber. self namedBlocks size} min.
	
	self rebuild
]

{ #category : #diffing }
SBTabView >> paddedDiffTexts [

	| diffs maxLines |
	diffs := self namedBlocks collect: [:aNamedBlock |  
		(TextDiffBuilder 
				from: (self sourceStringFor: aNamedBlock) 
				to: (self sourceStringFor: self active)) buildDisplayPatch].
			
	maxLines := (diffs collect: [:aText | aText lineCount]) max.
	
	^ diffs collect: [:aText | | paddedText |
		paddedText := aText. 
		(maxLines - aText lineCount) timesRepeat: [paddedText := paddedText, ('', Character cr)]. 
		paddedText]
]

{ #category : #ui }
SBTabView >> rebuild [

	self submorphs copy do: #delete.
	
	self
		buildTabs;
		buildView
]

{ #category : #tabs }
SBTabView >> remove: aNamedBlock [

	| oldValue newIndex oldIndex |
	(self namedBlocks size - 1 <= 0) ifTrue: [
		self triggerEvent: #deletedLastTab with: aNamedBlock veryDeepCopy.
		^ self delete].
	
	(self namedBlocks indexOf: aNamedBlock) <= self activeIndex 
		ifTrue: [newIndex := {activeIndex - 1. 1} max]
		ifFalse: [newIndex := self activeIndex].
	oldValue := self namedBlocks veryDeepCopy.
	oldIndex := self activeIndex.
	
	self namedBlocks remove: aNamedBlock ifAbsent: [].
	self sandblockEditor do: (SBCombinedCommand newWith: {
	"When removing, in order for the undo function to switch to the previous active tab,
	the remove command has to be wrapped"
		self switchCommandFor: newIndex oldValue: oldIndex.
		(self addOrRemoveCommandFor: oldValue).
		self switchCommandFor: newIndex oldValue: oldIndex.
		})

]

{ #category : #actions }
SBTabView >> removeCurrentTab [
	<action>

	self remove: self active
]

{ #category : #tabs }
SBTabView >> setActive: aNamedBlock [

	self sandblockEditor do: 
		(self switchCommandFor: (self namedBlocks indexOf: aNamedBlock ifAbsent: 1))
]

{ #category : #diffing }
SBTabView >> sourceStringFor: aNamedBlock [

	^ aNamedBlock block isBlockBody
		ifFalse: [aNamedBlock block sourceString]
		ifTrue: [ (aNamedBlock block statements collect: #sourceString)
				fold: [:a :b | a, Character cr, b]]
]

{ #category : #commands }
SBTabView >> switchCommandFor: aNumber [

	^ SBMutatePropertyCommand new
		target: self;
		selector: #activeIndex;
		mutateSelector: #activeIndex:;
		value: aNumber
]

{ #category : #commands }
SBTabView >> switchCommandFor: aNumber oldValue: oldNumber [

	^ SBMutatePropertyCommand new
		target: self;
		selector: #activeIndex;
		mutateSelector: #activeIndex:;
		value: aNumber;
		oldValue: oldNumber
]

{ #category : #accessing }
SBTabView >> tabCount [

	^ self namedBlocks size 
]

{ #category : #accessing }
SBTabView >> tabs [

	^ (self submorphNamed: #tabs) submorphs viewAllButFirstAndLast
]

{ #category : #actions }
SBTabView >> toggleDiffView [

	self isShowingDiff: self isShowingDiff not.
	self view delete.
	self buildView.
]

{ #category : #ui }
SBTabView >> updateNameFor: aNamedBlock on: aSBButton [

	aNamedBlock name: aSBButton label.
	
	"Changing the extent of a tab should not affect other tabs, 
	e.g. making a tab smaller should not make the left neighbor larger"
	self tabs do: [:aTab | aTab hResizing: #shrinkWrap]
]

{ #category : #ui }
SBTabView >> updateSelectedTab [

	self view delete.
	self buildView.
	
	(self tabs at: self activeIndex) makeBold.
	"so that bold text does not go over its borders"
	self tabs do: [:aButton | aButton widgetMorph hResizing: self hResizing]
]

{ #category : #accessing }
SBTabView >> view [

	^ self lastSubmorph
]
