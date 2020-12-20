as yet unclassified
matches: anObject

	^ anObject isCollection and: [anObject notEmpty and: [anObject size < 500 and: [anObject allSatisfy: [:num | num isNumber]]]]