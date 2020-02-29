event handling
mouseEnter: anEvent

	subjectIndicator ifNotNil: #delete.
	subjectIndicator := Morph new
		addMorphBack: (Morph new
			color: (TranslucentColor r: 1 g: 1 b: 1 alpha: 0.176);
			borderStyle: (BorderStyle width: self indicatorBorderWidth color: Color red);
			extent: subject extent + (self indicatorBorderWidth * 2);
			yourself);
		addMorphBack: (Morph new
			addMorph: (StringMorph new contents: self balloonText; yourself);
			vResizing: #shrinkWrap;
			hResizing: #shrinkWrap;
			color: Color white;
			layoutInset: 4 withScalingFactor;
			borderStyle: (BorderStyle width: 2 color: Color black);
			yourself);
		bounds: (subject boundsInWorld outsetBy: self indicatorBorderWidth);
		openInWorld;
		color: Color transparent;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #topToBottom;
		yourself