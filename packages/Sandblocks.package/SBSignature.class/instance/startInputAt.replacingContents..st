as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	currentInputMessagePart := self firstSubmorph.
	
	cmd := SBInputMessageCommand new
		messageSend: self owner;
		previousSelector: self selector;
		previousArguments: self arguments;
		yourself.
	
	currentInputMessagePart moveCursorTo: aNumber.
	aBoolean ifTrue: [currentInputMessagePart contents: ''].
	
	^ cmd