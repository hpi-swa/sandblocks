Class {
	#name : #SBChartRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBChartRepresentation class >> isToplevelMorph [ ^ true
]

{ #category : #'as yet unclassified' }
SBChartRepresentation class >> matches: aCollection [

	^ aCollection isNumber or: [
		aCollection isCollection and: [aCollection isCompiledCode not and: [aCollection allSatisfy: [:num | num isNumber]]]]
]

{ #category : #'as yet unclassified' }
SBChartRepresentation class >> newFor: aCollection [


	^ aCollection isNumber
		ifTrue: [SBDisplayBarChart new reportValue: aCollection]
		ifFalse: [ | chart |
			chart := SBDisplayBarChart new.
			aCollection do: [:val | chart reportValue: val].
			chart]
]

{ #category : #'as yet unclassified' }
SBChartRepresentation class >> priority [

	^ 1
]
