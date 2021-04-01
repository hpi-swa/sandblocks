Class {
	#name : #Sort,
	#superclass : #Object,
	#instVars : [],
	#category : #ObservableExperiment
}

{ #category : #'as yet unclassified' }
Sort >> quicksort: aCollection low: aLowNumber high: aHighNumber [

	aLowNumber < aHighNumber ifTrue: [ | p |
		p := self partition: aCollection low: aLowNumber high: aHighNumber.
		self quicksort: aCollection low: aLowNumber high: p - 1.
		self quicksort: aCollection low: p + 1 high: aHighNumber].
	^ aCollection
]

{ #category : #'as yet unclassified' }
Sort >> partition: aCollection low: aLowNumber high: aHighNumber [

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
