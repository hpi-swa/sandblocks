actions
replaceWithCopyBuffer

	copyBuffer ifNotNil: [
		self do: (SBReplaceCommand target: self selection replacer: (copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer]) veryDeepCopy)]