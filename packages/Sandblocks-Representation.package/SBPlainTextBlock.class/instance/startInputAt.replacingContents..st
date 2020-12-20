as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	cmd := (SBInputCommand newNonEdit)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	
	text moveCursorTo: aNumber.
	^ cmd