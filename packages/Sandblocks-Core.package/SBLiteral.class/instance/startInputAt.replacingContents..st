as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	cmd := (self inputCommandClass newOrEditFor: self containingArtefact)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean
		ifTrue: [
			self castToUnknownWhenEmpty
				ifTrue: [self replaceWithUnknown]
				ifFalse: [self contents: ''; moveCursorTo: 0]]
		ifFalse: [self moveCursorTo: aNumber].
	
	^ cmd