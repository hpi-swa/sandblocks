helper
reportSideEffectTo: anObject named: aString value: anotherString

	sideEffects add: {
		aString.
		anObject.
		anotherString.
		self relevantFramesFrom: currentContext}