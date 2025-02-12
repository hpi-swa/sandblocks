Extension { #name : #SBHistoryEpoche }

{ #category : #'*Sandblocks-Babylonian' }
SBHistoryEpoche >> privateSnapshotSatisfying: aCollectionOfSBTags from: originalEpoche [

	self removeAllMorphs.
	self addAllMorphsBack: {
		self snapshotMetaUsageTimeStamp: originalEpoche timestamp notes: originalEpoche notes.
		tabview snapshotSatisfying: aCollectionOfSBTags}
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
		setIndexTo: tabview activeIndex; 
		privateSnapshotSatisfying: aCollectionOfSBTags from: self
]
