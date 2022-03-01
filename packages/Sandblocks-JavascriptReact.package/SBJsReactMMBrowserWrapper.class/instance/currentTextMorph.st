input
currentTextMorph

	^ self submorphs size > 0 ifTrue: [self firstSubmorph] ifFalse: [nil]