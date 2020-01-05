as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	| cmd |
	currentInputMessagePart := self firstSubmorph.
	
	cmd := (SBInputMessageCommand newFor: self containingSandblock containingArtefact)
		messageSend: self containingSandblock;
		previousSelector: self selector;
		previousArguments: self arguments;
		yourself.
	
	currentInputMessagePart moveCursorTo: aNumber.
	(aBoolean or: [currentInputMessagePart contents = SBMessageSend placeholderSelector]) ifTrue: [currentInputMessagePart contents: ((currentInputMessagePart contents includes: $:) ifTrue: [':'] ifFalse: [''])].
	
	^ cmd