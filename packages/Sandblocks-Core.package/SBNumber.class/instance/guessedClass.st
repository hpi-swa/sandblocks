as yet unclassified
guessedClass

	^ [self parsedContents class] on: NumberParserError do: [Number]