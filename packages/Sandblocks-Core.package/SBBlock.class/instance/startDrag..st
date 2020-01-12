as yet unclassified
startDrag: anEvent

	super startDrag: anEvent.
	
	self sandblockEditor select: self.
	"self showOverlayFor: anEvent"