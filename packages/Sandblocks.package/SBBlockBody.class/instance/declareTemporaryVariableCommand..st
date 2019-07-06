as yet unclassified
declareTemporaryVariableCommand: aString

	^ SBInsertCommand new container: temporaries; index: temporaries submorphCount + 1; morph: (SBDeclaration new name: aString)