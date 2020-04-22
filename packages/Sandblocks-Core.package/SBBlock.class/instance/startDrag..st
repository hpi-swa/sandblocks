as yet unclassified
startDrag: anEvent

	super startDrag: anEvent.
	
	self sandblockEditor select: self.
	
	self flag: #fixme. " this should be made better "
	(self hasDecorator: SBMoveDecorator) ifFalse: [
		self pickUp: anEvent].
	
	"self showOverlayFor: anEvent"