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

	^ self submorphCount = 2 ifTrue: [self firstSubmorph] ifFalse: [nil]
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
SBOhmQuantifier >> isOptional [

	^ self contents = '?'
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> isQuantifier [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> isRepeatQuantifier [

	^ self contents ~= '?'
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
		data: {
			self expression ifNotNil: #layoutCommands ifNil: [SBAlgebraCommand noop].
			self currentTextMorph layoutCommands};
		morph: self
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> printOn: aStream [

	aStream
		nextPutAll: '(';
		print: self expression;
		nextPutAll: ')';
		nextPut: self quantifier
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
SBOhmQuantifier >> valid [

	^ self expression notNil
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> writeRascalSourceOn: aStream [

	self expression writeSourceOn: aStream.
	aStream nextPut: self quantifier
]

{ #category : #'as yet unclassified' }
SBOhmQuantifier >> writeSourceOn: aStream [

	self expression writeSourceOn: aStream.
	aStream nextPut: self quantifier
]
