as yet unclassified
initialize

	super initialize.
	self
		changeTableLayout;
		layoutInset: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (SBColumn new
			cellGap: 12;
			addMorphBack: (SBRow new
				addMorphBack: SBIcon iconSave;
				cellGap: 12)).
	self class when: #cacheChanged send: #cacheChanged: to: self