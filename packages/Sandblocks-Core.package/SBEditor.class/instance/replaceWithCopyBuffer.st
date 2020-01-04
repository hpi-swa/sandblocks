actions
replaceWithCopyBuffer

	copyBuffer ifNotNil: [
		self do: ((SBReplaceCommand newFor: self method)
			target: self selection;
			replacer: (copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer]) veryDeepCopy)]