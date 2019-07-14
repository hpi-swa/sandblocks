as yet unclassified
replaceWithMessageSend

	| doIt |
	doIt := Parser new parse: self sourceString class: nil class noPattern: true notifying: nil ifFail: nil.
	
	self sandblockEditor do: (SBReplaceCommand new
			replacer: (doIt block statements first expr asMessageSandblock pc: self pc);
			target: self)