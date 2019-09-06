as yet unclassified
mouseLeaveDragging: anEvent

	(anEvent hand hasSubmorphs and: [self wantsDroppedMorph: anEvent hand firstSubmorph event: SBDragProxy]) ifTrue: [
		anEvent hand firstSubmorph valid: false]