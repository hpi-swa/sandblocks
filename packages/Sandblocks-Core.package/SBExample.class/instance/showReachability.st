as yet unclassified
showReachability

	| policy |
	policy := SBReachabilityColorPolicy new.
	SBReachabilitySimulator new
		store: policy;
		simulate: [self evaluate].
	self sandblockEditor colorPolicy: policy