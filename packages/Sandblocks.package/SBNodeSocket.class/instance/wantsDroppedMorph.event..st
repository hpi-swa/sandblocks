as yet unclassified
wantsDroppedMorph: aMorph event: anEvent

	self haltOnce.
	(aMorph isKindOf: SBDragProxy) ifTrue: [
		aMorph connectTo: self.
		^ true].
	^ false