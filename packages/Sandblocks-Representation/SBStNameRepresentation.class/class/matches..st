as yet unclassified
matches: aBlock

	^ (aBlock respondsTo: #contents) and: [aBlock contents isString and: [aBlock contents first isLetter and: [aBlock contents viewAllButFirst allSatisfy: #isAlphaNumeric]]]