Class {
	#name : #SBCyclicList,
	#superclass : #Object,
	#instVars : [
		'array',
		'cursor'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCyclicList >> add: aNumber [

	array at: cursor put: aNumber.
	cursor := cursor + 1.
	cursor > array size ifTrue: [cursor := 1]
]

{ #category : #'as yet unclassified' }
SBCyclicList >> clear [

	cursor := 0.
	array := Array new: array size withAll: 0
]

{ #category : #'as yet unclassified' }
SBCyclicList >> contents [

	^ Array streamContents: [:stream |
		self do: [:value | stream nextPut: value]]
]

{ #category : #'as yet unclassified' }
SBCyclicList >> do: aBlock [

	array from: cursor to: array size do: aBlock.
	array from: 1 to: cursor - 1 do: aBlock
]

{ #category : #'initialize-release' }
SBCyclicList >> initialize [

	super initialize.
	
	array := {0}.
	self size: 10
]

{ #category : #'as yet unclassified' }
SBCyclicList >> last [

	^ array at: (cursor = 1 ifTrue: [array size] ifFalse: [cursor - 1])
]

{ #category : #'as yet unclassified' }
SBCyclicList >> max [

	^ array max
]

{ #category : #'as yet unclassified' }
SBCyclicList >> reverseDo: aBlock [

	self contents reverseDo: aBlock
]

{ #category : #'as yet unclassified' }
SBCyclicList >> reverseWithIndexDo: aBlock [

	| index |
	index := 1.
	self reverseDo: [:value | aBlock value: value value: index.
		index := index + 1]
]

{ #category : #accessing }
SBCyclicList >> size [

	^ array size
]

{ #category : #'as yet unclassified' }
SBCyclicList >> size: aNumber [
	
	| newArray |
	(newArray := (Array new: aNumber withAll: 0)).
	(newArray replaceFrom: (((aNumber - (array size)) + 1) max: 1) to: (newArray size) with: array startingAt: ((((array size) - aNumber) + 1) max: 1)).
	(array := newArray).
	(cursor := (array size - 1))
]

{ #category : #'as yet unclassified' }
SBCyclicList >> withIndexDo: aBlock [

	| index |
	index := 1.
	self do: [:value | aBlock value: value value: index.
		index := index + 1]
]
