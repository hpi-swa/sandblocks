as yet unclassified
stopEditing: aCommand

	aCommand newSelector: self selector.
	
	currentInputMessagePart ifNotNil: #stopEditing.
	currentInputMessagePart := nil