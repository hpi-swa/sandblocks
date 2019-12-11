as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	currentInputMessagePart := self firstSubmorph.
	
	cmd := (SBInputMessageCommand newFor: self containingSandblock containingMethod)
		messageSend: self containingSandblock;
		previousSelector: self selector;
		previousArguments: self arguments;
		yourself.
	
	currentInputMessagePart moveCursorTo: aNumber.
	aBoolean ifTrue: [currentInputMessagePart contents: ((currentInputMessagePart contents includes: $:) ifTrue: [':'] ifFalse: [''])].
	
	^ cmd