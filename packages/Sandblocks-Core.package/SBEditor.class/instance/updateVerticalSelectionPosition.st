selection
updateVerticalSelectionPosition

	verticalSelectionPosition := selection center x - (selection containingArtefact ifNotNil: [:a | a left] ifNil: [0]).