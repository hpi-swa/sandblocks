as yet unclassified
startDrag: anEvent

	anEvent hand attachMorph: (SBDragProxy new
		line: (SBConnector new startNow: self; openInWorld)
		from: self)