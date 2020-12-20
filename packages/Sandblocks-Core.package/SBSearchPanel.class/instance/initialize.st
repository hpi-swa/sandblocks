as yet unclassified
initialize

	super initialize.
	self when: #contentsChanged send: #updateSearch to: self.
	currentFocusIndicator := SBMarkedDecorator new