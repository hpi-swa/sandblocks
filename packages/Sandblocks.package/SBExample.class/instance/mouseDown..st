as yet unclassified
mouseDown: anEvent

	(anEvent yellowButtonPressed and: [lastError notNil]) ifTrue: [
		"self stopRunning."
		currentProcess debug: lastError signalerContext title: lastError asString full: true. ^ self].
	anEvent hand waitForClicksOrDrag: self event: anEvent