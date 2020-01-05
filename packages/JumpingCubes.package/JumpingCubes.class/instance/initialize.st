as yet unclassified
initialize
	super initialize.
	1
		to: self fieldSize
		do: [:y | 1
				to: self fieldSize
				do: [:x | self
						addMorphBack: (JCTile new tilePosition: x @ y)]].
	self submorphsDo: #findNeighbors.
	self extent: self fieldSize * 20 asPoint