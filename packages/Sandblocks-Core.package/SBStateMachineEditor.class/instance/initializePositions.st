as yet unclassified
initializePositions

	| increment states |
	states := self states.
	increment := 360 / states size.
	states withIndexDo: [:state :index | state position: (Point r: 80 * states size degrees: (increment - 1) * index) + (self extent / 2)]