as yet unclassified
hadMethodOnStack: aMethod

	^ frames anySatisfy: [:frame | frame method == aMethod]