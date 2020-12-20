as yet unclassified
matches: anObject

	(anObject isString or: [anObject isText]) ifFalse: [^ false].
	
	[anObject string parseAsNode] on: SyntaxErrorNotification, UndeclaredVariableWarning do: [^ false].
	^ true