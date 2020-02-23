as yet unclassified
initialState: aState

	previous := initialState.
	initialState := aState.
	aState layoutChanged.
	previous layoutChanged