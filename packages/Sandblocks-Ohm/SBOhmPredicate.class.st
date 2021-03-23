Class {
	#name : #SBOhmPredicate,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmPredicate >> currentTextMorph [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmPredicate >> expression [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmPredicate >> expression: anExpression predicate: aCharacter [

	self addMorphBack: anExpression.
	self addMorphBack: (SBOwnTextMorph new
		contents: aCharacter asString;
		bold)
]

{ #category : #'as yet unclassified' }
SBOhmPredicate >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmPredicate >> keyStroke: anEvent [

	(#($~ $&) includes: anEvent keyCharacter)
		ifTrue: [self predicate: anEvent keyCharacter]
		ifFalse: [self grammarHandler perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBOhmPredicate >> layoutCommands [

	^ SBAlgebraCommand container
		data: {self currentTextMorph layoutCommands. self expression layoutCommands};
		morph: self
]

{ #category : #'as yet unclassified' }
SBOhmPredicate >> predicate [

	^ self currentTextMorph contents first
]

{ #category : #'as yet unclassified' }
SBOhmPredicate >> predicate: aCharacter [

	self currentTextMorph contents: aCharacter asString
]

{ #category : #'as yet unclassified' }
SBOhmPredicate >> writeSourceOn: aStream [

	aStream nextPut: self predicate.
	self expression writeSourceOn: aStream
]
