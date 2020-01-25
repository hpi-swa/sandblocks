as yet unclassified
expressionIndex: aNumber

	invocations removeAllMorphs.
	invocations addAllMorphs: (expressions atIndex: aNumber) value.
	expressionIndex value: aNumber.
	marble
		subject: self currentExpression subject;
		value: self currentExpression lastValue