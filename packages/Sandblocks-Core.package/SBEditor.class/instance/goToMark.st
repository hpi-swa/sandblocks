actions
goToMark

	self allBlocksDo: [:morph | (morph hasDecorator: SBMarkedDecorator) ifTrue: [^ self select: morph]]