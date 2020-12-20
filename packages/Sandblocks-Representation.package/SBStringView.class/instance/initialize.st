as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: TableLayout new;
		listDirection: #topToBottom;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBMultilineOwnTextMorph new
			cursor: 1;
			hResizing: #spaceFill;
			when: #selectionChanged send: #updateSelectionLabels to: self;
			yourself);
		addMorphBack: (SBRow new
			cellGap: 4;
			addMorphBack: (SBNumberWithPrefix new prefix: 'Start: ');
			addMorphBack: (SBNumberWithPrefix new prefix: 'Stop: ');
			addMorphBack: (SBNumberWithPrefix new prefix: 'Length: '));
		updateSelectionLabels