as yet unclassified
newOrEditFor: anArtefactOrNil

	^ self basicNew initialize
		artefact: anArtefactOrNil;
		wasEdit: anArtefactOrNil notNil;
		yourself