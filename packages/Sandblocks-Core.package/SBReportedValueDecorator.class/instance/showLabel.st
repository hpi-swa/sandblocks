as yet unclassified
showLabel

	indicator ifNotNil: #delete.
	indicator := Morph new
		lock;
		addMorphBack: (Morph new
			color: (TranslucentColor r: 1 g: 1 b: 1 alpha: 0.176);
			borderStyle: (BorderStyle width: self indicatorBorderWidth color: Color yellow);
			extent: self morph extent + (self indicatorBorderWidth * 2);
			yourself);
		addMorphBack: (Morph new
			addMorph: (StringMorph new
				contents: self label;
				yourself);
			vResizing: #shrinkWrap;
			hResizing: #shrinkWrap;
			color: Color yellow;
			layoutInset: 4 withScalingFactor;
			yourself);
		bounds: (self morph boundsInWorld outsetBy: self indicatorBorderWidth);
		openInWorld;
		color: Color transparent;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #topToBottom;
		yourself