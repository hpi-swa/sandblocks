Class {
	#name : #SBJsDereference,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsDereference >> childSandblocksDo: aBlock [

	aBlock value: self lhs
]

{ #category : #'as yet unclassified' }
SBJsDereference >> contents [

	^ self rhs contents
]

{ #category : #'as yet unclassified' }
SBJsDereference >> contents: aString [

	self rhs contents: aString
]

{ #category : #'as yet unclassified' }
SBJsDereference >> currentTextMorph [

	^ self rhs
]

{ #category : #'as yet unclassified' }
SBJsDereference >> isValidCharacter: aCharacter [

	^ aCharacter isAlphaNumeric or: [aCharacter = $_]
]

{ #category : #'as yet unclassified' }
SBJsDereference >> keyStroke: anEvent [

	(self isValidCharacter: anEvent keyCharacter)
		ifTrue: [self currentTextMorph keyStroke: anEvent]
		ifFalse: [SBJsGrammarHandler new perform: anEvent keyCharacter for: self empty: false]
]

{ #category : #'as yet unclassified' }
SBJsDereference >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self lhs layoutCommands.
			SBAlgebraCommand softLine.
			SBAlgebraCommand indent data: {
				SBAlgebraCommand morph data: self submorphs second.
				self rhs layoutCommands}}
]

{ #category : #'as yet unclassified' }
SBJsDereference >> lhs [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsDereference >> lhs: aLeftBlock rhs: aPropertyString [

	self removeAllMorphs.
	self addMorphBack: aLeftBlock.
	self addMorphBack: (SBStringMorph new contents: '.').
	self addMorphBack: (SBOwnTextMorph new contents: aPropertyString)
]

{ #category : #'as yet unclassified' }
SBJsDereference >> moveCursorTo: aNumber [

	self currentTextMorph moveCursorTo: aNumber
]

{ #category : #'as yet unclassified' }
SBJsDereference >> printOn: aStream [

	aStream nextPutAll: 'member access '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBJsDereference >> rhs [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBJsDereference >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBInputCommand newOrEditFor: self containingArtefact)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean
		ifTrue: [self contents: ''; moveCursorTo: 0]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBJsDereference >> stopEditing [

	self currentTextMorph stopEditing.
	self removeSuggestionMenu
]

{ #category : #'as yet unclassified' }
SBJsDereference >> stopEditing: aCommand [

	aCommand
		newText: self contents;
		newMorph: self.
	
	self stopEditing
]

{ #category : #'as yet unclassified' }
SBJsDereference >> wantsExtraSpace [

	^ false
]
