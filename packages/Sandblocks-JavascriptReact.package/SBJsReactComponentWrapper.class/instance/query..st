querying
query: aQueryString

	self reactComponent
		queryRecursiveFirstMatch: aQueryString
		capturesDo: [:captures | ^ captures at: 'identifier'].
	^ nil