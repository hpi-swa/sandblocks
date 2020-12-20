as yet unclassified
rejectsEvent: anEvent

	^ anEvent isMouse not or: [
		anEvent isMouseDown not or: [(self handlesMouseDown: anEvent) not]]