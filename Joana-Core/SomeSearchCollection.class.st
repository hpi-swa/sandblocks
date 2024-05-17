Class {
	#name : #SomeSearchCollection,
	#superclass : #OrderedCollection,
	#category : #'Joana-Core'
}

{ #category : #'as yet unclassified' }
SomeSearchCollection class >> numbersUpTo10000 [
	
	^ self new 
		addAll: (1 to: 10000);
		yourself
]

{ #category : #'as yet unclassified' }
SomeSearchCollection >> binarySearch: anElement [

	| index low high |
	self example: [SomeSearchCollection numbersUpTo10000] args: [{20}] label: 'small'.
	low := 1.
	high := self size.
	
	[high < low] whileFalse: [
		index := high + low // 2.
		
		anElement < (self at: index)
			ifTrue: [high := index - 1]
			ifFalse: [anElement > (self at: index) ifTrue: [low := index + 1] ifFalse: [^ index]]]
]
