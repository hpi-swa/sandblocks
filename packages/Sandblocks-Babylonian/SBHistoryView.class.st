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
SBHistoryView >> buildEpoche [

	^ SBHistoryEpoche new
	
	
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

{ #category : #building }
SBHistoryView >> clearButton [

	^ SBButton new
		icon: SBIcon iconClockO
			label: 'Clear History'
			do: [self clean. self block addMorphBack: self buildButtonRow];
		cornerStyle: #squared
]

{ #category : #accessing }
SBHistoryView >> copySatisfying: aCollectionOfSBTags [

	| interactiveCopy |
	interactiveCopy := self buildBlock.
	self block submorphs allButFirstDo: [:anEpoche |
		interactiveCopy addMorphBack: (anEpoche snapshotSatisfying: aCollectionOfSBTags)].
	^ interactiveCopy
]

{ #category : #accessing }
SBHistoryView >> epoches [

	^ self block submorphs allButFirst
]

{ #category : #initialization }
SBHistoryView >> initialize [ 

	super initialize.
	
	self name: 'History'.
	self buildButtonRow.
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
			do: [self block exportAsPNG];
		cornerStyle: #squared
]

{ #category : #accessing }
SBHistoryView >> tabsToSnapshot [

	^ (SBExploriants uniqueInstance namedBlocks detect: #isOverview) views 
]

{ #category : #actions }
SBHistoryView >> visualize [ 

	self addEpoche
]
