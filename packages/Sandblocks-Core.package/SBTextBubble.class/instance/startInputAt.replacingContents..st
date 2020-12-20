as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	cmd := (self containingArtefact ifNil: [SBInputCommand newNonEdit] ifNotNil: [:a | SBInputCommand newFor: a])
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	text moveCursorTo: aNumber.
	
	^ cmd