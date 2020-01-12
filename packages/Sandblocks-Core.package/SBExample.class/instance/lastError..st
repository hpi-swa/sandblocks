as yet unclassified
lastError: anError

	lastError := anError.
	anError
		ifNotNil: [
			errorIndicator ifNil: [self addMorphBack: (errorIndicator := SBIcon iconFlash large; color: Color orange)].
			
			(anError signalerContext
				findContextSuchThat: [:ctx | ctx method = self containingArtefact compiledMethod])
				ifNotNil: [:errorContext |
					(self containingArtefact blockForPC: errorContext previousPc)
						ifNotNil: [:b | b attachDecorator: (errorDecorator := SBErrorDecorator new message: anError asString)]]]
		ifNil: [
			errorIndicator ifNotNil: #delete.
			errorIndicator := nil]