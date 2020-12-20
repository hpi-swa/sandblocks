as yet unclassified
initialize

	super initialize.
	
	self
		useAlgebraLayout;
		cellPositioning: #topLeft;
		layoutInset: 6 withScalingFactor;
		extent: 300 @ 50;
		
		attachDecorator: SBResizableDecorator new;
		addMorphBack: (SBRow new
			layoutPolicy: nil;
			addMorphBack: (classPrefix := SBClassNameInput new suffix: ' >> '; bordered: false);
			addMorphBack: (signature := SBSignature new))