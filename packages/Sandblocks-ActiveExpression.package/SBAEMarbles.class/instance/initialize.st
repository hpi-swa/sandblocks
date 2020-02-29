initialization
initialize

	super initialize.
	
	self
		 color: Color transparent;
		 changeTableLayout;
		 hResizing: #spaceFill;
		 vResizing: #shrinkWrap;
		 listDirection: #leftToRight;
		 cellPositioning: #topLeft;
		 wrapDirection: #leftToRight;
		 minimumWidth: 200 withScalingFactor;
		 extent: 0 @ 0;
		 cellGap: 2 withScalingFactor