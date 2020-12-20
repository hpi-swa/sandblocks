as yet unclassified
wantsDroppedMorph: aMorph event: anEvent

	^ (aMorph isKindOf: SBDragProxy) and: [aMorph type = self type]