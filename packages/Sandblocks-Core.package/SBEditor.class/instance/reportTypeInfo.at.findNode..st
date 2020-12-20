actions
reportTypeInfo: anObject at: aContext findNode: aBlock

	self methods
		detect: [:method | method methodClass = aContext methodClass and: [method selector = aContext selector]]
		ifFound: [:method | method cacheType: anObject class for: (aBlock value: method)]