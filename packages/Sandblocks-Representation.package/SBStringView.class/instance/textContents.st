as yet unclassified
textContents

	^ self firstSubmorph hasSelection ifTrue: [self firstSubmorph selection] ifFalse: [self firstSubmorph contents]