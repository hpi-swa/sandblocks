as yet unclassified
matches: anObject

	^ anObject isCollection and: [anObject notEmpty and: [anObject allSatisfy: [:num | num isNumber]]]