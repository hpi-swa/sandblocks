actions
replaceWithCopyBuffer
	<action>

	| copyBuffer |
	copyBuffer := self sandblockEditor copyBuffer.
	
	copyBuffer ifNotNil: [ | new |
		new := (copyBuffer isSelection ifTrue: [copyBuffer firstSubmorph] ifFalse: [copyBuffer]) veryDeepCopy.
		
		new safeRepresentationThat: self acceptedRepresentation do: [:repr |
			self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
				target: self;
				replacer: repr).
			repr postDuplicate] ifNone: []]