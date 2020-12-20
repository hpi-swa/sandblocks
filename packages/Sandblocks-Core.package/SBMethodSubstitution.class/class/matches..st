as yet unclassified
matches: anObject

	^ anObject isCompiledMethod or: [anObject isSandblock and: [anObject isMethod]]