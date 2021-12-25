Class {
	#name : #SBExecutionEnvironment,
	#superclass : #ProcessLocalVariable,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBExecutionEnvironment class >> getAllIn: aBlock [

	^ Array streamContents: [:stream | aBlock allBlocksDo: [:b | b providesExecutionEnvironment ifTrue: [stream nextPut: b]]]
]

{ #category : #'as yet unclassified' }
SBExecutionEnvironment class >> value: anObject during: aBlock [

	| old |
	old := self value.
	^ [self value: anObject. aBlock value] ensure: [self value: old]
]
