artefacts
selectToplevelTowards: aSideSymbol

	self submorphs detect: [:m | m isSandblock] ifFound: #select ifNone: []