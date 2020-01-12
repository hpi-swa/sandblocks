accessing
classes

	^ scroll submorphs select: [:morph | morph isSandblock and: [morph isClassContainer]]