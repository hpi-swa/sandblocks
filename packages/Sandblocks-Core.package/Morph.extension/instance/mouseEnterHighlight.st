*Sandblocks-Core
mouseEnterHighlight

	| indicatorBorderWidth subject |
	indicatorBorderWidth := 4 withScalingFactor.
	subject := self valueOfProperty: #highlightMorphSubject.
	self valueOfProperty: #morphHighlightPopup ifPresentDo: #delete.
	self setProperty: #morphHighlightPopup toValue: (Morph new
		 addMorphBack: (Morph new
			 color: (TranslucentColor r: 1 g: 1 b: 1 alpha: 0.176);
			 borderStyle: (BorderStyle width: indicatorBorderWidth color: Color red);
			 extent: subject extent + (indicatorBorderWidth * 2);
			 yourself);
		 addMorphBack: (Morph new
			 addMorph: (StringMorph new contents: self balloonText);
			 vResizing: #shrinkWrap;
			 hResizing: #shrinkWrap;
			 color: Color white;
			 layoutInset: 4 withScalingFactor;
			 borderStyle: (BorderStyle width: 2 color: Color black));
		 bounds: (subject boundsInWorld outsetBy: indicatorBorderWidth);
		 openInWorld;
		 color: Color transparent;
		 cellPositioning: #topLeft;
		 changeTableLayout;
		 listDirection: #topToBottom;
		yourself)