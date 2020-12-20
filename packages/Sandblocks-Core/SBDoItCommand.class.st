Class {
	#name : #SBDoItCommand,
	#superclass : #SBCommand,
	#instVars : [
		'do',
		'undo'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDoItCommand >> do [

	^ do ifNotNil: #value
]

{ #category : #'as yet unclassified' }
SBDoItCommand >> do: aBlock [

	do := aBlock
]

{ #category : #'as yet unclassified' }
SBDoItCommand >> undo [

	^ undo ifNotNil: #value
]

{ #category : #'as yet unclassified' }
SBDoItCommand >> undo: aBlock [

	undo := aBlock
]
