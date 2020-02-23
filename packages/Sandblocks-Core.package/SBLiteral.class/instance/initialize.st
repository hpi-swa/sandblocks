as yet unclassified
initialize

	super initialize.
	
	castToUnknownWhenEmpty := true.
	
	self
		addMorphBack: (text := self textMorphClass new when: #contentsChanged send: #contentsChanged to: self);
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap