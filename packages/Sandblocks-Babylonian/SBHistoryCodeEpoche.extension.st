Extension { #name : #SBHistoryCodeEpoche }

{ #category : #'*Sandblocks-Babylonian' }
SBHistoryCodeEpoche >> privateSnapshotSatisfying: aCollectionOfSBTags from: originalEpoche [

	self removeAllMorphs.
	self addAllMorphsBack: {
		self snapshotMetaUsageTimeStamp: originalEpoche timestamp notes: originalEpoche notes.
		diff := originalEpoche diff snapshotSatisfying: aCollectionOfSBTags}
]
