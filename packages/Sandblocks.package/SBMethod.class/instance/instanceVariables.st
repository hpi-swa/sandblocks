as yet unclassified
instanceVariables

	^ Array streamContents: [:stream |
		self class withAllSuperclassesDo: [:class |
			class instVarNames do: [:name |
				stream nextPut: (SBDeclarationForInstanceVariable new
					contents: name;
					definingClass: class)]]]