as yet unclassified
resetContext: aContext

	aContext ~= frames firstSubmorph context ifTrue: [ | stack dropToIndex addFromIndex |
		" find the minimal update required to reconcile our UI with the stack by looking if we can just drop or add elements "
		stack := aContext contextStack.
		dropToIndex := frames submorphs findFirst: [:frame | frame context = aContext].
		
		dropToIndex ~= 0
			ifTrue: [frames removeAllMorphsIn: (frames submorphs viewFrom: 1 to: dropToIndex - 1)]
			ifFalse: [
				addFromIndex := stack findFirst: [:contex | frames firstSubmorph context = aContext].
				addFromIndex ~= 0
					ifTrue: [frames addAllMorphsFront: ((stack viewFrom: 1 to: addFromIndex - 1) collect: [:context | self createFrameForContext: context])]
					ifFalse: [frames removeAllMorphs; addAllMorphsFront: (stack collect: [:context | self createFrameForContext: context])]]].
	
	frames firstSubmorph setActive.
	self updateExplorers