as yet unclassified
initialize

	super initialize.
	
	dark := false.
	hadValue := false.
	
	self
		changeTableLayout;
		listDirection: #leftToRight;
		color: Color transparent;
		cellInset: 4;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		addMorphBack: (ECSIcon iconSearch large; on: #click send: #exploreLastValue to: self);
		addMorphBack: (ECSIcon iconBar_chart large; on: #click send: #promptChangeDisplay to: self);
		useDisplay: SBDisplayPrint