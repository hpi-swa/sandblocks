as yet unclassified
declareTemporaryVariableCommand: aString

	^ SBInsertCommand new container: temporaries; index: temporaries submorphCount + 1; morph: (SBBinding new name: aString)