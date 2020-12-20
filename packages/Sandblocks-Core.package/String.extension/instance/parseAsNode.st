*Sandblocks-Core
parseAsNode

	| parser class methodNode |
	SBExample self: ['5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: true notifying: nil ifFail: nil.
	^ methodNode block statements size > 1 ifTrue: [methodNode block] ifFalse: [methodNode block statements first expr]