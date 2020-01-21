as yet unclassified
autoPlaceFlow

	| current y x |
	y := self top.
	x := self left.
	current := self.
	[current] whileNotNil: [
		current center: x @ y; fullBounds.
		current autoPlaceInputs.
		y := y + current height + 30.
		current := current flowOutSocket connectedLink ifNotNil: #targetNode]