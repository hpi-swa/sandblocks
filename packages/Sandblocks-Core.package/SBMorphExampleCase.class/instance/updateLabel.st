as yet unclassified
updateLabel

	statusLabel contents: (status caseOf: {
		[#restartOnSave] -> ['- Restart on Save -'].
		[#manualRestart] -> ['- Manual Restart -']
	})