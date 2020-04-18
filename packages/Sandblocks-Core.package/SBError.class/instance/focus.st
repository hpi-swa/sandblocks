as yet unclassified
focus

	self expanded ifTrue: [^ self focusNextFrame].
	process suspendedContext stack allButFirstDo: [:context | self addMorphBack: (self createFrameForContext: context)].
	self sandblockEditor select: self firstSubmorph