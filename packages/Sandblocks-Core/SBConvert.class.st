Class {
	#name : #SBConvert,
	#superclass : #Object,
	#instVars : [
		'success',
		'objectInterface'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBConvert >> do: aBlock [

	^ success value: aBlock value
]

{ #category : #'as yet unclassified' }
SBConvert >> if: aBlock do: anotherBlock [

	^ aBlock value ifTrue: [success value: anotherBlock value]
]

{ #category : #'as yet unclassified' }
SBConvert >> objectInterface [

	^ objectInterface
]

{ #category : #'as yet unclassified' }
SBConvert >> objectInterface: aCollection [

	objectInterface := aCollection
]

{ #category : #'as yet unclassified' }
SBConvert >> success: aBlock [

	success := aBlock
]
