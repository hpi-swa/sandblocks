as yet unclassified
lastError: anError

	lastError := anError.
	anError
		ifNotNil: [
			errorIndicator ifNil: [
				self addMorphBack: (errorIndicator := SBIcon iconFlash large; color: Color orange)]]
		ifNil: [
			errorIndicator ifNotNil: #delete.
			errorIndicator := nil]