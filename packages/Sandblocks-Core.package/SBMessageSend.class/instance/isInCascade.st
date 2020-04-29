as yet unclassified
isInCascade

	^ (self owner ifNotNil: #isSandblock ifNil: [false]) and: [self owner isCascade and: [self ~= self owner receiver]]