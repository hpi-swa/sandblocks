Class {
	#name : #SBHistoryView,
	#superclass : #SBExploriantsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBHistoryView >> addEpoche [

	self submorphs size - 1 "buttonRow" > self maxEpoches ifTrue: [self lastSubmorph delete]. 
	
	self block addMorph: self buildEpoche atIndex: 2
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
SBHistoryView >> buildSnapshotTabView [

	^ SBTabView 
		namedBlocks: (self tabsToSnapshot
							collect: [:aTab | SBNamedBlock block: aTab snapshot named: aTab name]) 
		activeIndex: (SBExploriants uniqueInstance active wantsHistory
							ifTrue: [SBExploriants uniqueInstance activeIndex] 
							 ifFalse: [1])
	
]

{ #category : #building }
SBHistoryView >> buttons [

	^ super buttons, {self clearButton. self changeTabsButton. self saveButton }
]

{ #category : #building }
SBHistoryView >> changeTabsButton [

	^ SBButton new
		icon: SBIcon iconTable
			label: 'Change All Tabs To'
			do: [self offerChangeTabMenu];
		cornerStyle: #squared
]

{ #category : #building }
SBHistoryView >> clearButton [

	^ SBButton new
		icon: SBIcon iconClockO
			label: 'Clear History'
			do: [self clean. self block addMorphBack: self buildButtonRow];
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

{ #category : #initialization }
SBHistoryView >> initialize [ 

	super initialize.
	
	self name: 'History'.
	self buildButtonRow.
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
	
	self block submorphs allButFirst do: [:anEpoche | anEpoche lastSubmorph activeIndex: index].
]

{ #category : #building }
SBHistoryView >> saveButton [

	^ SBButton new
		icon: SBIcon iconSave
			label: 'Save As PNG'
			do: [self block exportAsPNG];
		cornerStyle: #squared
]

{ #category : #accessing }
SBHistoryView >> tabsToSnapshot [

	^ SBExploriants uniqueInstance namedBlocks select: #wantsHistory
]

{ #category : #actions }
SBHistoryView >> visualize [ 

	self addEpoche
]

{ #category : #copying }
SBHistoryView >> wantsHistory [
	
	^ false
]
