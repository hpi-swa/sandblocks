as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	cmd := (SBInputCommand newFor: self containingMethod)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean
		ifTrue: [
			castToUnknownWhenEmpty
				ifTrue: [self replaceWithUnknown]
				ifFalse: [self contents: ''; moveCursorTo: 0]]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd