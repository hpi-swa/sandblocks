as yet unclassified
toggleCollapsed

	| caption |
	self expanded
		ifTrue: [
			caption := self firstSubmorph.
			self submorphsDo: #closed.
			self removeAllMorphs.
			self addMorph: caption]
		ifFalse: [self focus]