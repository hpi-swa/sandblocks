as yet unclassified
updateLabel

	statusLabel contents: (status caseOf: {
		[#notActive] -> ['- Not active -'].
		[#restartOnChange] -> ['- Restart on Change -'].
		[#restartOnSave] -> ['- Restart on Save -'].
		[#manualRestart] -> ['- Manual Restart -']
	})