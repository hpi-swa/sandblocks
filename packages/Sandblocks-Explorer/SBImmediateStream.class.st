Class {
	#name : #SBImmediateStream,
	#superclass : #Stream,
	#instVars : [
		'block'
	],
	#category : #'Sandblocks-Explorer'
}

{ #category : #'as yet unclassified' }
SBImmediateStream class >> with: aBlock [

	^ self basicNew
		block: aBlock;
		yourself
]

{ #category : #'as yet unclassified' }
SBImmediateStream >> block: aBlock [

	block := aBlock
]

{ #category : #'as yet unclassified' }
SBImmediateStream >> nextPut: anObject [

	block value: anObject
]
