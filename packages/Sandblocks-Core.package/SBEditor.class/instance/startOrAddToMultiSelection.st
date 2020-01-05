actions
startOrAddToMultiSelection

	mode = #selection ifTrue: [
		^ (multiSelection includes: self selection)
			ifTrue: [
				self selection detachDecorators: SBMultiSelectionDecorator.
				multiSelection remove: self selection.
				multiSelection ifEmpty: [self mode: #command]]
			ifFalse: [self addToMultiSelection]].
	
	self addToMultiSelection.
	self mode: #selection