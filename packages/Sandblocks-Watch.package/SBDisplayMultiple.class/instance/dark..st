as yet unclassified
dark: aBoolean

	dark := aBoolean.
	self submorphs allButFirstDo: [:morph | morph dark: aBoolean]