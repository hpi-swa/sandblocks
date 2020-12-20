as yet unclassified
focus

	| stack |
	self expanded ifTrue: [^ self focusNextFrame].
	
	self addMorphBack: scroll.
	stack := self rootContext stack.
	stack from: 1 to: (self maxFrames min: stack size) do: [:context | frames addMorphBack: (self createFrameForContext: context)].
	
	frames sandblockEditor select: (frames submorphs detect: [:frame | self sandblockEditor isMethodOpen: frame context method homeMethod] ifNone: [frames firstSubmorph])