as yet unclassified
focus

	| stack |
	self expanded ifTrue: [^ self focusNextFrame].
	
	self addMorphBack: frames.
	stack := self rootContext stack.
	stack from: 1 to: (self maxFrames min: stack size) do: [:context | frames addMorphBack: (self createFrameForContext: context)].
	frames sandblockEditor select: frames firstSubmorph