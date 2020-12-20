as yet unclassified
object

	^ self submorphCount > 1
		ifTrue: [
			SBBlockBody new statements: (self submorphs collect: [:morph | morph object])]
		ifFalse: [self firstSubmorph object]