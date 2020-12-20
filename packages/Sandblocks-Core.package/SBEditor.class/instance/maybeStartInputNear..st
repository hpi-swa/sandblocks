input
maybeStartInputNear: aPoint

	inputMapping defaultState = #input ifTrue: [
		self selection currentTextMorph ifNotNil: [:textMorph |
			self startInput: self selection at: (textMorph cursorIndexForPosition: aPoint) replacingContents: false]]