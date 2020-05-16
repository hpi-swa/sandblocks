Extension { #name : #SequenceableCollection }

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> viewAllButFirst [

	^ SBCollectionView on: self from: 2 to: self size
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> viewFrom: aNumber to: anotherNumber [

	^ SBCollectionView on: self from: aNumber to: anotherNumber
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> withInsert: anObject at: anIndex [

	^ self copyReplaceFrom: anIndex to: anIndex - 1 with: {anObject}
]