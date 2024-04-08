Class {
	#name : #SBHistoryView,
	#superclass : #SBExploriantsView,
	#instVars : [
		'scrollPane'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBHistoryView >> addCodeSnapshot: aChange [

	self ensureStackSize.
	
	self scroller addMorphFront: (self buildCodeSnapshot: aChange)
]

{ #category : #building }
SBHistoryView >> addEpoche [

	self ensureStackSize.
	
	self scroller addMorphFront: self buildEpoche
]

{ #category : #building }
SBHistoryView >> buildCodeSnapshot: aChange [

	| row lastVersion |
	row := self containerRow.
	
	lastVersion := (VersionsBrowser new
		scanVersionsOf: aChange item class: aChange item methodClass meta: false
		category: aChange item methodReference category selector: aChange item selector) changeList at: 2 ifAbsent: [nil].
	
	^ row
		cellGap: 0@10; 
		listDirection: #topToBottom; 
		addAllMorphsBack: {
			self buildMetaUsageIn: row. 
			(lastVersion ifNotNil: [
			(TextDiffBuilder buildDisplayPatchFrom: lastVersion text to: aChange item getSource inClass: aChange item methodClass prettyDiffs: false)] ifNil: [aChange item getSource]) asMorph
		}
	
	
]

{ #category : #building }
SBHistoryView >> buildEpoche [

	| row |
	row := self containerRow.
	^ row
		cellGap: 0@10; 
		listDirection: #topToBottom; 
		addAllMorphsBack: {self buildMetaUsageIn: row. self buildSnapshotTabView}
	
	
]

{ #category : #building }
SBHistoryView >> buildMetaUsageIn: aRow [

	^ self containerRow
		cellGap: 5@0;
		addAllMorphsBack: {self deleteEpocheButton: aRow. 
								TextMorph new contents: (Text fromString: TimeStamp current asStringOrText) allBold.
								SBLabel new contents: 'Notes'}
	
	
]

{ #category : #building }
SBHistoryView >> buildScrollPane [

	| scrollPane |
	scrollPane := ScrollPane new
		color: Color transparent;
		borderWidth: 0;
		hResizing: #spaceFill;
		scrollBarThickness: 7 sbScaled;
		showHScrollBarOnlyWhenNeeded;
		showVScrollBarOnlyWhenNeeded;
		height: 600 sbScaled.
	scrollPane scroller 
		changeTableLayout;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		layoutInset: 1;
		cellGap: 2;
		cellInset: 2.
	^ scrollPane
]

{ #category : #building }
SBHistoryView >> buildSnapshotTabView [

	^ SBTabView 
		namedBlocks: (self tabsToSnapshot
							collect: [:aTab | SBNamedBlock block: aTab snapshot named: aTab name]) 
		activeIndex: (SBExploriants uniqueInstance namedBlocks detect: #isOverview) activeIndex
	
]

{ #category : #building }
SBHistoryView >> buttons [

	^ super buttons, {self clearButton. self changeTabsButton. }
]

{ #category : #building }
SBHistoryView >> changeTabsButton [

	^ SBButton new
		icon: SBIcon iconTable
			label: 'Change All Tabs To'
			do: [self offerChangeTabMenu];
		cornerStyle: #squared
]

{ #category : #actions }
SBHistoryView >> clean [

	self scroller submorphs copy do: #delete
]

{ #category : #building }
SBHistoryView >> clearButton [

	^ SBButton new
		icon: SBIcon iconClockO
			label: 'Clear History'
			do: [self clean];
		cornerStyle: #squared
]

{ #category : #building }
SBHistoryView >> deleteEpocheButton: theRow [

	^ SBButton new
		icon: SBIcon iconTrash
			do: [theRow delete];
		balloonText: 'Delete this row';
		cornerStyle: #squared;
		makeSmall
	
	
]

{ #category : #building }
SBHistoryView >> ensureStackSize [

	self scroller submorphs size > self maxEpoches ifTrue: [self scroller lastSubmorph delete]. 
]

{ #category : #initialization }
SBHistoryView >> initialize [ 

	super initialize.
	
	self name: 'History'.
	self buildButtonRow.
	scrollPane := self buildScrollPane.
	self block addMorphBack: scrollPane.
]

{ #category : #accessing }
SBHistoryView >> isHistory [ 

	^ true
]

{ #category : #accessing }
SBHistoryView >> maxEpoches [

	^ 100
]

{ #category : #building }
SBHistoryView >> offerChangeTabMenu [

	| index options |
	options := self tabsToSnapshot collect: #name.
	index := UIManager default chooseFrom: options.
	index = 0 ifTrue: [^ self].
	
	self scroller submorphs do: [:anEpoche | anEpoche lastSubmorph activeIndex: index].
]

{ #category : #building }
SBHistoryView >> saveButton [

	^ SBButton new
		icon: SBIcon iconSave
			label: 'Save As PNG'
			do: [self scroller exportAsPNG];
		cornerStyle: #squared
]

{ #category : #accessing }
SBHistoryView >> scroller [

	^ scrollPane scroller
]

{ #category : #accessing }
SBHistoryView >> tabsToSnapshot [

	^ (SBExploriants uniqueInstance namedBlocks detect: #isOverview) views 
]

{ #category : #actions }
SBHistoryView >> visualize [ 

	self addEpoche
]
