as yet unclassified
attached: aMorph

	super attached: aMorph.
	(self installEventBroadcasterFor: aMorph)
		when: #mouseMove send: #mouseMove: to: self;
		when: #mouseDown send: #mouseDown: to: self;
		when: #mouseLeave send: #mouseLeave: to: self