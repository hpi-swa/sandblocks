accessing
initialize

	super initialize.
	self
		listDirection: #topToBottom;
		addMorphBack: (SBRow new
			layoutInset: 4;
			addMorphBack: (SBStringMorph new
				contents: 'examples';
				bold));
		addMorphBack: (SBRow new
			cellGap: 8;
			layoutInset: 4;
			yourself)