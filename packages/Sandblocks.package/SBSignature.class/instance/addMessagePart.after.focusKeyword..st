as yet unclassified
addMessagePart: aString after: aMorph focusKeyword: aKeywordMorphOrNil

	| new |
	new := self textMorphFor: aString.
	self addMorph: new behind: aMorph.
	^ self addArgumentAndEditAfter: new focusKeyword: (aKeywordMorphOrNil ifNil: [aString = ':' ifTrue: [new] ifFalse: [nil]])