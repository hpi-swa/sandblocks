as yet unclassified
poolDeclaration: aString

	^ (self contents: aString)
		behavior: SBDeclarationForPoolVariable new;
		yourself