as yet unclassified
allUsagesDo: aBlock

	^ self behavior resolveBinding ifNotNil: [:binding | binding allUsagesDo: aBlock]