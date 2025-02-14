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
	
	self scroller addMorphFront: (SBHistoryCodeEpoche new change: aChange)
]

{ #category : #building }
SBHistoryView >> addEpoche [

	self ensureStackSize.
	
	self scroller addMorphFront: SBHistoryEpoche new
]

{ #category : #accessing }
SBHistoryView >> backtrackForExample: aSBExample [

	^ self copySatisfying: {SBTag newFromExample: aSBExample}
]

{ #category : #accessing }
SBHistoryView >> backtrackForPermutationName: aString [

	^ self copySatisfying: {SBTag new permutationName: aString}
]

{ #category : #accessing }
SBHistoryView >> backtrackForWatch: aSBWatch [

	^ self copySatisfying: {SBTag newFromWatch: aSBWatch}
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

{ #category : #accessing }
SBHistoryView >> copySatisfying: aCollectionOfSBTags [

	| newScrollPane block |
	newScrollPane := self buildScrollPane.
	block := self buildBlock.
	block addMorphBack: newScrollPane.
	newScrollPane 
		hResizing: #shrinkWrap;
		width: scrollPane width.
	newScrollPane scroller addAllMorphsBack: (self epoches 
				collect: [:anEpoche | anEpoche snapshotSatisfying: aCollectionOfSBTags]).
	^ block
]

{ #category : #building }
SBHistoryView >> ensureStackSize [

	self scroller submorphs size > self maxEpoches ifTrue: [self scroller lastSubmorph delete]. 
]

{ #category : #accessing }
SBHistoryView >> epoches [

	^ self scroller submorphs
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
SBHistoryView >> isHistoryView [

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
	
	self epoches do: [:anEpoche | anEpoche setIndexTo: index].
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
