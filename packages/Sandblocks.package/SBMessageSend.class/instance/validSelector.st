as yet unclassified
validSelector

	^ self selector notEmpty and: [(self selector first canBeIdentifierInitial and: [self selector allSatisfy: [:c | c isAlphaNumeric or: [c = $:]]]) or: [self selector allSatisfy: #isSpecial]]