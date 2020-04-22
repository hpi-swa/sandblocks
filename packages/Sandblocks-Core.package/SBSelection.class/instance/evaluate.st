as yet unclassified
evaluate

	^ self submorphCount = 1
		ifTrue: [self firstSubmorph evaluate]
		ifFalse: [self submorphs collect: #evaluate]