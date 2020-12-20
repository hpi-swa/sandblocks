as yet unclassified
artefactSaved: anArtefact

	super artefactSaved: anArtefact.
	
	self autoRun ifTrue: [self runTest]