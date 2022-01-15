Class {
	#name : #SBStCharacter,
	#superclass : #SBStLiteral,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStCharacter >> absorbsInput: anEvent [

	^ (SBGrammarHandler eventValidForString: anEvent) and: [anEvent keyCharacter ~= Character tab]
]

{ #category : #'as yet unclassified' }
SBStCharacter >> keyStroke: anEvent [

	anEvent keyCharacter = Character backspace ifTrue: [
		^ self replaceWithUnknown].

	(anEvent keyCharacter shouldBePrintedAsLiteral or: [anEvent keyCharacter = Character space])
		ifTrue: [self contents: anEvent keyCharacter asString]
		ifFalse: [super keyStroke: anEvent]
]

{ #category : #'as yet unclassified' }
SBStCharacter >> prefix [

	^ self colorPolicy symbolsForCharacter: self
]

{ #category : #'as yet unclassified' }
SBStCharacter >> printOn: aStream [

	aStream nextPutAll: 'character '.
	aStream nextPut: (self contents ifNotEmpty: #first ifEmpty: $ )
]

{ #category : #'as yet unclassified' }
SBStCharacter >> symbols [

	^ self colorPolicy symbolsForCharacter: self
]

{ #category : #'as yet unclassified' }
SBStCharacter >> valid [

	^ self contents size = 1
]

{ #category : #'as yet unclassified' }
SBStCharacter >> writeSourceOn: aStream [

	aStream nextPut: $$; nextPut: (self contents ifNotEmpty: #first ifEmpty: [' '])
]
