as yet unclassified
initialize

	super initialize.
	
	hasUnsavedChanges := false.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellGap: 4 withScalingFactor;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 8 withScalingFactor;
		addMorphBack: (className := SBTextBubble new
			emphasis: TextEmphasis bold;
			layoutInset: 8 withScalingFactor;
			font: (TextStyle default fontOfPointSize: 12));
		addRow: 'SuperClass' with: (superClassName := SBClassNameInput new);
		addRow: 'Instance Variables:' with: (instanceVariables := SBArray new);
		addRow: 'Class Variables:' with: (classVariables := SBArray new);
		addRow: 'Pool Dictionaries:' with: (poolDictionaries := SBArray new);
		addRow: 'Category:' with: (category := SBTextBubble new)