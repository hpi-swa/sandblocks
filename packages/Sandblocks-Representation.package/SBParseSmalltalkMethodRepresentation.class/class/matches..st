as yet unclassified
matches: anObject

	anObject isString ifFalse: [^ false].
	
	[anObject parseAsMethod] on: SyntaxErrorNotification do: [^ false].
	^ true