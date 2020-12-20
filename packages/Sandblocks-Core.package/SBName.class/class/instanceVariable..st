as yet unclassified
instanceVariable: aString

	^ (self contents: aString)
		behavior: SBDeclarationForInstanceVariable new;
		yourself