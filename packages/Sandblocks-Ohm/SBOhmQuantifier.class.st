Class {
	#name : #SBOhmQuantifier,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> currentTextMorph [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> expression [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> expression: anExpression quantifier: aCharacter [

	self addMorphBack: anExpression.
	self addMorphBack: (SBOwnTextMorph new
		contents: aCharacter asString;
		bold)
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> keyStroke: anEvent [

	(#($+ $* $?) includes: anEvent keyCharacter)
		ifTrue: [self quantifier: anEvent keyCharacter]
		ifFalse: [self grammarHandler perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> layoutCommands [

	^ SBAlgebraCommand container
		data: {self expression layoutCommands. self currentTextMorph layoutCommands};
		morph: self
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> quantifier [

	^ self currentTextMorph contents first
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> quantifier: aCharacter [

	self currentTextMorph contents: aCharacter asString
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> writeSourceOn: aStream [

	self expression writeSourceOn: aStream.
	aStream nextPut: self quantifier
]