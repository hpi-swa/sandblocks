actions
replaceWithCopyBuffer

	copyBuffer ifNotNil: [
		self do: (SBReplaceCommand target: self selection replacer: copyBuffer veryDeepCopy)]