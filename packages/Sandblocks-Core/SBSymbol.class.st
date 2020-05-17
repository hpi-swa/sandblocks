Class {
	#name : #SBSymbol,
	#superclass : #SBLiteral,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSymbol >> browse [

	Smalltalk at: self selector asSymbol ifPresent: [:c | ^ self systemNavigation browseClass: c].
	self browseImplementors
]

{ #category : #'as yet unclassified' }
SBSymbol >> guessedClass [

	^ Symbol
]

{ #category : #'as yet unclassified' }
SBSymbol >> isSymbolBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBSymbol >> keyStroke: anEvent [

	anEvent keyCharacter isSpecial
		ifTrue: [self acceptInputEvent: anEvent]
		ifFalse: [super keyStroke: anEvent].
	
	self updateSuggestions
]

{ #category : #'as yet unclassified' }
SBSymbol >> prefix [

	^ '#'
]

{ #category : #'as yet unclassified' }
SBSymbol >> printOn: aStream [

	aStream nextPutAll: 'symbol '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBSymbol >> selector [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBSymbol >> updateSuggestions [

	| suggestions |
	suggestions := self contents
		ifEmpty: [#()]
		ifNotEmpty: [:text | (self completionSuggestionsFor: text) collect: [:sel | SBSuggestionItem selector: sel label: 'symbol']].
	self updateSuggestions: suggestions showNear: self
]

{ #category : #'as yet unclassified' }
SBSymbol >> writeSourceOn: aStream [

	aStream nextPutAll: '#'.
	self contents asString storeOn: aStream
]
