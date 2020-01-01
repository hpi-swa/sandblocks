actions
reportTypeInfo: anObject at: aContext

	self methods
		detect: [:method | method methodClass = aContext methodClass and: [method selector = aContext selector]]
		ifFound: [:method | method typeCache at: aContext pc put: anObject class]