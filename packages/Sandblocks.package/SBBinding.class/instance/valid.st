as yet unclassified
valid

	^ self contents notEmpty
		and: [self contents first isLetter]
		and: [self contents from: 1 to: self contents size do: [:c | (c isAlphaNumeric or: [c = $_]) ifFalse: [^ false]]. true]