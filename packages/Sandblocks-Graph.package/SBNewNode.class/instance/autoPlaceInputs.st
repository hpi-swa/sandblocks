as yet unclassified
autoPlaceInputs

	self inputSockets do: [:input |
		input connectedLink sourceNode
			fullBounds;
			centerRight: (input leftCenter - (50 @ 0));
			autoPlace]