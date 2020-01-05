as yet unclassified
findMarkedBlock

	^ self findDeepSubmorphThat: [:morph | morph isSandblock and: [morph hasDecorator: SBMarkedDecorator]] ifAbsent: [nil]