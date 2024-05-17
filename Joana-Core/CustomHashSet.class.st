Class {
	#name : #CustomHashSet,
	#superclass : #Set,
	#category : #'Joana-Core'
}

{ #category : #'as yet unclassified' }
CustomHashSet class >> reserve: aNumber [

	^ self new
		arraySize: aNumber;
		yourself 
]

{ #category : #'as yet unclassified' }
CustomHashSet >> arraySize: aSize [

	array := self arrayType new: aSize
]
