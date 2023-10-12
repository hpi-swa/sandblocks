Class {
	#name : #SBDoItCommand,
	#superclass : #SBCommand,
	#instVars : [
		'do',
		'undo',
		'postDo'
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
SBDoItCommand >> morphs [

	^ {}
]

{ #category : #'as yet unclassified' }
SBDoItCommand >> postDo [

	postDo ifNotNil: [postDo value]
]

{ #category : #'as yet unclassified' }
SBDoItCommand >> postDo: aBlock [

	postDo := aBlock
]

{ #category : #'as yet unclassified' }
SBDoItCommand >> setArtefactFrom [

	^ artefact
]

{ #category : #'as yet unclassified' }
SBDoItCommand >> undo [

	^ undo ifNotNil: #value
]

{ #category : #'as yet unclassified' }
SBDoItCommand >> undo: aBlock [

	undo := aBlock
]
