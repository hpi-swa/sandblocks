as yet unclassified
matches: aCollection

	^ aCollection isNumber or: [
		aCollection isCollection and: [aCollection isCompiledCode not and: [aCollection allSatisfy: [:num | num isNumber]]]]