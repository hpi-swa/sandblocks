as yet unclassified
attached: aMorph

	super attached: aMorph.
	
	(self installEventBroadcasterFor: aMorph)
		when: #mouseLeave send: #mouseLeave: to: self;
		when: #mouseMove send: #mouseMove: to: self