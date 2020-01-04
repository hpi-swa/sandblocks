as yet unclassified
startDrag: anEvent

	| line |
	line := SBConnector new startNow: self.
	self node owner addMorphBack: line.
	
	anEvent hand attachMorph: (SBDragProxy new line: line from: self)