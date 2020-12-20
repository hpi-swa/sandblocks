as yet unclassified
click: anEvent

	super click: anEvent.
	
	(anEvent yellowButtonPressed and: [lastError notNil]) ifTrue: [ | error |
		"self stopRunning."
		error := lastError.
		self lastError: nil.
		self sandblockEditor reportError: error process: currentProcess; focusErrors.
		"currentProcess debug: error signalerContext title: error asString full: true."]