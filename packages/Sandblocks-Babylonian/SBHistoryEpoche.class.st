Class {
	#name : #SBHistoryEpoche,
	#superclass : #SBRow,
	#instVars : [
		'deleteButton',
		'timestamp',
		'notes',
		'tabview'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBHistoryEpoche >> buildDeleteButton [

	^ SBButton new
		icon: SBIcon iconTrash
			do: [self delete];
		balloonText: 'Delete this row';
		cornerStyle: #squared;
		makeSmall
]

{ #category : #building }
SBHistoryEpoche >> buildMetaUsage [

	^ self containerRow
		addAllMorphsBack: { deleteButton := self buildDeleteButton.
			timestamp := TextMorph new contents: (Text fromString: TimeStamp current asStringOrText) allBold.
			notes := SBLabel new contents: 'Notes'}
]

{ #category : #building }
SBHistoryEpoche >> buildSnapshotTabView [

	^ SBTabView 
		namedBlocks: (
			self tabsToSnapshot
				collect: [:aTab | SBNamedBlock block: aTab snapshot named: aTab name]) 
		activeIndex: (SBExploriants uniqueInstance namedBlocks detect: #isOverview) activeIndex
	
]

{ #category : #building }
SBHistoryEpoche >> containerRow [

	^ SBRow new
		color: Color transparent;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #leftToRight;
		layoutInset: 2;
		cellGap: 5@0;
		cellInset: 2;
		borderWidth: 0
]

{ #category : #accessing }
SBHistoryEpoche >> deleteButton [

	^ deleteButton
]

{ #category : #initialization }
SBHistoryEpoche >> initialize [ 

	super initialize.
	
	self color: Color transparent;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #topToBottom;
		layoutInset: 2;
		cellGap: 0@10; 
		cellInset: 2;
		borderWidth: 0.
		
	self visualize
]

{ #category : #accessing }
SBHistoryEpoche >> notes [

	^ notes
]

{ #category : #'*Sandblocks-Babylonian' }
SBHistoryEpoche >> privateSnapshotSatisfying: aCollectionOfSBTags from: originalEpoche [

	self removeAllMorphs.
	self addAllMorphsBack: {
		self snapshotMetaUsageTimeStamp: originalEpoche timestamp notes: originalEpoche notes.
		tabview := originalEpoche tabview snapshotSatisfying: aCollectionOfSBTags}
]

{ #category : #accessing }
SBHistoryEpoche >> setIndexTo: aNewIndex [

	tabview activeIndex: aNewIndex
]

{ #category : #'*Sandblocks-Babylonian' }
SBHistoryEpoche >> snapshotMetaUsageTimeStamp: oldStamp notes: oldNotes [

	^ self containerRow
		addAllMorphsBack: { deleteButton := self buildDeleteButton.
			timestamp := TextMorph new contents: oldStamp contents.
			notes := SBLabel new contents: oldNotes contents};
		yourself
]

{ #category : #'*Sandblocks-Babylonian' }
SBHistoryEpoche >> snapshotSatisfying: aCollectionOfSBTags [

	^ self class new
		privateSnapshotSatisfying: aCollectionOfSBTags from: self
]

{ #category : #accessing }
SBHistoryEpoche >> tabsToSnapshot [

	^ (SBExploriants uniqueInstance namedBlocks detect: #isOverview) views 
]

{ #category : #accessing }
SBHistoryEpoche >> tabview [

	^ tabview
]

{ #category : #accessing }
SBHistoryEpoche >> timestamp [

	^ timestamp
]

{ #category : #building }
SBHistoryEpoche >> visualize [

	self addAllMorphsBack: {
		self buildMetaUsage. 
		tabview := self buildSnapshotTabView}
]
