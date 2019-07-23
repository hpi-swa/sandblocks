as yet unclassified
createExample: aString

	^ SBRegexExample new
		regex: self;
		contents: aString