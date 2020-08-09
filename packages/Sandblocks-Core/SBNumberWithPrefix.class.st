Class {
	#name : #SBNumberWithPrefix,
	#superclass : #SBNumber,
	#instVars : [
		'prefix'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNumberWithPrefix >> castToUnknownWhenEmpty [

	^ false
]

{ #category : #'as yet unclassified' }
SBNumberWithPrefix >> keyStroke: anEvent [

	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBNumberWithPrefix >> prefix: aString [

	prefix := aString
]

{ #category : #'as yet unclassified' }
SBNumberWithPrefix >> symbols [

	^ {prefix. nil}
]
