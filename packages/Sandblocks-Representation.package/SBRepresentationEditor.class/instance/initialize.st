as yet unclassified
initialize

	super initialize.
	hasUnsavedChanges := false.
	self
		layoutInset: 4;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		addMorphBack: (SBRow new
			addMorphBack: (SBStringMorph new contents: 'Representation:');
			addMorphBack: SBTextBubble new);
		addMorphBack: (SBRow new
			addMorphBack: (SBStringMorph new contents: 'Match against: ');
			addMorphBack: (SBName new
				autoCast: false;
				contents: 'anObject';
				behavior: SBDeclarationForMethodArgument new;
				yourself));
		addMorphBack: (SBStringMorph new contents: 'Matcher:');
		addMorphBack: (SBStringMorph new contents: 'Constructor:');
		addMorphBack: (SBRow new
			addMorphBack: (SBStringMorph new contents: 'Capabilities: ');
			addMorphBack: SBArray new);
		attachDecorator: SBMoveDecorator new