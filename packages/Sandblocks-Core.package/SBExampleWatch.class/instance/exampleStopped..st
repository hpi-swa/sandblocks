as yet unclassified
exampleStopped: anExample

	exampleValues at: anExample ifPresent: [:val |
		self removeMorph: val.
		exampleValues removeKey: anExample]