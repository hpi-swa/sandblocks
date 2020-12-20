as yet unclassified
serverClass: aClass

	RPApplication services
		detect: [:s | s class = aClass]
		ifFound: [:s |
			service := s.
			self addMorphFront: (SBStringMorph new contents: service name)]
		ifNone: [self error: 'No running services for this class']