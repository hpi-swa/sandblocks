as yet unclassified
focus

	self expanded ifTrue: [^ self focusNextFrame].
	
	self addMorphBack: frames.
	self rootContext stack from: 1 to: self maxFrames do: [:context | frames addMorphBack: (self createFrameForContext: context)].
	frames sandblockEditor select: frames firstSubmorph