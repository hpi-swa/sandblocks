as yet unclassified
adaptToEdgeInsetsAndAdd: anEdgeInsets

	^ SBEdgeInsets
		left: anEdgeInsets left + self left
		right: anEdgeInsets right + self right
		top: anEdgeInsets top + self top
		bottom: anEdgeInsets bottom + self bottom