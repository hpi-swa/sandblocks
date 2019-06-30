as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	text moveCursorTo: aNumber.
	aBoolean ifTrue: [self contents: ''].
	
	^ cmd