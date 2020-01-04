actions
startOrAddToMultiSelection

	mode = #selection ifTrue: [
		^ (multiSelection includes: self selection)
			ifTrue: [multiSelection remove: self selection]
			ifFalse: [self addToMultiSelection]].
	
	self addToMultiSelection.
	self mode: #selection