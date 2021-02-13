Class {
	#name : #SBCounterStream,
	#superclass : #WriteStream,
	#instVars : [
		'count'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCounterStream class >> count: aBlock [

	| c |
	c := self basicNew initialize.
	aBlock value: c.
	^ c count
]

{ #category : #'as yet unclassified' }
SBCounterStream >> count [

	^ count
]

{ #category : #'as yet unclassified' }
SBCounterStream >> initialize [

	super initialize.
	
	count := 0
]

{ #category : #'as yet unclassified' }
SBCounterStream >> nextPut: aCharacter [

	count := count + 1
]

{ #category : #'as yet unclassified' }
SBCounterStream >> nextPutAll: aString [

	count := count + aString size
]
