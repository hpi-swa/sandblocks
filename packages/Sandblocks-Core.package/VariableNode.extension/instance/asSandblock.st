*Sandblocks-Core
asSandblock

	^ (ClassBuilder new reservedNames includes: self name)
		ifTrue: [SBKeywordBinding new name:  self name]
		ifFalse: [SBBinding new name: self name]