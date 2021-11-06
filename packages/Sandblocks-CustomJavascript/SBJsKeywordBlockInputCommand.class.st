Class {
	#name : #SBJsKeywordBlockInputCommand,
	#superclass : #SBCommand,
	#instVars : [
		'previousContents',
		'contents',
		'morph',
		'previousOperands',
		'newMorph'
	],
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> contents: aString [

	contents := aString
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> do [

	| operands |
	newMorph contents: contents.
	(morph ~= newMorph and: [newMorph owner isNil]) ifTrue: [
		morph replaceBy: newMorph.
		^ self].
	operands := morph header.
	operands size > morph arity ifTrue: [operands from: morph arity + 1 to: operands size do: [:arg | arg delete]].
	operands size < morph arity ifTrue: [operands size + 1 to: morph arity do: [:i | morph directAddHeaderBlock]].
	^ morph header ifNotEmpty: [morph header first] ifEmpty: [morph]
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> hasChange [

	^ contents ~= previousContents
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> morph: aBlock [

	morph := aBlock
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> newMorph: aMorph [

	newMorph := aMorph
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> previousContents: aString [

	previousContents := aString
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> previousOperands: aCollection [

	previousOperands := aCollection
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> setArtefactFrom [

	^ morph
]

{ #category : #'as yet unclassified' }
SBJsKeywordBlockInputCommand >> undo [

	morph contents: previousContents.
	morph = newMorph ifFalse: [newMorph replaceBy: morph].
	morph header: previousOperands.
	^ morph
]
