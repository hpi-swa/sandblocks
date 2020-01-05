as yet unclassified
lastError: anError

	lastError := anError.
	anError
		ifNotNil: [ | errorContext |
			errorIndicator ifNil: [self addMorphBack: (errorIndicator := SBIcon iconFlash large; color: Color orange)].
			errorContext := anError signalerContext findContextSuchThat: [:ctx | ctx method = self containingArtefact compiledMethod].
			(self containingArtefact blockForPC: errorContext pc - 1) attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)]
		ifNil: [
			errorIndicator ifNotNil: #delete.
			errorIndicator := nil]