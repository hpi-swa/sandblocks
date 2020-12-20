as yet unclassified
hadMethodOnStack: aMethod block: aClosure

	^ frames anySatisfy: [:frame | frame method = aClosure]