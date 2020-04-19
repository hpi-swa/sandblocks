as yet unclassified
stack: aCollection matchesFrom: aNumber

	(self submorphs viewFrom: aNumber to: self submorphCount)
		with: aCollection
		do: [:frame :context | frame context = context ifFalse: [^ false]].
	^ true