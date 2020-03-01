callbacks
wasSelected

	self isExpanded ifTrue: [self collapseCompletely] ifFalse: [self expand]