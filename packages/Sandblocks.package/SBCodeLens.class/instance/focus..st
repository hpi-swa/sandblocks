as yet unclassified
focus: aBlock

	scroll
		visible: true;
		offset: 0 @ (aBlock top - self fadeSize max: 0);
		layoutPolicy: nil.
	self vResizing: #rigid.
	self height: (aBlock height + (self fadeSize * 2) min: (scroll firstSubmorph height - scroll offset y)) + label height.
	self width: scroll firstSubmorph width.
	aBlock marked: true