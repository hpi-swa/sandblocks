as yet unclassified
initialize

	super initialize.
	selectedIndex := 1.
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellGap: 4;
		layoutInset: 4;
		addDropShadow;
		addMorphBack: (SBStringMorph new
			contents: 'Change Repr:';
			bold);
		addMorphBack: (SBTextBubble new
			prefix: 'Filter: ';
			when: #dismiss send: #close to: self;
			when: #contentsChanged send: #updateFilter to: self;
			"when: #stopEditing send: #close to: self;"
			when: #keyStroke send: #filterKeyStroke: to: self);
		addMorphBack: (scroll := ScrollPane new
			hResizing: #shrinkWrap;
			vResizing: #rigid;
			height: 150).
	
	scroll scroller addMorphBack: (options := SBColumn new)