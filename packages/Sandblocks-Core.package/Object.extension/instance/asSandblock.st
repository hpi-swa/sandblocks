*Sandblocks-Core
asSandblock

	SBDataProjection allSubclassesDo: [:class | (class matches: self) ifTrue: [^ class new object: self]].
	^ SBExplorer on: self