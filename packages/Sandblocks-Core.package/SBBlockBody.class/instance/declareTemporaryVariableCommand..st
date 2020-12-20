as yet unclassified
declareTemporaryVariableCommand: aString

	^ (SBInsertCommand newFor: self containingArtefact)
		container: temporaries;
		index: temporaries submorphCount + 1;
		morph: (SBName contents: aString);
		yourself