as yet unclassified
isInCascade

	^ self owner isSandblock and: [self owner isCascade and: [self ~= self owner receiver]]