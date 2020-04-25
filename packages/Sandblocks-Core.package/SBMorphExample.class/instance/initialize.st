initialization
initialize

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout;
		layoutInset: 6 withScalingFactor;
		addMorphBack: (TransformMorph new
			hResizing: #shrinkWrap;
			vResizing: #shrinkWrap;
			changeTableLayout;
			addMorph: (view := SBSandboxPasteUpMorph new
				when: #reportError send: #reportError: to: self));
		addMorphBack: (cases := SBColumn new layoutInset: 0)