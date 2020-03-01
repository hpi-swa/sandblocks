callbacks
toggleStepping

	view submorphsDo: [:morph |
		morph isStepping
			ifFalse: [morph startStepping]
			ifTrue: [morph stopStepping]]