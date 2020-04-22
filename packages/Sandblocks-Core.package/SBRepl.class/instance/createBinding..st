artefact protocol
createBinding: aString

	| decl |
	decl := SBDeclarationForLocalVariable new
		binding: aString -> nil;
		contents: aString;
		yourself.
	bindings addMorphBack: decl.
	self changed.
	^ decl