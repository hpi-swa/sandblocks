as yet unclassified
wrapInMessageSend: anEvent

	self messageSend isExpression ifFalse: [^ self].
	
	self sandblockEditor endInput.
	^ self messageSend wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])