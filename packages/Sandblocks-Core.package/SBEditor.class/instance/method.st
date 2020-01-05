as yet unclassified
method

	^ (self selection ifNotNil: #containingArtefact) ifNil: [self methods first]