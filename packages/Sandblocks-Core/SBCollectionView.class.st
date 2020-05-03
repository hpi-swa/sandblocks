Class {
	#name : #SBCollectionView,
	#superclass : #SequenceableCollection,
	#instVars : [
		'collection',
		'end',
		'start'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCollectionView class >> on: aCollection from: aNumber to: anotherNumber [

	^ self new
		collection: aCollection;
		start: aNumber;
		end: anotherNumber;
		yourself
]

{ #category : #'as yet unclassified' }
SBCollectionView >> add: anObject [

	^ self error: 'views are read-only'
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

	collection from: start to: end do: aBlock
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
SBCollectionView >> remove: anObject ifAbsent: aBlock [

	^ self error: 'views are read-only'
]

{ #category : #'as yet unclassified' }
SBCollectionView >> size [

	^ end - start
]

{ #category : #'as yet unclassified' }
SBCollectionView >> start [

	^ start
]

{ #category : #'as yet unclassified' }
SBCollectionView >> start: anObject [

	start := anObject
]
