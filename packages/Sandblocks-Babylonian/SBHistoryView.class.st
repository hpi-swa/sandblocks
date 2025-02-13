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
  ^ SBHistoryEpoche new
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

	^ self buildBlock
		addAllMorphsBack: (
			self epoches 
				collect: [:anEpoche | anEpoche snapshotSatisfying: aCollectionOfSBTags]);
		yourself 
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
SBHistoryView >> isHistory [ 

	^ true
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
	
  self flag: #todo. "epoches for code snapshots should respond to same api and do nothing"
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
