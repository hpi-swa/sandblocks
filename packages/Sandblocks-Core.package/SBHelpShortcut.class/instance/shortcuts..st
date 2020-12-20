as yet unclassified
shortcuts: aCollection

	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #topToBottom;
		cellGap: 4 withScalingFactor;
		layoutInset: 2 withScalingFactor;
		color: Color white;
		borderStyle: (BorderStyle color: Color black width: 1 withScalingFactor).
	aCollection do: [:shortcutDescriptor |
		self addMorphBack: (SBRow new
			cellGap: 4 withScalingFactor;
			addMorphBack: (SBStringMorph new
				contents: shortcutDescriptor first displayString;
				bold;
				yourself);
			addMorphBack: (SBStringMorph new contents: shortcutDescriptor second))]