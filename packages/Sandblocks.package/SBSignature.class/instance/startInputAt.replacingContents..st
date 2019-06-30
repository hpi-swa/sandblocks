as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	currentInputMessagePart := self firstSubmorph.
	
	cmd := SBInputMessageCommand new
		previousSelector: currentInputMessagePart contents;
		previousArguments: self arguments;
		yourself.
	
	currentInputMessagePart moveCursorTo: aNumber.
	aBoolean ifTrue: [currentInputMessagePart contents: ''].
	
	^ cmd