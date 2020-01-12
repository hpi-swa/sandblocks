as yet unclassified
instanceVariables

	| editor |
	editor := self sandblockEditor.
	^ Array streamContents: [:stream |
		self methodClass withAllSuperclassesDo: [:class |
			editor blockForClass: class ifPresent: [:c | stream nextPutAll: c instanceVariables] ifAbsent: [
				class instVarNames do: [:name |
					stream nextPut: (SBDeclarationForInstanceVariable new
						contents: name;
						definingClass: class)]]]]