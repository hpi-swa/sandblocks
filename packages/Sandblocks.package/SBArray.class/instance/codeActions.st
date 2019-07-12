as yet unclassified
codeActions

	^ {
		SBCodeAction
			labeled: 'Change to dynamic array' for: self do: [:node | node changeTypeTo: #dynamic].
		SBCodeAction
			labeled: 'Change to byte array' for: self do: [:node | node changeTypeTo: #byte].
		SBCodeAction
			labeled: 'Change to literal array' for: self do: [:node | node changeTypeTo: #literal].
	}