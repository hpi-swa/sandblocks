as yet unclassified
updatePositions

	| increment |
	increment := 360 / states size.
	states doWithIndex: [:state :index | state position: (Point r: 100 degrees: (increment - 1) * index) + (self extent / 2)]