as yet unclassified
getOrCreateLocalBinding: aString

	^ bindings submorphs
		detect: [:block | block contents = aString]
		ifNone: [ | decl |
			decl := SBDeclarationForLocalVariable new binding: aString -> nil; contents: aString; yourself.
			bindings addMorphBack: decl.
			decl]