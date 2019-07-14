as yet unclassified
initialize

	super initialize.
	
	self
		addMorphBack: (text := SBOwnTextMorph new when: #contentsChanged send: #contentsChanged to: self);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap