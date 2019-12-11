as yet unclassified
newFor: anArtefact

	self assert: anArtefact notNil.
	
	^ self basicNew initialize
		artefact: anArtefact;
		yourself