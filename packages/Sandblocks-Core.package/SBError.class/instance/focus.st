as yet unclassified
focus

	self expanded ifTrue: [^ self focusNextFrame].
	self rootContext stack allButFirstDo: [:context | self addMorphBack: (self createFrameForContext: context)].
	self sandblockEditor select: self firstSubmorph