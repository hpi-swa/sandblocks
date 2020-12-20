as yet unclassified
initRequest: dynEnv

	self
		at: #timings put: (Dictionary new
			at: #preParsing put: Time utcMicrosecondClock;
			yourself);
		at: #request put: dynEnv request;
		at: #response put: dynEnv response.
