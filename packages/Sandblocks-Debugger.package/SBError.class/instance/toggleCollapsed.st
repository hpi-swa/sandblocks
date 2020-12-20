as yet unclassified
toggleCollapsed

	self expanded
		ifTrue: [
			frames submorphsDo: #closed.
			frames removeAllMorphs.
			scroll delete.
			explorer ifNotNil: #delete]
		ifFalse: [self focus]