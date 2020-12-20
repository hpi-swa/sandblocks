Class {
	#name : #SBCharacter,
	#superclass : #SBLiteral,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCharacter >> keyStroke: anEvent [

	anEvent keyCharacter = Character backspace ifTrue: [
		^ self replaceWithUnknown].

	(anEvent keyCharacter shouldBePrintedAsLiteral or: [anEvent keyCharacter = Character space])
		ifTrue: [self contents: anEvent keyCharacter asString]
		ifFalse: [super keyStroke: anEvent]
]

{ #category : #'as yet unclassified' }
SBCharacter >> prefix [

	^ self colorPolicy symbolsForCharacter: self
]

{ #category : #'as yet unclassified' }
SBCharacter >> printOn: aStream [

	aStream nextPutAll: 'character '.
	aStream nextPut: (self contents ifNotEmpty: #first ifEmpty: $ )
]

{ #category : #'as yet unclassified' }
SBCharacter >> symbols [

	^ self colorPolicy symbolsForCharacter: self
]

{ #category : #'as yet unclassified' }
SBCharacter >> valid [

	^ self contents size = 1
]

{ #category : #'as yet unclassified' }
SBCharacter >> writeSourceOn: aStream [

	aStream nextPut: $$; nextPut: self contents first
]
