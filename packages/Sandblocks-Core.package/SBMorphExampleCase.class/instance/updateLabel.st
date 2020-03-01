helper
updateLabel

	statusLabel contents: (status caseOf: {
		[#restartOnSave] -> ['- Restart on Save -'].
		[#manualRestart] -> ['- Manual Restart -']
	})