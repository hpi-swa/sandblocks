as yet unclassified
nextResult

	| start |
	start := currentFocus ifNil: [self sandblockEditor].
	self
		searchFrom: start
		ifNone: [start ~= self sandblockEditor ifTrue: [self searchFrom: self sandblockEditor ifNone: [nil]]]