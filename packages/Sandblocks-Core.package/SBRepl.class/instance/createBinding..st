artefact protocol
createBinding: aString

	| decl |
	decl := (SBName contents: aString)
		binding: aString -> nil;
		yourself.
	bindings addMorphBack: decl.
	self changed.
	^ decl