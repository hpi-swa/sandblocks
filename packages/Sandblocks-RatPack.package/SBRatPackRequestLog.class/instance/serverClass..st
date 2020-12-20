accessing
serverClass: aRPApplicationClass

	RPApplication services
		detect: [:s | s class = aRPApplicationClass]
		ifFound: [:server |
			self service: server]
		ifNone: [self error: 'No running services for this class'].
	