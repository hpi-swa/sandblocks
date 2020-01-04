as yet unclassified
valid

	[self contents asRegex] on: RegexSyntaxError do: [^ false].
	^ true