as yet unclassified
matches: anObject

	self flag: #fixme. " sandblocks cannot live outside their natural habitat, but encoding this here is not nice "
	^ anObject isMorph and: [anObject isSandblock not]