helper
findMarkedBlock

	^ self findDeepSubmorphThat: [:morph | morph isSandblock and: [morph hasDecorator: SBMarkedDecorator]] ifAbsent: [nil]