actions
childSandblocksDo: aBlock

	scroll submorphsDo: [:b | b isSandblock ifTrue: [aBlock value: b]]