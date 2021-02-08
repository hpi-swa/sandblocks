Class {
	#name : #SBStNumberWithPrefix,
	#superclass : #SBStNumber,
	#instVars : [
		'prefix'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNumberWithPrefix >> castToUnknownWhenEmpty [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNumberWithPrefix >> keyStroke: anEvent [

	self acceptInputEvent: anEvent
]

{ #category : #'as yet unclassified' }
SBStNumberWithPrefix >> prefix: aString [

	prefix := aString
]

{ #category : #'as yet unclassified' }
SBStNumberWithPrefix >> symbols [

	^ {prefix. nil}
]
