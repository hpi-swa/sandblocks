as yet unclassified
reportTypeInfo: anObject at: aContext

	editor reportTypeInfo: anObject at: ((SBCodeContext for: aContext sender) decrementPC: (aContext selector numArgs - 1 max: 0))