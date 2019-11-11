as yet unclassified
initialize

	super initialize.
	
	dark := false.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		color: Color transparent;
		listDirection: #topToBottom;
		addMorphBack: (ECSRow new
			cellInset: (TextStyle defaultFont height / 2) floor;
			addMorphBack: (countInput := ECSNumberInput new min: 1; onChange: [:num | self count: num]);
			addMorphBack: (ECSIcon iconBar_chart large; on: #click send: #promptChangeDisplay to: self));
		count: 5