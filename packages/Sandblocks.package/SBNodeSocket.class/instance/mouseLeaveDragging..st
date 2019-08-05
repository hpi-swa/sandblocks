as yet unclassified
mouseLeaveDragging: anEvent

	(anEvent hand hasSubmorphs and: [anEvent hand firstSubmorph isKindOf: SBDragProxy]) ifTrue: [
		anEvent hand firstSubmorph valid: false]