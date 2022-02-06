Class {
	#name : #SBStSymbol,
	#superclass : #SBStLiteral,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStSymbol >> browse [

	Smalltalk at: self selector asSymbol ifPresent: [:c | ^ self systemNavigation browseClass: c].
	self browseImplementors
]

{ #category : #'as yet unclassified' }
SBStSymbol >> guessedClass [

	^ Symbol
]

{ #category : #'as yet unclassified' }
SBStSymbol >> isSymbolBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBStSymbol >> keyStroke: anEvent [

	anEvent keyCharacter isSpecial
		ifTrue: [self acceptInputEvent: anEvent]
		ifFalse: [super keyStroke: anEvent]
]

{ #category : #'as yet unclassified' }
SBStSymbol >> prefix [

	^ '#'
]

{ #category : #'as yet unclassified' }
SBStSymbol >> printOn: aStream [

	aStream nextPutAll: 'symbol '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBStSymbol >> selector [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBStSymbol >> suggestions [

	super suggestions ifNotEmpty: [:s | ^ s].
	^ self contents
		ifEmpty: [#()]
		ifNotEmpty: [:text | (self sortedSuggestions: Symbol allSymbols for: text) collect: [:sel | SBSuggestionItem selector: sel label: 'symbol']]
]

{ #category : #'as yet unclassified' }
SBStSymbol >> symbols [

	^ self colorPolicy symbolsForSymbol: self
]

{ #category : #'as yet unclassified' }
SBStSymbol >> useAsMessageSend [
	<action>

	^ self sandblockEditor do: (SBReplaceCommand new
		target: self;
		replacer: (SBStMessageSend new
			receiver: (SBStName contents: 'self')
			selector: self contents asSymbol);
		yourself)
]

{ #category : #'as yet unclassified' }
SBStSymbol >> writeSourceOn: aStream [

	aStream nextPutAll: '#'.
	self contents asString storeOn: aStream
]
