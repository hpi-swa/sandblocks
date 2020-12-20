as yet unclassified
handleRequestTracking: aSBRPRequestTracker

	(self handlerSelector = aSBRPRequestTracker handler) ifTrue: [
		self requestLog addLast: aSBRPRequestTracker.
		self changed: #lastRequest].