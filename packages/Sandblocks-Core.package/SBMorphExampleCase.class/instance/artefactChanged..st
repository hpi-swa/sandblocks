as yet unclassified
artefactChanged: aMethod

	self status = #restartOnChange
		ifTrue: [self run]