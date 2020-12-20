*Sandblocks-Core
representationsDo: aBlock

	^ SBRepresentation representationsDo: [:class | (class matches: self) ifTrue: [aBlock value: class]] for: self