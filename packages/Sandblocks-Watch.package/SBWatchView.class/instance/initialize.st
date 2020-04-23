as yet unclassified
initialize

	super initialize.
	
	dark := false.
	hadValue := false.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		color: Color transparent;
		cellGap: 8;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		addMorphBack: (SBIcon iconSearch
			large;
			on: #click send: #exploreLastValue to: self;
			balloonText: 'Explore last value';
			yourself);
		addMorphBack: (SBIcon iconBar_chart
			large;
			on: #click send: #promptChangeDisplay to: self;
			balloonText: 'Change display type';
			yourself);
		addMorphBack: (count := SBBadge new
			contents: '0';
			balloonText: 'Number of reported values';
			yourself);
		useDisplay: SBDisplayPrint