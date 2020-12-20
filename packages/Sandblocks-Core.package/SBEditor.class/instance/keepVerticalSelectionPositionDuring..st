accessing
keepVerticalSelectionPositionDuring: aBlock

	| restore |
	restore := verticalSelectionPosition.
	aBlock ensure: [verticalSelectionPosition := restore]