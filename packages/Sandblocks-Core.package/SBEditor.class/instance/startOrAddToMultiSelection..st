actions
startOrAddToMultiSelection: aBlock

	mode = #selection ifTrue: [
		^ (multiSelection includes: aBlock)
			ifTrue: [self removeMultiSelected: aBlock]
			ifFalse: [self addToMultiSelection: aBlock]].
	
	self mode: #selection.
	self addToMultiSelection: aBlock