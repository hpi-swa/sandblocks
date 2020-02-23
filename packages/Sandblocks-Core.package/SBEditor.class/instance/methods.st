accessing
methods

	^ scroll submorphs select: [:morph | morph isSandblock and: [morph isMethod]]