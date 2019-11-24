as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		addMorphBack: (label := SBStringMorph new
			hResizing: #spaceFill;
			vResizing: #shrinkWrap;
			emphasis: TextEmphasis bold emphasisCode);
		addMorphBack: (scroll := TransformMorph new
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			yourself)