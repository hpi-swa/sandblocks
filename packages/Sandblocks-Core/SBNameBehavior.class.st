Class {
	#name : #SBNameBehavior,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNameBehavior >> actions [

	^ Array streamContents: [:stream |
		self class withAllSuperclassesDo: [:class |
			Pragma
				withPragmasIn: class
				do: [:pragma |
					(#(#action #multiSelectAction #inputAction) includes: pragma keyword) ifTrue: [stream nextPut: pragma]].
			SBNameBehavior = class ifTrue: [^ stream contents]]]
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> attached: aName [

	name := aName.
	aName currentTextMorph clearEmphasis
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> block [

	^ name
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> contents [

	^ self block contents
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> contentsChanged [
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> declareBlockVariable [
	<action>
	<actionValidIf: #noValidBinding>
	
	self block containingBlock declareTemporaryVariable: self contents
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> declareMethodVariable [
	<action>
	<actionValidIf: #noValidBinding>
	
	self block containingArtefact declareTemporaryVariable: self contents
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> detached: aBlock [

	name := nil
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> doubleClick: anEvent [
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> fixActions [

	^ #()
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> guessedClass [

	^ self block binding ifNotNil: [:b | b value class]
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> handleDroppedBlock: aBlock event: anEvent [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isBinding [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isBlockBinding [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isBooleanBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isDeclaration [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isKeyword [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isLiteralBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isMethodArgument [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isMethodLocal [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> isTemporaryVariable [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> noValidBinding [

	^ self validBinding not
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> prefix [

	^ nil
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> printBlockOn: aStream [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> resolveBinding [

	^ nil
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> symbolsFor: aColorPolicy [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> valid [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBNameBehavior >> validBinding [

	^ true
]
