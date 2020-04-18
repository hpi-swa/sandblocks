callbacks
attached: aMorph

	super attached: aMorph.
	
	(self installEventBroadcasterFor: aMorph)
		when: #mouseMove send: #mouseMove: to: self;
		when: #startDrag send: #startDrag: to: self;
		when: #mouseUp send: #mouseUp: to: self