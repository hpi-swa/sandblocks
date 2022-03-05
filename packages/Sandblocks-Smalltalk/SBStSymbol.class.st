Class {
	#name : #SBStSymbol,
	#superclass : #SBStLiteral,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #actions }
SBStSymbol >> browse [

	Smalltalk at: self selector asSymbol ifPresent: [:c | ^ self systemNavigation browseClass: c].
	self browseImplementors
]

{ #category : #accessing }
SBStSymbol >> guessedClass [

	^ Symbol
]

{ #category : #testing }
SBStSymbol >> isSymbolBlock [

	^ true
]

{ #category : #'event handling' }
SBStSymbol >> keyStroke: anEvent [

	anEvent keyCharacter isSpecial
		ifTrue: [self acceptInputEvent: anEvent]
		ifFalse: [super keyStroke: anEvent]
]

{ #category : #accessing }
SBStSymbol >> prefix [

	^ '#'
]

{ #category : #printing }
SBStSymbol >> printOn: aStream [

	aStream nextPutAll: 'symbol '; nextPutAll: self contents
]

{ #category : #accessing }
SBStSymbol >> selector [

	^ self contents
]

{ #category : #suggestions }
SBStSymbol >> suggestions [

	super suggestions ifNotEmpty: [:s | ^ s].
	^ self contents ifEmpty: [#()] ifNotEmpty: [:text |
		self containingArtefact
			artefactCompletionSuggestionsForSymbol: self
			matching: text]
]

{ #category : #'colors and color policies' }
SBStSymbol >> symbols [

	^ self colorPolicy symbolsForSymbol: self
]

{ #category : #actions }
SBStSymbol >> useAsMessageSend [
	<action>

	^ self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBStMessageSend new
			receiver: (SBStName contents: 'self')
			selector: self contents asSymbol);
		yourself)
]

{ #category : #printing }
SBStSymbol >> writeSourceOn: aStream [

	aStream nextPutAll: '#'.
	self contents asString storeOn: aStream
]
