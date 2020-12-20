as yet unclassified
toggleRestart

	self status: (self status = #restartOnSave ifTrue: [#manualRestart] ifFalse: [#restartOnSave])