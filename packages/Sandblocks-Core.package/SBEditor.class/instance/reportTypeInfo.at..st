actions
reportTypeInfo: anObject at: aContext

	self methods
		detect: [:method | method methodClass = aContext methodClass and: [method selector = aContext selector]]
		ifFound: [:method | method cacheType: anObject class for: (method blockForPC: aContext pc)]