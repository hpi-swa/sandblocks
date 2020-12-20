*Sandblocks-Core
parseAsSandblockWithoutSubstitution

	| parser class methodNode |
	SBExample self: ['5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: true notifying: nil ifFail: nil.
	^ methodNode block statements first expr asSandblockWithoutSubstitution