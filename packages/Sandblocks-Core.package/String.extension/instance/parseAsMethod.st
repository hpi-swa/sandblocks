*Sandblocks-Core
parseAsMethod

	| parser class methodNode |
	SBExample self: ['test 5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: false notifying: nil ifFail: nil.
	^ methodNode