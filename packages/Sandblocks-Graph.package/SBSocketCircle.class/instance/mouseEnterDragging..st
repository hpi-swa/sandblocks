as yet unclassified
mouseEnterDragging: anEvent

	(anEvent hand hasSubmorphs and: [self wantsDroppedMorph: anEvent hand firstSubmorph event: anEvent]) ifTrue: [
		anEvent hand firstSubmorph valid: true]