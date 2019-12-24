as yet unclassified
initialize

	super initialize.
	
	selectedCategoryIndex := 1.
	selectedClassIndex := 0.
	selectedMethodIndex := 0.
	currentPanelIndex := 1.
	
	self
		height: 200;
		changeTableLayout;
		addDropShadow;
		vResizing: #rigid;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		addMorphBack: (categories := (PluggableListMorphPlus
			on: self
			list: #categories
			selected: #selectedCategoryIndex
			changeSelected: #selectedCategoryIndex:
			menu: #menu:evaluate:)
				vResizing: #spaceFill;
				width: 200;
				yourself);
		addMorphBack: (classes := (PluggableListMorphPlus
			on: self
			list: #classes
			selected: #selectedClassIndex
			changeSelected: #selectedClassIndex:
			menu: #menu:evaluate:)
				getIconSelector: #classIconAt:;
				vResizing: #spaceFill;
				width: 200;
				yourself);
		addMorphBack: (messages := (PluggableListMorphPlus
			on: self
			list: #methods
			selected: #selectedMethodIndex
			changeSelected: #selectedMethodIndex:
			menu: #menu:evaluate:)
				getIconSelector: #messageIconAt:;
				vResizing: #spaceFill;
				width: 200;
				yourself).