as yet unclassified
initialize

	super initialize.
	
	self
		attachDecorator: SBMoveDecorator new;
		changeTableLayout;
		layoutInset: 8;
		cellGap: 16;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBRow new addMorphBack: (title := SBStringMorph new large));
		addMorphBack: (shortcutsList := SBRow new cellGap: 8);
		addMorphBack: (steps := SBColumn new
			cellGap: 8;
			yourself);
		addMorphBack: (buttons := SBRow new
			hResizing: #spaceFill;
			cellGap: 8;
			changeTableLayout;
			addMorphBack: (SBButton new
				balloonText: 'Reset Task';
				icon: SBIcon iconRefresh shortcut: nil do: [self reset]);
			addMorphBack: (Morph new
				hResizing: #spaceFill;
				height: 0))