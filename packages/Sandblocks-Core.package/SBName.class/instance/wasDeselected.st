as yet unclassified
wasDeselected

	self flag: #todo. " will not clean up on changed usages "
	self isInWorld ifTrue: [
		self allUsagesDo: [:b | b detachDecorators: SBHighlightDecorator]]