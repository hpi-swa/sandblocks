initialization
initialize

	super initialize.
	self requestLog: LinkedList new.
	
	self
		addMorph: (SBStringMorph contents: '<no request yet>');
		addMorphBack: (SBButton new
			label: '<route not requested yet>'
			shortcut: nil
			do: [self exploreLatestRequest];
			yourself);
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap.
	self addDependent: self.