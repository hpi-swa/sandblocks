as yet unclassified
initialize

	super initialize.
	
	colored := true.
	
	self
		addMorphBack: (text := SBOwnTextMorph new
			when: #contentsChanged send: #triggerEvent: to: self with: #contentsChanged);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap