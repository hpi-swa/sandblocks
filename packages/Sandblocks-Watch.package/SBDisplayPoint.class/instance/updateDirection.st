as yet unclassified
updateDirection

	| canvas arrow size |
	canvas := direction form getCanvas.
	size := direction image width // 2.
	arrow := lastPoint normalized * size.
	
	canvas fillColor: Color transparent.
	canvas line: size asPoint to: size asPoint + arrow color: Color white.
	canvas fillRectangle: (size asPoint - 2 extent: 4 asPoint) color: Color white