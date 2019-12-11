as yet unclassified
codeActions

	^ super codeActions, {
		SBCodeAction labeled: 'Not active' for: self do: [:node | node status: #notActive].
		SBCodeAction labeled: 'Restart on save' for: self do: [:node | node status: #restartOnSave].
		SBCodeAction labeled: 'Restart on change' for: self do: [:node | node status: #restartOnChange].
		SBCodeAction labeled: 'Manual restart' for: self do: [:node | node status: #manualRestart].
	}