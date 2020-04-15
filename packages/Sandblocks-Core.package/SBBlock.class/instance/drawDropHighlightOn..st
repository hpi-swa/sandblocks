as yet unclassified
drawDropHighlightOn: aCanvas

	self highlightedForDrop ifTrue: [
		aCanvas frameRectangle: self bounds width: 3 color: Color red]