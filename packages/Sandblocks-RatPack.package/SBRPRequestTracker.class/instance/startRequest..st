as yet unclassified
startRequest: dynEnv

	self lastRequest: (Dictionary new
		at: #timings put: (Dictionary new
			at: #preParsing put: Time utcMicrosecondClock;
			yourself);
		at: #request put: dynEnv request;
		at: #response put: dynEnv response;
		yourself).
