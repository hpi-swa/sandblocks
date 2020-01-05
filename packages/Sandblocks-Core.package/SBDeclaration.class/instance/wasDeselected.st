as yet unclassified
wasDeselected

	self flag: #todo. " will not clean up on changed usages "
	self allUsages do: [:b | b detachDecorators: SBHighlightDecorator]