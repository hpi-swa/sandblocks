as yet unclassified
lastError: anError

	lastError := anError.
	anError
		ifNotNil: [
			errorIndicator ifNil: [
				self addMorphBack: (errorIndicator := ECSIcon iconFlash large; color: Color orange)]]
		ifNil: [
			errorIndicator ifNotNil: #delete.
			errorIndicator := nil]