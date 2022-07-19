"
A SBImmediateStream is a stream that immediately executes a given block on each item it receives.
"
Class {
	#name : #SBImmediateStream,
	#superclass : #Stream,
	#instVars : [
		'block',
		'position'
	],
	#category : #'Sandblocks-Utils'
}

{ #category : #'as yet unclassified' }
SBImmediateStream class >> with: aBlock [

	^ self basicNew
		initialize;
		block: aBlock;
		yourself
]

{ #category : #'as yet unclassified' }
SBImmediateStream >> block: aBlock [

	block := aBlock
]

{ #category : #'as yet unclassified' }
SBImmediateStream >> initialize [

	super initialize.
	
	position := 0
]

{ #category : #'as yet unclassified' }
SBImmediateStream >> nextPut: anObject [

	block value: anObject.
	position := position + 1
]

{ #category : #'as yet unclassified' }
SBImmediateStream >> position [

	^ position
]
