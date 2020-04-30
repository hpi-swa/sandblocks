as yet unclassified
showLabel

	| labelMorph |
	labelMorph := Morph new
		addMorph: (StringMorph new
			contents: (self label truncateTo: 100);
			yourself);
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		color: Color yellow;
		layoutInset: 4 withScalingFactor;
		fullBounds;
		yourself.
	indicator ifNotNil: #delete.
	indicator := Morph new
		lock;
		addMorphBack: labelMorph;
		addMorphBack: (Morph new
			color: (TranslucentColor r: 1 g: 1 b: 1 alpha: 0.176);
			borderStyle: (BorderStyle width: self indicatorBorderWidth color: Color yellow);
			extent: self morph extent + (self indicatorBorderWidth * 2);
			yourself);
		bounds: ((self morph boundsInWorld outsetBy: self indicatorBorderWidth) translateBy: 0 @ labelMorph height negated);
		openInWorld;
		color: Color transparent;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #topToBottom;
		yourself