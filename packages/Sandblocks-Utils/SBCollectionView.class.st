"
A SBCollectionView allows creating views on SequencableCollections without copying any data.
"
Class {
	#name : #SBCollectionView,
	#superclass : #SequenceableCollection,
	#instVars : [
		'collection',
		'end',
		'start',
		'step'
	],
	#category : #'Sandblocks-Utils'
}

{ #category : #'as yet unclassified' }
SBCollectionView class >> new: aNumber [

	^ Array new: aNumber
]

{ #category : #'as yet unclassified' }
SBCollectionView class >> on: aCollection from: aNumber to: anotherNumber [

	^ self new
		collection: aCollection;
		start: aNumber;
		end: anotherNumber;
		yourself
]

{ #category : #'as yet unclassified' }
SBCollectionView class >> on: aCollection from: aNumber to: anotherNumber by: aThirdNumber [

	^ self new
		collection: aCollection;
		start: aNumber;
		end: anotherNumber;
		step: aThirdNumber;
		yourself
]

{ #category : #'as yet unclassified' }
SBCollectionView >> add: anObject [

	^ self error: 'views are read-only'
]

{ #category : #'as yet unclassified' }
SBCollectionView >> at: aNumber [

	^ collection at: start + ((aNumber - 1) * step)
]

{ #category : #'as yet unclassified' }
SBCollectionView >> collection [

	^ collection
]

{ #category : #'as yet unclassified' }
SBCollectionView >> collection: anObject [

	collection := anObject
]

{ #category : #'as yet unclassified' }
SBCollectionView >> do: aBlock [

	start to: end by: step do: [:index |
		aBlock value: (collection at: index)]
]

{ #category : #'as yet unclassified' }
SBCollectionView >> end [

	^ end
]

{ #category : #'as yet unclassified' }
SBCollectionView >> end: anObject [

	end := anObject
]

{ #category : #'as yet unclassified' }
SBCollectionView >> initialize [

	super initialize.
	
	step := 1
]

{ #category : #'as yet unclassified' }
SBCollectionView >> remove: anObject ifAbsent: aBlock [

	^ self error: 'views are read-only'
]

{ #category : #'as yet unclassified' }
SBCollectionView >> size [

	^ end - start // step + 1
]

{ #category : #'as yet unclassified' }
SBCollectionView >> start [

	^ start
]

{ #category : #'as yet unclassified' }
SBCollectionView >> start: anObject [

	start := anObject
]

{ #category : #'as yet unclassified' }
SBCollectionView >> step [

	^ step
]

{ #category : #'as yet unclassified' }
SBCollectionView >> step: aNumber [

	step := aNumber
]
