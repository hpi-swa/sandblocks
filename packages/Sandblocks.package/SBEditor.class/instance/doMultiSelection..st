actions
doMultiSelection: aBlock

	self do: (aBlock value: self sortedMultiSelection).
	mode = #selection ifTrue: [self endMultiSelection]