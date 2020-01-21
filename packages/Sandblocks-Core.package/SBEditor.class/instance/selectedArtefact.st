as yet unclassified
selectedArtefact

	^ (self selection ifNotNil: #containingArtefact) ifNil: [self methods first]