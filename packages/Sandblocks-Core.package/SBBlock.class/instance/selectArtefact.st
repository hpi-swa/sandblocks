actions
selectArtefact
	<multiSelectAction>
	<inputAction>

	(self containingArtefact = self
		ifTrue: [self parentSandblock containingArtefact]
		ifFalse: [self containingArtefact]) ifNotNil: #select.
		
	self sandblockEditor maybeStartInputFromStart