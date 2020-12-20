as yet unclassified
mouseDown: anEvent

	(self relevantPosition: anEvent) ifTrue: [ | startExtent startPosition handle |
		anEvent hand future resetClickState.
		startExtent := self morph extent.
		startPosition := self morph pointInWorld: anEvent position.
		handle := HandleMorph new forEachPointDo: [:newPoint | self morph extent: startExtent + (newPoint - startPosition)].
		anEvent hand attachMorph: handle.
		handle startStepping]