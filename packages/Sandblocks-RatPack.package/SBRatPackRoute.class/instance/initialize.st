actions input
initialize

	super initialize.
	
	self
		addMorphBack: (SBRow new
			layoutPolicy: SBAlgebraLayout new;
			addMorphBack: (SBMethodSelect new object: #get);
			addMorphBack: SBArray new;
			addMorphBack: (SBSignature new hResizing: #spaceFill));
		layoutInset: 4;
		attachDecorator: SBResizableDecorator new