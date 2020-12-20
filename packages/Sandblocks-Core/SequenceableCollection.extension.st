Extension { #name : #SequenceableCollection }

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> atPingPong: aNumber [

	| index |
	SBExample self: [{1. 2. 3. 4}] args: [{5}] label: 'example'.
	SBExample self: [{1. 2. 3. 4}] args: [{16}] label: 'example 2'.
	
	index := ((aNumber - 1) \\ ((self size * 2) - 2)) + 1.
	
	^ self at: (index > self size ifTrue: [(self size * 2) - index] ifFalse: [index])
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> collect: elementBlock separatedBy: separatorBlock [

	^ self species streamContents: [:stream |
		1 to: self size do: [:index |
			index = 1 ifFalse: [stream nextPut: separatorBlock value].
			stream nextPut: (elementBlock value: (self at: index))]]
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> viewAllButFirst [

	^ SBCollectionView on: self from: 2 to: self size
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> viewAllButFirstAndLast [

	^ SBCollectionView on: self from: 2 to: self size - 1
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> viewAllButLast [

	^ SBCollectionView on: self from: 1 to: self size - 1
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> viewFrom: aNumber to: anotherNumber [

	^ SBCollectionView on: self from: aNumber to: anotherNumber
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> viewFrom: aNumber to: anotherNumber by: aThirdNumber [

	^ SBCollectionView on: self from: aNumber to: anotherNumber by: aThirdNumber
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> with: otherCollection and: thirdCollection do: threeArgBlock [

	self isOfSameSizeCheck: otherCollection.
	self isOfSameSizeCheck: thirdCollection.
	
	1 to: self size do: [:index |
		threeArgBlock value: (self at: index) value: (otherCollection at: index) value: (thirdCollection at: index)]
]

{ #category : #'*Sandblocks-Core' }
SequenceableCollection >> withInsert: anObject at: anIndex [

	^ self copyReplaceFrom: anIndex to: anIndex - 1 with: {anObject}
]
