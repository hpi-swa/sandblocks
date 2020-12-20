*Sandblocks-Core
parseAsMethodFor: aClass

	| parser methodNode |
	SBExample self: ['test 5 + 12 squared'] args: [{}] label: 'simple'.
	parser := aClass newParser.
	methodNode := parser parse: self class: aClass noPattern: false notifying: nil ifFail: nil.
	^ methodNode