as yet unclassified
toggleCollapsed

	self expanded
		ifTrue: [
			frames submorphsDo: #closed.
			frames removeAllMorphs.
			frames delete.
			explorer ifNotNil: #delete]
		ifFalse: [self focus]