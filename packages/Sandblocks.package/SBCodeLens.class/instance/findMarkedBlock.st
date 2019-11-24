as yet unclassified
findMarkedBlock

	^ self findDeepSubmorphThat: [:morph | morph isSandblock and: [morph marked]] ifAbsent: [nil]