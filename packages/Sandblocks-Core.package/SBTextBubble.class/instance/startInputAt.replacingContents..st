as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	cmd := (SBInputCommand newFor: self containingMethod)
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	text moveCursorTo: aNumber.
	
	^ cmd