as yet unclassified
saveTryFixing: aFixBoolean quick: aQuickBoolean

	self on: self label evaluate.
	self select.
	self toggleCollapsed.
	^ true