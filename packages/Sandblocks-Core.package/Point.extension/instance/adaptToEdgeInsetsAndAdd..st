*Sandblocks-Core
adaptToEdgeInsetsAndAdd: anEdgeInsets

	^ SBEdgeInsets
		left: anEdgeInsets left + self x
		right: anEdgeInsets right + self x
		top: anEdgeInsets top + self y
		bottom: anEdgeInsets bottom + self y