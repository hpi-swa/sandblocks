accessing
codeActions

	^ super codeActions, {
		SBCodeAction labeled: 'Restart on save' for: self do: [:node | node status: #restartOnSave].
		SBCodeAction labeled: 'Manual restart' for: self do: [:node | node status: #manualRestart].
	}