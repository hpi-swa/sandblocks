converting
childSandblocks

	^ self hasSubmorphs ifTrue: [{self firstSubmorph. self submorphs third}] ifFalse: [#()]