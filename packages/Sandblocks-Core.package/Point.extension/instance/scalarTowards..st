*Sandblocks-Core
scalarTowards: aSymbol

	aSymbol = #left ifTrue: [^ self x].
	aSymbol = #right ifTrue: [^ self x negated].
	aSymbol = #top ifTrue: [^ self y].
	aSymbol = #bottom ifTrue: [^ self y].
	self error: 'invalid side'