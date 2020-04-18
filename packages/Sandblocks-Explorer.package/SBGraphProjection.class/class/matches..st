as yet unclassified
matches: anObject

	^ anObject isCollection and: [anObject allSatisfy: [:num | num isNumber]]