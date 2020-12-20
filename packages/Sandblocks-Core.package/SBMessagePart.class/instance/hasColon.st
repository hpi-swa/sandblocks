as yet unclassified
hasColon

	^ self owner ifNil: [false] ifNotNil: [self owner lastSubmorph ~= self and: [self isBinary not]]