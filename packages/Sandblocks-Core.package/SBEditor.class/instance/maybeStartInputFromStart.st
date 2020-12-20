input
maybeStartInputFromStart

	inputMapping defaultState = #input ifTrue: [
		self startInput: self selection at: 0 replacingContents: false]