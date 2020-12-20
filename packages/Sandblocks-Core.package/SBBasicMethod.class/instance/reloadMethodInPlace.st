as yet unclassified
reloadMethodInPlace

	self externalModification: false.
	^ self replaceBy: (self compiledMethod asSandblock position: self position)