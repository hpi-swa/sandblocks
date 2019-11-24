as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		layoutInset: 8 * self scalingFactor;
		hResizing: #shrinkWrap;
		addMorphBack: (label := SBStringMorph new
			hResizing: #spaceFill;
			vResizing: #shrinkWrap;
			emphasis: TextEmphasis bold emphasisCode);
		addMorphBack: (scroll := TransformMorph new
			color: Color white;
			layoutInset: 2 * self scalingFactor;
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself)