as yet unclassified
codeActions

	^ super codeActions, {
		SBCodeAction labeled: 'Debug Example' for: self do: [:node | node debug]
	}