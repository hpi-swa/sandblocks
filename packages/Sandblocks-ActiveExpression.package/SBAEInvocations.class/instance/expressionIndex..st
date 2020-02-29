accessing
expressionIndex: aNumber
	" index into our OrderedDictionary of the currently displayed active expression "

	expressionIndex = aNumber ifTrue: [^ self].
	
	invocations removeAllMorphs.
	invocations addAllMorphs: (expressions atIndex: aNumber) value.
	expressionIndex value: aNumber.
	marble
		subject: self currentExpression subject;
		value: self currentExpression lastValue