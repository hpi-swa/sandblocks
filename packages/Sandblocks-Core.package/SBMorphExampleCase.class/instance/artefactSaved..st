callbacks
artefactSaved: aMethod

	self status = #restartOnSave ifTrue: [self run]