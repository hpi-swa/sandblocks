as yet unclassified
replaceWithMessageSend

	| doIt |
	doIt := Parser new parse: self sourceString class: nil class noPattern: true notifying: nil ifFail: nil.
	
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
			replacer: (doIt block statements first expr asSandblockWithoutSubstitution pc: self pc);
			target: self)