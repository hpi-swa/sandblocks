as yet unclassified
symbols

	^ type
		caseOf: {
			([#dynamic] -> [self colorPolicy symbolsForArray: self]).
			([#literal] -> [self colorPolicy symbolsForLiteralArray: self]).
			([#byte] -> [self colorPolicy symbolsForByteArray: self])
		}
		otherwise: '?'