Class {
	#name : #SBCharacter,
	#superclass : #SBLiteral,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCharacter >> keyStroke: anEvent [

	"anEvent keyCharacter isAlphaNumeric"true
		ifTrue: [self contents: anEvent keyCharacter asString]
		ifFalse: [super keyStroke: anEvent]
]

{ #category : #'as yet unclassified' }
SBCharacter >> prefix [

	^ '$'
]

{ #category : #'as yet unclassified' }
SBCharacter >> printOn: aStream [

	aStream nextPutAll: 'character '.
	aStream nextPut: (self contents ifNotEmpty: #first ifEmpty: $ )
]

{ #category : #'as yet unclassified' }
SBCharacter >> textContents [

	^ '$', self contents
]

{ #category : #'as yet unclassified' }
SBCharacter >> valid [

	^ self contents size = 1
]

{ #category : #'as yet unclassified' }
SBCharacter >> writeSourceOn: aStream [

	aStream nextPut: $$; nextPut: self contents first
]