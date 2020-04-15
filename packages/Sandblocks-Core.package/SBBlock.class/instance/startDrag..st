as yet unclassified
startDrag: anEvent

	super startDrag: anEvent.
	
	self sandblockEditor select: self.
	
	self flag: #fixme. " this should be made better "
	(self hasDecorator: SBMoveDecorator) ifFalse: [
		anEvent hand attachMorph: (SBSelection new 
			methodClass: self containingArtefact;
			colorPolicy: self colorPolicy;
			addMorphBack: self veryDeepCopy)].
	
	"self showOverlayFor: anEvent"