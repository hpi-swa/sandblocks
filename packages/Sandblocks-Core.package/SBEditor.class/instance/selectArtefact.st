actions
selectArtefact

	self select: (self selection containingArtefact = self selection
		ifTrue: [self selection parentSandblock containingArtefact]
		ifFalse: [self selection containingArtefact])