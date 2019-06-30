as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean
		ifTrue: [self replaceWithUnknown]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd