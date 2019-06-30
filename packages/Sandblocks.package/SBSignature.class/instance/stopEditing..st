as yet unclassified
stopEditing: aCommand

	aCommand
		newSelector: self selector;
		newArguments: self arguments.
	
	currentInputMessagePart ifNotNil: #stopEditing.
	currentInputMessagePart := nil