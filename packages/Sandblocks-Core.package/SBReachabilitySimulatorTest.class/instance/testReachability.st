as yet unclassified
testReachability

	| policy m |
	m := SBReachabilitySimulatorTest >> #exampleMethod.
	policy := SBReachabilityColorPolicy new.
	SBReachabilitySimulator new
		store: policy;
		simulate: [self exampleMethod].
	
	self assert: (policy reached: 101 in: m) description: 'Loop starter'.
	self assert: (policy reached: (m literalAt: 2) -> 35 in: m) description: 'Send in loop'.
	self assert: (policy reached: 111 in: m) description: 'True case'.
	self deny: (policy reached: 115 in: m) description: 'True case'.
	self assert: (policy reached: 120 in: m) description: 'Assignment'