*Sandblocks-Core
adaptToEdgeInsetsAndAdd: anEdgeInsets

	^ SBEdgeInsets
		left: anEdgeInsets left + self
		right: anEdgeInsets right + self
		top: anEdgeInsets top + self
		bottom: anEdgeInsets bottom + self