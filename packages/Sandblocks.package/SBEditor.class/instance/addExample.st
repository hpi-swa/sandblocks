actions
addExample

	self selection ifNotNil: [:selected | selected isExample ifTrue: [^ selected toggleRunning]].
	
	self do: (SBInsertCommand new
		container: self method body;
		index: 3;
		morph: (SBExample new
			self: (SBMessageSend new
				receiver: (SBBinding new contents: self method methodClass name)
				selector: #new)
			args: SBArray new))