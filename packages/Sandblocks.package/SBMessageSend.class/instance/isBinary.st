as yet unclassified
isBinary

	^ self selector notEmpty and: [self selector allSatisfy: #isSpecial]