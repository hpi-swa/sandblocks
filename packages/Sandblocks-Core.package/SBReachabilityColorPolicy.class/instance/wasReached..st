as yet unclassified
wasReached: aBlock

	methods at: aBlock containingArtefact compiledMethod ifPresent: [:pcs | (pcs includes: aBlock pc) ifTrue: [^ true]].
	^ false