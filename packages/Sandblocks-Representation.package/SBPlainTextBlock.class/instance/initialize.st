as yet unclassified
initialize

	super initialize.
	self
		layoutPolicy: TableLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 8;
		addMorphBack: (text := SBMultilineOwnTextMorph new);
		attachDecorator: SBMoveDecorator new