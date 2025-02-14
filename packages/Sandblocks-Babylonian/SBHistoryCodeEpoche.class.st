Class {
	#name : #SBHistoryCodeEpoche,
	#superclass : #SBHistoryEpoche,
	#instVars : [
		'diff'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBHistoryCodeEpoche class >> buildFromChange: aChange [

	^ self new
		change: aChange;
		yourself
]

{ #category : #building }
SBHistoryCodeEpoche >> change: aChange [

	| lastVersion |
	
	lastVersion := (VersionsBrowser new
		scanVersionsOf: aChange item class: aChange item methodClass meta: false
		category: aChange item methodReference category selector: aChange item selector) changeList at: 2 ifAbsent: [nil].
	
	self addAllMorphsBack: {
		self buildMetaUsage. 
		diff := (lastVersion ifNotNil: [
			TextDiffBuilder 
				buildDisplayPatchFrom: lastVersion text 
				to: aChange item getSource 
				inClass: aChange item methodClass 
				prettyDiffs: false] 
		ifNil: [aChange item getSource]) asMorph}
]

{ #category : #accessing }
SBHistoryCodeEpoche >> diff [

	^ diff
]

{ #category : #'*Sandblocks-Babylonian' }
SBHistoryCodeEpoche >> privateSnapshotSatisfying: aCollectionOfSBTags from: originalEpoche [

	self removeAllMorphs.
	self addAllMorphsBack: {
		self snapshotMetaUsageTimeStamp: originalEpoche timestamp notes: originalEpoche notes.
		diff := originalEpoche diff snapshotSatisfying: aCollectionOfSBTags}
]

{ #category : #accessing }
SBHistoryCodeEpoche >> setIndexTo: aNewIndex [

	"Do nothing"
]

{ #category : #building }
SBHistoryCodeEpoche >> visualize [

	"Do nothing, only visualize by calling #change:"
]
