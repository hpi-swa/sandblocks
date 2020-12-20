input
maybeStartInputFromEnd

	inputMapping defaultState = #input ifTrue: [
		self startInput: self selection at: 9e8 replacingContents: false]