as yet unclassified
mouseDown: anEvent

	anEvent yellowButtonPressed ifTrue: [lastError ifNotNil: [currentProcess debug: lastError signalerContext title: '' full: true]. ^ self].
	anEvent hand waitForClicksOrDrag: self event: anEvent