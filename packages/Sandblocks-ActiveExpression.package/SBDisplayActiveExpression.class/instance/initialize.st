initialization
initialize

	super initialize.
	
	expressions := OrderedDictionary new.
	invocations := SBAEInvocations new
		when: #showSubscribers send: #showSubscribersOf: to: self;
		yourself.
	marbles := SBAEMarbles new
		when: #selectExpression send: #selectExpression: to: invocations;
		when: #selectSubject send: #selectSubject: to: invocations;
		yourself.
	
	self
		color: Color transparent;
		changeTableLayout;
		cellGap: 8 withScalingFactor;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		addMorphBack: marbles;
		addMorphBack: (Morph new
			color: Color lightGray;
			hResizing: #spaceFill;
			extent: (0 @ 1) withScalingFactor;
			yourself);
		addMorphBack: invocations