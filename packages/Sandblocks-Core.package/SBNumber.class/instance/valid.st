as yet unclassified
valid

	[self contents asNumber] on: NumberParserError do: [^ false].
	^ true