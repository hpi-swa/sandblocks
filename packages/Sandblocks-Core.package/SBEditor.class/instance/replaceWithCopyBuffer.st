actions
replaceWithCopyBuffer

	copyBuffer ifNotNil: [ | new |
		new := (copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer]) veryDeepCopy.
		self do: ((SBReplaceCommand newFor: self selectedArtefact)
			target: self selection;
			replacer: new).
		new postDuplicate]