as yet unclassified
resetContext: aContext

	aContext ~= self firstSubmorph context ifTrue: [ | stack dropToIndex addFromIndex |
		stack := aContext contextStack.
		dropToIndex := self submorphs findFirst: [:frame | frame context = aContext].
		
		dropToIndex ~= 0
			ifTrue: [self removeAllMorphsIn: (self submorphs viewFrom: 1 to: dropToIndex - 1)]
			ifFalse: [
				addFromIndex := stack findFirst: [:contex | self firstSubmorph context = aContext].
				addFromIndex ~= 0
					ifTrue: [self addAllMorphsFront: ((stack viewFrom: 1 to: addFromIndex - 1) collect: [:context | self createFrameForContext: context])]
					ifFalse: [self removeAllMorphs; addAllMorphsFront: (stack collect: [:context | self createFrameForContext: context])]]].
	
	self firstSubmorph setActive