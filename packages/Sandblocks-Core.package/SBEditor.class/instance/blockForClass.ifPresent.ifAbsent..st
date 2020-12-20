accessing
blockForClass: aClass ifPresent: aBlock ifAbsent: anotherBlock

	^ scroll submorphs detect: [:morph | morph isSandblock and: [morph isClassContainer and: [morph shownClass = aClass]]] ifFound: aBlock ifNone: anotherBlock