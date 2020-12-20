actions
canJumpTo: aBlock

	^ aBlock parentSandblock containingArtefact = self containingArtefact or: [self containingArtefact notNil and: [self containingArtefact floating not]]