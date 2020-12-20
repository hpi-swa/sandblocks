input
maybeStartInputAt: aNumber

	inputMapping defaultState = #input ifTrue: [
		self selection currentTextMorph ifNotNil: [:textMorph |
			self startInput: self selection at: aNumber replacingContents: false]]