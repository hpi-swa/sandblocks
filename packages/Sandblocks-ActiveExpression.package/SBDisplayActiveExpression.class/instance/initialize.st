as yet unclassified
initialize

	super initialize.
	
	expressions := OrderedDictionary new.
	invocations := SBAEInvocations new
		when: #showSubscribers send: #showSubscribersOf: to: self;
		when: #filterMorph send: #filterMorph to: self;
		yourself.
	marbles := SBAEMarbles new
		when: #selectExpression send: #selectExpression: to: invocations;
		yourself.
	
	self
		color: Color transparent;
		changeTableLayout;
		cellGap: 8 * self scaleFactor;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		addMorphBack: marbles;
		addMorphBack: (Morph new
			color: Color lightGray;
			hResizing: #spaceFill;
			extent: 0 @ 1 withScalingFactor;
			yourself);
		addMorphBack: invocations