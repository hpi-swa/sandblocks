Class {
	#name : #SBSortExample,
	#superclass : #Object,
	#category : #'Sandblocks-Tutorial'
}

{ #category : #'forward declarations' }
SBSortExample class >> partition: aCollection low: aLowNumber high: aHighNumber [

	| pivot i |
	pivot := aCollection at: aHighNumber.
	i := aLowNumber - 1.
	aLowNumber to: aHighNumber - 1 do: [:j |
		(aCollection at: j) <= pivot ifTrue: [
				i := i + 1.
				aCollection swap: i with: j]].
	aCollection swap: i + 1 with: aHighNumber.
	^ i + 1
]

{ #category : #'forward declarations' }
SBSortExample class >> quicksort: aCollection low: aLowNumber high: aHighNumber [

	aLowNumber < aHighNumber ifTrue: [ | p |
		p := self partition: aCollection low: aLowNumber high: aHighNumber.
		self quicksort: aCollection low: aLowNumber high: p - 1.
		self quicksort: aCollection low: p + 1 high: aHighNumber].
	^ aCollection
]

{ #category : #'forward declarations' }
SBSortExample class >> swap: anIndex with: anotherIndex [
]

{ #category : #sorting }
SBSortExample >> partition: aCollection low: aLowNumber high: aHighNumber [
]

{ #category : #sorting }
SBSortExample >> quicksort: aCollection low: aLowNumber high: aHighNumber [
]
