as yet unclassified
declareTemporaryVariableCommand: aString

	^ (SBInsertCommand newFor: self containingArtefact)
		container: temporaries;
		index: temporaries submorphCount + 1;
		morph: (SBDeclaration new name: aString);
		yourself